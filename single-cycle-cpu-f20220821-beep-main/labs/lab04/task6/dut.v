`timescale 1ns/1ps

module dut (
  input  [31:0] A,
  input  [31:0] B,
  output [31:0] Y
);

  wire [32:0] S;

  assign #3 S = {1'b0, A} + {1'b0, ~B} + 33'b1; // canonical adder delay #3

  wire carry_out = S[32];
  wire sltu_bit = ~carry_out;

  assign #1 Y = sltu_bit ? 32'b1 : 32'b0;

endmodule
