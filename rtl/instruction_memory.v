module instruction_memory (
    input  [31:0] pc,
    output reg [31:0] instruction
);

    // 256 x 32-bit instruction memory
    reg [31:0] mem [0:255];

    integer i;

    // Initialize unused locations with RISC-V NOP
    initial begin
        for (i = 0; i < 256; i = i + 1) begin
            mem[i] = 32'h00000013;
        end

        // Load program instructions from hex file
        $readmemh("programs/test_program.hex", mem);
    end

    // Read instruction using word-aligned PC
    always @(*) begin
        instruction = mem[pc[9:2]];
    end

endmodule