module instruction_memory(
    input [31:0] pc,
    output reg [31:0] instruction
);

    // Hint 1: Declare 256 x 32-bit memory here
    reg [31:0] mem [0:255];

    // Hint 2: Read instruction using pc[9:2]
    always @(*) begin
    instruction = mem[pc[9:2]];
end
initial begin
    $readmemh("programs/test_program.hex", mem);
end
    

endmodule