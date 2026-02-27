`timescale 1ns/1ps

module dut (
  input  [31:0] A,
  input  [31:0] B,
  input  [0:0]  ctrl,
  output [31:0] Y
);

  alulogic u_alulogic (
    .A(A),
    .B(B),
    .ctrl(ctrl),
    .Y(Y)
  );

endmodule
