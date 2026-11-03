module riscv_top(
    input clk,
    input reset
);

    // ---------------- IF Stage ----------------
    wire [31:0] pc;
    wire [31:0] next_pc;
    wire [31:0] instruction;
    wire [31:0] if_id_pc;
    wire [31:0] if_id_instruction;

    program_counter PC (
        .clk(clk),
        .reset(reset),
        .pc_enable(1'b1),
        .next_pc(next_pc),
        .pc(pc)
    );

    instruction_memory IMEM (
        .pc(pc),
        .instruction(instruction)
    );

    if_id_register IF_ID (
        .clk(clk),
        .reset(reset),
        .enable(1'b1),
        .pc_in(pc),
        .instruction_in(instruction),
        .pc_out(if_id_pc),
        .instruction_out(if_id_instruction)
    );

    assign next_pc = pc + 32'd4;

    // ---------------- ID Stage ----------------
    wire [6:0] opcode;
    wire [4:0] rs1, rs2, rd;
    wire [2:0] funct3;
    wire [6:0] funct7;

    assign opcode = if_id_instruction[6:0];
    assign rd     = if_id_instruction[11:7];
    assign funct3 = if_id_instruction[14:12];
    assign rs1    = if_id_instruction[19:15];
    assign rs2    = if_id_instruction[24:20];
    assign funct7 = if_id_instruction[31:25];

    wire [31:0] read_data1;
    wire [31:0] read_data2;
    wire [31:0] write_back_data;
    wire reg_write;

    wire [4:0] mem_wb_rd;
    wire mem_wb_reg_write;

    register_file RF (
        .clk(clk),
        .rs1(rs1),
        .rs2(rs2),
        .rd(mem_wb_rd),
        .write_data(write_back_data),
        .reg_write(mem_wb_reg_write),
        .read_data1(read_data1),
        .read_data2(read_data2)
    );

    wire mem_read;
    wire mem_write;
    wire mem_to_reg;
    wire alu_src;
    wire branch;
    wire jump;
    wire [3:0] alu_control;

    control_unit CU (
        .opcode(opcode),
        .funct3(funct3),
        .funct7(funct7),
        .reg_write(reg_write),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .mem_to_reg(mem_to_reg),
        .alu_src(alu_src),
        .branch(branch),
        .jump(jump),
        .alu_control(alu_control)
    );

    wire [31:0] immediate;

    immediate_generator IMM_GEN (
        .instruction(if_id_instruction),
        .immediate(immediate)
    );

    // ---------------- ID/EXMEM Pipeline Register ----------------
    wire [31:0] id_exmem_pc;
    wire [31:0] id_exmem_operand_a;
    wire [31:0] id_exmem_operand_b;
    wire [31:0] id_exmem_immediate;
    wire [4:0] id_exmem_rd;

    wire id_exmem_reg_write;
    wire id_exmem_mem_read;
    wire id_exmem_mem_write;
    wire id_exmem_mem_to_reg;
    wire id_exmem_alu_src;
    wire [3:0] id_exmem_alu_control;

    id_exmem_register ID_EXMEM (
        .clk(clk),
        .reset(reset),
        .enable(1'b1),
        .pc_in(if_id_pc),
        .operand_a_in(read_data1),
        .operand_b_in(read_data2),
        .immediate_in(immediate),
        .rd_in(rd),
        .reg_write_in(reg_write),
        .mem_read_in(mem_read),
        .mem_write_in(mem_write),
        .mem_to_reg_in(mem_to_reg),
        .alu_src_in(alu_src),
        .alu_control_in(alu_control),
        .pc_out(id_exmem_pc),
        .operand_a_out(id_exmem_operand_a),
        .operand_b_out(id_exmem_operand_b),
        .immediate_out(id_exmem_immediate),
        .rd_out(id_exmem_rd),
        .reg_write_out(id_exmem_reg_write),
        .mem_read_out(id_exmem_mem_read),
        .mem_write_out(id_exmem_mem_write),
        .mem_to_reg_out(id_exmem_mem_to_reg),
        .alu_src_out(id_exmem_alu_src),
        .alu_control_out(id_exmem_alu_control)
    );

    // ---------------- EX/MEM Stage ----------------
    wire [31:0] alu_operand_b;
    wire [31:0] alu_result;
    wire zero_flag;
    wire [31:0] data_memory_read_data;

    assign alu_operand_b = id_exmem_alu_src
                         ? id_exmem_immediate
                         : id_exmem_operand_b;

    alu ALU (
        .operand_a(id_exmem_operand_a),
        .operand_b(alu_operand_b),
        .alu_control(id_exmem_alu_control),
        .alu_result(alu_result),
        .zero_flag(zero_flag)
    );

    data_memory DMEM (
        .clk(clk),
        .address(alu_result),
        .write_data(id_exmem_operand_b),
        .write_mask(4'b1111),
        .mem_write(id_exmem_mem_write),
        .mem_read(id_exmem_mem_read),
        .read_data(data_memory_read_data)
    );

    // ---------------- MEM/WB Stage ----------------
    wire [31:0] mem_wb_alu_result;
    wire [31:0] mem_wb_memory_data;
    wire mem_wb_mem_to_reg;

    mem_wb_register MEM_WB (
        .clk(clk),
        .reset(reset),
        .alu_result_in(alu_result),
        .memory_data_in(data_memory_read_data),
        .rd_in(id_exmem_rd),
        .reg_write_in(id_exmem_reg_write),
        .mem_to_reg_in(id_exmem_mem_to_reg),
        .alu_result_out(mem_wb_alu_result),
        .memory_data_out(mem_wb_memory_data),
        .rd_out(mem_wb_rd),
        .reg_write_out(mem_wb_reg_write),
        .mem_to_reg_out(mem_wb_mem_to_reg)
    );

    assign write_back_data = mem_wb_mem_to_reg
                           ? mem_wb_memory_data
                           : mem_wb_alu_result;

endmodule