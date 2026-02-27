`timescale 1ns/1ps

module alucomp (
  input  signed [31:0] A,
  input  signed [31:0] B,
  output [31:0] Y
);

  wire signed [31:0] sub;
  wire pos_ovf, neg_ovf;

  // Reuse the adder/subtractor: ctrl = 0 => SUB
  aluaddsub u_addsub (
    .A(A),
    .B(B),
    .ctrl(1'b0),
    .Y(sub),
    .pos_overflow(pos_ovf),
    .neg_overflow(neg_ovf)
  );

  wire overflow = pos_ovf | neg_ovf;

  // Comparator logic: signed less-than = sign(sub) ^ overflow
  // Add canonical comparator delay #1 on top of adder's delay
  assign #1 Y = (sub[31] ^ overflow) ? 32'b1 : 32'b0;

endmodule
