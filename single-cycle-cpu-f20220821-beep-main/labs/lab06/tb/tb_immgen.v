`timescale 1ns/1ps

module tb_immgen;

    reg [1:0]  immSel;
    reg [31:0] instruction;
    wire [31:0] immOut;

    immGen dut (
        .immSel(immSel),
        .instruction(instruction),
        .immOut(immOut)
    );

    initial begin
        // Test I-type (addi x1, x0, 10)
        // addi: opcode=0010011, funct3=000
        // instr[31:20] = 000000001010 (10)
        instruction = 32'b00000000101000000000000010010011;
        immSel = 2'b00;
        #1;
        $display("I-type test: immOut = %d (expected 10)", $signed(immOut));
        
        // Test I-type with negative (addi x1, x0, -5)
        // instr[31:20] = 111111111011 (-5 in 12-bit two's complement)
        instruction = 32'b11111111101100000000000010010011;
        immSel = 2'b00;
        #1;
        $display("I-type negative test: immOut = %d (expected -5)", $signed(immOut));
        
        // Test S-type (sw x3, 0(x0))
        // sw: opcode=0100011, funct3=010
        // instr[31:25]=0000000, instr[11:7]=00000
        instruction = 32'b00000000001100000010000000100011;
        immSel = 2'b01;
        #1;
        $display("S-type test: immOut = %d (expected 0)", $signed(immOut));

        $finish;
    end

endmodule
