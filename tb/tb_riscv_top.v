
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

        // Debug monitor
        $monitor("t=%0t pc=%h instr=%h | ID reg_write=%b alu_src=%b alu_ctrl=%b | EX result=%h rd=%d | WB write=%b rd=%d data=%h",
         $time,
         uut.pc,
         uut.if_id_instruction,
         uut.reg_write,
         uut.alu_src,
         uut.alu_control,
         uut.alu_result,
         uut.id_exmem_rd,
         uut.mem_wb_reg_write,
         uut.mem_wb_rd,
         uut.write_back_data);

        // Allow pipeline to execute
        repeat (10) @(posedge clk);
        #1;

        // Check x1 = 5 (ADDI x1, x0, 5)
        if (uut.RF.registers[1] !== 32'd5) begin
            $display("FAIL: x1 expected 5, got %h",
                     uut.RF.registers[1]);
            errors = errors + 1;
        end else begin
            $display("PASS: x1 = 5");
        end

        // Check x2 = 3 (ADDI x2, x0, 3)
        if (uut.RF.registers[2] !== 32'd3) begin
            $display("FAIL: x2 expected 3, got %h",
                     uut.RF.registers[2]);
            errors = errors + 1;
        end else begin
            $display("PASS: x2 = 3");
        end

        if (errors == 0)
            $display("ALL TESTS PASSED");
        else
            $display("TESTS FAILED: %0d error(s)", errors);

        $finish;
    end

endmodule
