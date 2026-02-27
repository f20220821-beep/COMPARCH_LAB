`timescale 1ns/1ps

module alu_ctrl (
    input [2:0] funct3,
    input [6:0] funct7,
    output [2:0] alu_ctrl
);

    wire [2:0] ctrl;

    assign ctrl = (funct7[5] == 1'b0) ?
        ((funct3 == 3'b000) ? 3'b001 :
         (funct3 == 3'b111) ? 3'b010 :
         (funct3 == 3'b110) ? 3'b011 :
         (funct3 == 3'b001) ? 3'b100 :
         (funct3 == 3'b010) ? 3'b110 :
         3'b000) :
        ((funct3 == 3'b000) ? 3'b000 :
         3'b000);

    assign #1 alu_ctrl = ctrl;

endmodule
