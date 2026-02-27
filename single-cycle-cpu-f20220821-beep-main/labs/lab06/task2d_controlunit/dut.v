`timescale 1ns/1ps

module ControlUnit (
    input  [31:0] instruction,
    output        RegWrite,
    output        ALUSrc,
    output        MemWrite,
    output        MemRead,
    output [2:0]  ALUOp,
    output [1:0]  ImmSel
);

    // Extract opcode, funct3, and funct7 from instruction
    wire [6:0] opcode = instruction[6:0];
    wire [2:0] funct3 = instruction[14:12];
    wire [6:0] funct7 = instruction[31:25];

    // Opcode values for RV32I
    localparam OP_R_TYPE    = 7'b0110011;  // ADD, SUB, AND, OR
    localparam OP_I_TYPE    = 7'b0010011;  // ADDI, ANDI
    localparam OP_LW        = 7'b0000011;  // LW
    localparam OP_SW        = 7'b0100011;  // SW

    // Control signal outputs based on instruction
    assign RegWrite = (opcode == OP_R_TYPE) ? 1'b1 :
                      (opcode == OP_I_TYPE) ? 1'b1 :
                      (opcode == OP_LW)    ? 1'b1 :
                      1'b0;

    assign ALUSrc = (opcode == OP_I_TYPE) ? 1'b1 :
                    (opcode == OP_LW)    ? 1'b1 :
                    (opcode == OP_SW)    ? 1'b1 :
                    1'b0;

    assign MemWrite = (opcode == OP_SW) ? 1'b1 : 1'b0;

    assign MemRead = (opcode == OP_LW) ? 1'b1 : 1'b0;

    // ALUOp selection based on opcode and funct fields
    assign ALUOp = (opcode == OP_R_TYPE) ?
                   (funct7[5] == 1'b0 ?
                       (funct3 == 3'b000 ? 3'b001 :  // ADD
                        funct3 == 3'b111 ? 3'b010 :  // AND
                        funct3 == 3'b110 ? 3'b011 :  // OR
                        3'b001) :                     // Default to ADD
                       (funct3 == 3'b000 ? 3'b000 :  // SUB
                        3'b001)) :                    // Default to ADD
                   (opcode == OP_I_TYPE) ?
                       (funct3 == 3'b000 ? 3'b001 :  // ADDI
                        funct3 == 3'b111 ? 3'b010 :  // ANDI
                        3'b001) :                     // Default to ADD
                   3'b001;                           // Default to ADD for LW/SW

    // ImmSel selection based on opcode
    assign ImmSel = (opcode == OP_SW)  ? 2'b01 :  // S-type
                    (opcode == OP_LW)  ? 2'b00 :  // I-type
                    (opcode == OP_I_TYPE) ? 2'b00 :  // I-type
                    2'b00;  // Default to I-type

endmodule
