`timescale 1ns/1ps

module tb_alu_corner;

    reg  [31:0] a, b;
    reg  [3:0]  alu_control;
    wire [31:0] result;
    integer errors;

    alu uut (
        .a(a),
        .b(b),
        .alu_control(alu_control),
        .result(result)
    );

    task check;
        input [31:0] expected;
        input [8*40-1:0] test_name;
        begin
            #1;
            if (result !== expected) begin
                $display("FAIL: %0s expected %h got %h",
                         test_name, expected, result);
                errors = errors + 1;
            end else begin
                $display("PASS: %0s = %h", test_name, result);
            end
        end
    endtask

    initial begin
        errors = 0;
        a = 0;
        b = 0;
        alu_control = 0;

        // ADD overflow wraps around in 32-bit arithmetic
        a = 32'h7fffffff; b = 1; alu_control = 4'b0000;
        check(32'h80000000, "ADD signed boundary");

        // SUB
        a = 0; b = 1; alu_control = 4'b0001;
        check(32'hffffffff, "SUB underflow");

        // Signed and unsigned comparisons differ
        a = 32'hffffffff; b = 1; alu_control = 4'b0101;
        check(32'd1, "SLT -1 < 1");

        a = 32'hffffffff; b = 1; alu_control = 4'b0110;
        check(32'd0, "SLTU max < 1");

        // Shift operations
        a = 32'h00000001; b = 4; alu_control = 4'b0111;
        check(32'h00000010, "SLL");

        a = 32'h80000000; b = 1; alu_control = 4'b1000;
        check(32'h40000000, "SRL");

        a = 32'h80000000; b = 1; alu_control = 4'b1001;
        check(32'hc0000000, "SRA");

        // Shift amount uses only low 5 bits
        a = 32'h00000001; b = 32'd33; alu_control = 4'b0111;
        check(32'h00000002, "SLL shift amount 33");

        if (errors == 0)
            $display("ALL ALU CORNER TESTS PASSED");
        else
            $display("ALU CORNER TESTS FAILED: %0d error(s)", errors);

        $finish;
    end

endmodule