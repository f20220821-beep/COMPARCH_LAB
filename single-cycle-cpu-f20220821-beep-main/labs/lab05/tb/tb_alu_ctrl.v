`timescale 1ns/1ps

module tb_alu_ctrl;
    reg [2:0] funct3;
    reg [6:0] funct7;
    wire [2:0] alu_ctrl;

    alu_ctrl dut (
        .funct3(funct3),
        .funct7(funct7),
        .alu_ctrl(alu_ctrl)
    );

    string vcd_file;

    initial begin
        if ($value$plusargs("vcd=%s", vcd_file))
            $dumpfile(vcd_file);
        else
            $dumpfile("tb_alu_ctrl.vcd");

        $dumpvars(0, dut);
    end

    initial begin
        $display("========================================");
        $display("Task 3: ALU Control Logic Tests");
        $display("========================================\n");

        #1;

        $display("[TEST 1] ADD: funct7[5]=0, funct3=000");
        funct7 = 7'b0000000;
        funct3 = 3'b000;
        #2;
        $display("  alu_ctrl = %b (expected 001)", alu_ctrl);
        if (alu_ctrl === 3'b001)
            $display("  ✓ PASS");
        else
            $display("  ✗ FAIL");

        $display("\n[TEST 2] SUB: funct7[5]=1, funct3=000");
        funct7 = 7'b0100000;
        funct3 = 3'b000;
        #2;
        $display("  alu_ctrl = %b (expected 000)", alu_ctrl);
        if (alu_ctrl === 3'b000)
            $display("  ✓ PASS");
        else
            $display("  ✗ FAIL");

        $display("\n[TEST 3] AND: funct7[5]=0, funct3=111");
        funct7 = 7'b0000000;
        funct3 = 3'b111;
        #2;
        $display("  alu_ctrl = %b (expected 010)", alu_ctrl);
        if (alu_ctrl === 3'b010)
            $display("  ✓ PASS");
        else
            $display("  ✗ FAIL");

        $display("\n[TEST 4] OR: funct7[5]=0, funct3=110");
        funct7 = 7'b0000000;
        funct3 = 3'b110;
        #2;
        $display("  alu_ctrl = %b (expected 011)", alu_ctrl);
        if (alu_ctrl === 3'b011)
            $display("  ✓ PASS");
        else
            $display("  ✗ FAIL");

        $display("\n[TEST 5] SLL: funct7[5]=0, funct3=001");
        funct7 = 7'b0000000;
        funct3 = 3'b001;
        #2;
        $display("  alu_ctrl = %b (expected 100)", alu_ctrl);
        if (alu_ctrl === 3'b100)
            $display("  ✓ PASS");
        else
            $display("  ✗ FAIL");

        $display("\n[TEST 6] SLT: funct7[5]=0, funct3=010");
        funct7 = 7'b0000000;
        funct3 = 3'b010;
        #2;
        $display("  alu_ctrl = %b (expected 110)", alu_ctrl);
        if (alu_ctrl === 3'b110)
            $display("  ✓ PASS");
        else
            $display("  ✗ FAIL");

        $display("\n[TEST 7] Invalid instruction (funct3=011)");
        funct7 = 7'b0000000;
        funct3 = 3'b011;
        #2;
        $display("  alu_ctrl = %b (expected 000)", alu_ctrl);
        if (alu_ctrl === 3'b000)
            $display("  ✓ PASS");
        else
            $display("  ✗ FAIL");

        $display("\n========================================");
        $display("All tests completed!");
        $display("========================================\n");
        $finish;
    end

endmodule
