`timescale 1ns/1ps

module dut (
  input  [31:0] A,
  input  [31:0] B,
  input  ctrl,
  output [31:0] Y
);

  alushift u_shift (
    .A(A),
    .B(B),
    .ctrl(ctrl),
    .Y(Y)
  );

endmodule
