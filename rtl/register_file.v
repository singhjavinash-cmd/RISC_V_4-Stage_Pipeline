
module register_file(
    input clk,
    input [4:0] rs1,
    input [4:0] rs2,
    input [4:0] rd,
    input [31:0] write_data,
    input reg_write,

    output [31:0] read_data1,
    output [31:0] read_data2
);

    // 32 registers, each 32-bit wide
    reg [31:0] registers [0:31];

    // Initialize all registers to zero for simulation
    integer i;
    initial begin
        for (i = 0; i < 32; i = i + 1)
            registers[i] = 32'b0;
    end

    // Combinational read ports with writeback bypass
    // x0 always reads as zero
    assign read_data1 = (rs1 == 5'd0) ? 32'd0 :
                        (reg_write && (rd == rs1)) ? write_data :
                        registers[rs1];

    assign read_data2 = (rs2 == 5'd0) ? 32'd0 :
                        (reg_write && (rd == rs2)) ? write_data :
                        registers[rs2];

    // Synchronous write port; x0 is not writable
    always @(posedge clk) begin
        if (reg_write && (rd != 5'd0))
            registers[rd] <= write_data;
    end

endmodule
