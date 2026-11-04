
`timescale 1ns/1ps

module tb_riscv_top;

    reg clk;
    reg reset;
    integer errors;

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
        errors = 0;

        // Apply reset
        repeat (2) @(posedge clk);
        @(negedge clk);
        reset = 0;

        // Allow pipeline to execute
        repeat (20) @(posedge clk);
        #1;

        // Check data memory
        if (uut.DMEM.mem[0] !== 32'd7) begin
            $display("FAIL: memory[0] expected 7, got %h",
                     uut.DMEM.mem[0]);
            errors = errors + 1;
        end else begin
            $display("PASS: memory[0] = 7");
        end

        // Check loaded value
        if (uut.RF.registers[2] !== 32'd7) begin
            $display("FAIL: x2 expected 7, got %h",
                     uut.RF.registers[2]);
            errors = errors + 1;
        end else begin
            $display("PASS: x2 = 7");
        end

        // Check load-use dependent instruction
        if (uut.RF.registers[4] !== 32'd8) begin
            $display("FAIL: x4 expected 8, got %h",
                     uut.RF.registers[4]);
            errors = errors + 1;
        end else begin
            $display("PASS: load-use x4 = 8");
        end

        if (errors == 0)
            $display("ALL TESTS PASSED");
        else
            $display("TESTS FAILED: %0d error(s)", errors);

        $finish;
    end

endmodule
