`timescale 1ns/1ps

module alulogic (
  input  [31:0] A,
  input  [31:0] B,
  input  [0:0]  ctrl, // 0 = AND, 1 = OR
  output [31:0] Y
);

  // Logic unit with canonical delay #1
  assign #1 Y = (ctrl ? (A | B) : (A & B));

endmodule
