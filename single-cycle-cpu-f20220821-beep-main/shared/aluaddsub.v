
`timescale 1ns/1ps

module aluaddsub (
  input  signed [31:0] A,
  input  signed [31:0] B,
  input  [0:0]         ctrl,      // 0 = SUB, 1 = ADD
  output signed [31:0] Y,
  output               pos_overflow,
  output               neg_overflow
);

  wire signed [31:0] B_inverted;
  wire signed [31:0] adder_input_B;
  wire signed [31:0] result;
  
  // For subtraction, use two's complement: A - B = A + (~B + 1)
  // For addition, use B directly
  assign B_inverted = ~B;
  assign adder_input_B = ctrl ? B : (B_inverted);
  
  // 32-bit addition with delay
  assign #3 result = A + adder_input_B + (ctrl ? 32'b0 : 32'b1);
  
  // Output the result
  assign Y = result;
  
  // Overflow detection
  // For ADD (ctrl = 1):
  //   Positive overflow: both inputs positive (A[31]=0, B[31]=0), result negative (Y[31]=1)
  //   Negative overflow: both inputs negative (A[31]=1, B[31]=1), result positive (Y[31]=0)
  //
  // For SUB (ctrl = 0):
  //   Positive overflow: A positive, B negative (A[31]=0, B[31]=1), result negative (Y[31]=1)
  //   Negative overflow: A negative, B positive (A[31]=1, B[31]=0), result positive (Y[31]=0)
  
  wire pos_ovf_add = ~A[31] & ~B[31] & result[31];
  wire neg_ovf_add = A[31] & B[31] & ~result[31];
  
  wire pos_ovf_sub = ~A[31] & B[31] & result[31];
  wire neg_ovf_sub = A[31] & ~B[31] & ~result[31];
  
  assign pos_overflow = ctrl ? pos_ovf_add : pos_ovf_sub;
  assign neg_overflow = ctrl ? neg_ovf_add : neg_ovf_sub;

endmodule
