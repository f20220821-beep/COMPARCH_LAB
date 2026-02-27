`timescale 1ns/1ps

module dut (
  input  signed [31:0] A,
  input  signed [31:0] B,
  output [31:0] Y
);

  alucomp u_comp (
    .A(A),
    .B(B),
    .Y(Y)
  );

endmodule
