
`timescale 1ns/1ps

module tb_riscv_top;

    reg clk;
    reg reset;
    integer errors;

    riscv_top uut (
        .clk(clk),
        .reset(reset)
    );

    always #5 clk = ~clk;

    task check_reg;
        input [4:0] reg_num;
        input [31:0] expected;
        input [255:0] test_name;
        begin
            if (uut.RF.registers[reg_num] !== expected) begin
                $display("FAIL: %0s expected %0d, got %0d",
                         test_name, expected,
                         uut.RF.registers[reg_num]);
                errors = errors + 1;
            end
            else begin
                $display("PASS: %0s = %0d", test_name, expected);
            end
        end
    endtask

    initial begin
        $dumpfile("riscv_wave.vcd");
        $dumpvars(0, tb_riscv_top);

        clk = 0;
        reset = 1;
        errors = 0;

        repeat (2) @(posedge clk);
        @(negedge clk);
        reset = 0;

        // Allow branch/jump program to execute
        repeat (40) @(posedge clk);
        #1;

        // Initial values
        check_reg(5'd1, 32'd5, "x1");
        check_reg(5'd2, 32'd5, "x2");

        // Branch test results
        check_reg(5'd3, 32'd7, "BEQ target x3");
        check_reg(5'd4, 32'd11, "BNE target x4");
        check_reg(5'd5, 32'd12, "BLT target x5");
        check_reg(5'd6, 32'd13, "BGE target x6");

        // Jump link addresses and targets
        check_reg(5'd7, 32'd52, "JAL link x7");
        check_reg(5'd8, 32'd21, "JAL target x8");
        check_reg(5'd9, 32'd80, "JALR target x9");
        check_reg(5'd10, 32'd72, "JALR link x10");
        check_reg(5'd11, 32'd31, "JALR target x11");

        if (errors == 0)
            $display("ALL BRANCH/JUMP TESTS PASSED");
        else
            $display("BRANCH/JUMP TESTS FAILED: %0d error(s)", errors);

        $finish;
    end

endmodule
