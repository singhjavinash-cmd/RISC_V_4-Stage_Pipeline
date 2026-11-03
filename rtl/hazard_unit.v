module hazard_unit(
    input [4:0] id_rs1,
    input [4:0] id_rs2,

    input [4:0] exmem_rd,
    input exmem_mem_read,

    output reg stall
);

    always @(*) begin
        stall = 1'b0;

        // Load-use hazard detection
        if (exmem_mem_read && (exmem_rd != 5'b0)) begin
            if ((exmem_rd == id_rs1) ||
                (exmem_rd == id_rs2)) begin
                stall = 1'b1;
            end
        end
    end

endmodule