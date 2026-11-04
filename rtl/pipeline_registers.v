
`timescale 1ns/1ps

//====================================================
// IF/ID Pipeline Register
//====================================================
module if_id_register (
    input clk,
    input reset,
    input enable,
    input flush,

    input [31:0] pc_in,
    input [31:0] instruction_in,

    output reg [31:0] pc_out,
    output reg [31:0] instruction_out
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            pc_out          <= 32'b0;
            instruction_out <= 32'h00000013; // NOP
        end
        else if (flush) begin
            pc_out          <= 32'b0;
            instruction_out <= 32'h00000013; // NOP
        end
        else if (enable) begin
            pc_out          <= pc_in;
            instruction_out <= instruction_in;
        end
    end

endmodule


//====================================================
// ID/EXMEM Pipeline Register
//====================================================
module id_exmem_register (
    input clk,
    input reset,
    input enable,

    input [31:0] pc_in,
    input [31:0] operand_a_in,
    input [31:0] operand_b_in,
    input [31:0] immediate_in,

    input [4:0] rs1_in,
    input [4:0] rs2_in,
    input [4:0] rd_in,

    input reg_write_in,
    input mem_read_in,
    input mem_write_in,
    input mem_to_reg_in,
    input alu_src_in,
    input jump_in,
    input [3:0] alu_control_in,

    output reg [31:0] pc_out,
    output reg [31:0] operand_a_out,
    output reg [31:0] operand_b_out,
    output reg [31:0] immediate_out,

    output reg [4:0] rs1_out,
    output reg [4:0] rs2_out,
    output reg [4:0] rd_out,

    output reg reg_write_out,
    output reg mem_read_out,
    output reg mem_write_out,
    output reg mem_to_reg_out,
    output reg alu_src_out,
    output reg jump_out,
    output reg [3:0] alu_control_out
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            pc_out          <= 32'b0;
            operand_a_out   <= 32'b0;
            operand_b_out   <= 32'b0;
            immediate_out   <= 32'b0;

            rs1_out         <= 5'b0;
            rs2_out         <= 5'b0;
            rd_out          <= 5'b0;

            reg_write_out   <= 1'b0;
            mem_read_out    <= 1'b0;
            mem_write_out   <= 1'b0;
            mem_to_reg_out  <= 1'b0;
            alu_src_out     <= 1'b0;
            jump_out        <= 1'b0;
            alu_control_out <= 4'b0;
        end
        else if (enable) begin
            pc_out          <= pc_in;
            operand_a_out   <= operand_a_in;
            operand_b_out   <= operand_b_in;
            immediate_out   <= immediate_in;

            rs1_out         <= rs1_in;
            rs2_out         <= rs2_in;
            rd_out          <= rd_in;

            reg_write_out   <= reg_write_in;
            mem_read_out    <= mem_read_in;
            mem_write_out   <= mem_write_in;
            mem_to_reg_out  <= mem_to_reg_in;
            alu_src_out     <= alu_src_in;
            jump_out        <= jump_in;
            alu_control_out <= alu_control_in;
        end
    end

endmodule


//====================================================
// MEM/WB Pipeline Register
//====================================================
module mem_wb_register (
    input clk,
    input reset,

    input [31:0] pc_in,
    input [31:0] alu_result_in,
    input [31:0] memory_data_in,

    input [4:0] rd_in,
    input reg_write_in,
    input mem_to_reg_in,
    input jump_in,

    output reg [31:0] pc_out,
    output reg [31:0] alu_result_out,
    output reg [31:0] memory_data_out,

    output reg [4:0] rd_out,
    output reg reg_write_out,
    output reg mem_to_reg_out,
    output reg jump_out
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            pc_out          <= 32'b0;
            alu_result_out  <= 32'b0;
            memory_data_out <= 32'b0;

            rd_out          <= 5'b0;
            reg_write_out   <= 1'b0;
            mem_to_reg_out  <= 1'b0;
            jump_out        <= 1'b0;
        end
        else begin
            pc_out          <= pc_in;
            alu_result_out  <= alu_result_in;
            memory_data_out <= memory_data_in;

            rd_out          <= rd_in;
            reg_write_out   <= reg_write_in;
            mem_to_reg_out  <= mem_to_reg_in;
            jump_out        <= jump_in;
        end
    end

endmodule
