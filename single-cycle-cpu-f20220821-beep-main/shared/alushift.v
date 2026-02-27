`timescale 1ns/1ps

module alushift (
  input  [31:0] A,
  input  [31:0] B,
  input  ctrl, // 0 = SLL, 1 = SRL (logical)
  output [31:0] Y
);

  wire [4:0] shamt = B[4:0];

  // Logical shifts with canonical delay #2
  assign #2 Y = ctrl ? ($unsigned(A) >> shamt) : (A << shamt);

endmodule
