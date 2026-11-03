
module program_counter (
    input clk,
    input reset,
    input pc_enable,
    input [31:0] next_pc,
    output reg [31:0] pc
);

    always @(posedge clk or posedge reset) begin
        if (reset)
            pc <= 32'h00000000;
        else if (pc_enable)
            pc <= next_pc;
    end

endmodule
