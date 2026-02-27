
`timescale 1ns/1ps

module dut (
  input  signed [31:0] A,
  input  signed [31:0] B,
  input  [0:0]         ctrl,      // 0 = SUB, 1 = ADD
  output signed [31:0] Y,
  output               pos_overflow,
  output               neg_overflow
);

  aluaddsub adder_subtractor (
    .A(A),
    .B(B),
    .ctrl(ctrl),
    .Y(Y),
    .pos_overflow(pos_overflow),
    .neg_overflow(neg_overflow)
  );

endmodule
