`timescale 1ns/1ps

module tb_controlunit;

    reg [31:0] instruction;
    wire regWrite, aluSrc, memWrite, memRead;
    wire [2:0] aluOp;
    wire [1:0] immSel;

    ControlUnit dut (
        .instruction(instruction),
        .RegWrite(regWrite),
        .ALUSrc(aluSrc),
        .MemWrite(memWrite),
        .MemRead(memRead),
        .ALUOp(aluOp),
        .ImmSel(immSel)
    );

    initial begin
        // Test ADDI (I-type)
        instruction = 32'b00000000101000000000000010010011;  // addi x1, x0, 10
        #1;
        $display("ADDI: RegW=%d ALUSrc=%d MemW=%d MemR=%d ALUOp=%b ImmSel=%b", 
                 regWrite, aluSrc, memWrite, memRead, aluOp, immSel);
        
        // Test ADD (R-type)
        instruction = 32'b00000000001000001000000110110011;  // add x3, x1, x2
        #1;
        $display("ADD: RegW=%d ALUSrc=%d MemW=%d MemR=%d ALUOp=%b ImmSel=%b", 
                 regWrite, aluSrc, memWrite, memRead, aluOp, immSel);
        
        // Test LW (Load)
        instruction = 32'b00000000000000000010000100000011;  // lw x1, 0(x0)
        #1;
        $display("LW: RegW=%d ALUSrc=%d MemW=%d MemR=%d ALUOp=%b ImmSel=%b", 
                 regWrite, aluSrc, memWrite, memRead, aluOp, immSel);
        
        // Test SW (Store)
        instruction = 32'b00000000001000000010000000100011;  // sw x1, 0(x0)
        #1;
        $display("SW: RegW=%d ALUSrc=%d MemW=%d MemR=%d ALUOp=%b ImmSel=%b", 
                 regWrite, aluSrc, memWrite, memRead, aluOp, immSel);

        $finish;
    end

endmodule
