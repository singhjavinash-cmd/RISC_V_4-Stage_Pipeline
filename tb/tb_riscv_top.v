`timescale 1ns/1ps

module tb_riscv_top;

    reg clk;
    reg reset;

    riscv_top uut (
        .clk(clk),
        .reset(reset)
    );

    // 100 MHz clock
    always #5 clk = ~clk;

    initial begin
        $dumpfile("riscv_wave.vcd");
        $dumpvars(0, tb_riscv_top);
        clk = 0;
        reset = 1;

        #20;
        reset = 0;

        // Run processor
        #200;

        $finish;
    end

endmodule