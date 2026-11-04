
module data_memory (
    input clk,
    input [31:0] address,
    input [31:0] write_data,
    input [3:0] write_mask,
    input mem_write,
    input mem_read,
    output reg [31:0] read_data
);

    // 256 words, 32 bits each
    reg [31:0] mem [0:255];

    integer i;

    // Initialize memory for simulation
    initial begin
        for (i = 0; i < 256; i = i + 1)
            mem[i] = 32'b0;
    end

    // Synchronous write with byte enables
    always @(posedge clk) begin
        if (mem_write) begin
            if (write_mask[0])
                mem[address[9:2]][7:0] <= write_data[7:0];

            if (write_mask[1])
                mem[address[9:2]][15:8] <= write_data[15:8];

            if (write_mask[2])
                mem[address[9:2]][23:16] <= write_data[23:16];

            if (write_mask[3])
                mem[address[9:2]][31:24] <= write_data[31:24];
        end
    end

    // Combinational read
    always @(*) begin
        if (mem_read)
            read_data = mem[address[9:2]];
        else
            read_data = 32'b0;
    end

endmodule
