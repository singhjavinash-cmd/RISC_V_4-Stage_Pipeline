module if_id_register(
    input clk,
    input reset,
    input enable,
    input [31:0] pc_in,
    input [31:0] instruction_in,
    output reg [31:0] pc_out,
    output reg [31:0] instruction_out
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            pc_out <= 32'b0;
            instruction_out <= 32'b0;
        end
        else if (enable) begin
            pc_out <= pc_in;
            instruction_out <= instruction_in;
        end
    end

endmodule


module id_exmem_register(
    input clk,
    input reset,
    input enable,

    input [31:0] pc_in,
    input [31:0] operand_a_in,
    input [31:0] operand_b_in,
    input [31:0] immediate_in,
    input [4:0] rd_in,

    input reg_write_in,
    input mem_read_in,
    input mem_write_in,
    input mem_to_reg_in,
    input alu_src_in,
    input [3:0] alu_control_in,

    output reg [31:0] pc_out,
    output reg [31:0] operand_a_out,
    output reg [31:0] operand_b_out,
    output reg [31:0] immediate_out,
    output reg [4:0] rd_out,

    output reg reg_write_out,
    output reg mem_read_out,
    output reg mem_write_out,
    output reg mem_to_reg_out,
    output reg alu_src_out,
    output reg [3:0] alu_control_out
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            pc_out <= 32'b0;
            operand_a_out <= 32'b0;
            operand_b_out <= 32'b0;
            immediate_out <= 32'b0;
            rd_out <= 5'b0;

            reg_write_out <= 1'b0;
            mem_read_out <= 1'b0;
            mem_write_out <= 1'b0;
            mem_to_reg_out <= 1'b0;
            alu_src_out <= 1'b0;
            alu_control_out <= 4'b0;
        end
        else if (enable) begin
            pc_out <= pc_in;
            operand_a_out <= operand_a_in;
            operand_b_out <= operand_b_in;
            immediate_out <= immediate_in;
            rd_out <= rd_in;

            reg_write_out <= reg_write_in;
            mem_read_out <= mem_read_in;
            mem_write_out <= mem_write_in;
            mem_to_reg_out <= mem_to_reg_in;
            alu_src_out <= alu_src_in;
            alu_control_out <= alu_control_in;
        end
    end

endmodule


module mem_wb_register(
    input clk,
    input reset,

    input [31:0] alu_result_in,
    input [31:0] memory_data_in,
    input [4:0] rd_in,
    input reg_write_in,
    input mem_to_reg_in,

    output reg [31:0] alu_result_out,
    output reg [31:0] memory_data_out,
    output reg [4:0] rd_out,
    output reg reg_write_out,
    output reg mem_to_reg_out
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            alu_result_out <= 32'b0;
            memory_data_out <= 32'b0;
            rd_out <= 5'b0;
            reg_write_out <= 1'b0;
            mem_to_reg_out <= 1'b0;
        end
        else begin
            alu_result_out <= alu_result_in;
            memory_data_out <= memory_data_in;
            rd_out <= rd_in;
            reg_write_out <= reg_write_in;
            mem_to_reg_out <= mem_to_reg_in;
        end
    end

endmodule