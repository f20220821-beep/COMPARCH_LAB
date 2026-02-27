`timescale 1ns/1ps

// Integrated 32-bit ALU for RISC-V instruction execution
module rv32ialu (
  input  signed [31:0] A,
  input  signed [31:0] B,
  input  [2:0]         alu_ctrl,
  output signed [31:0] Y,
  output               zero
);

  wire signed [31:0] add_sub_result;
  wire               add_sub_zero;
  wire signed [31:0] logic_result;
  wire signed [31:0] shift_result;
  wire signed [31:0] comp_result;

  // Adder/Subtractor: ctrl = 0 for SUB, 1 for ADD
  aluaddsub adder_inst (
    .A(A),
    .B(B),
    .ctrl(alu_ctrl[0]),  // bit 0 differentiates ADD/SUB
    .Y(add_sub_result),
    .pos_overflow(),
    .neg_overflow()
  );

  // Logic Unit: AND (010) and OR (011)
  alulogic logic_inst (
    .A(A),
    .B(B),
    .ctrl(alu_ctrl[0]),  // bit 0: 0=AND, 1=OR
    .Y(logic_result)
  );

  // Shifter: SLL (100) and SRL (101)
  alushift shift_inst (
    .A(A),
    .B(B),
    .ctrl(alu_ctrl[0]),  // bit 0: 0=SLL, 1=SRL
    .Y(shift_result)
  );

  // Comparator: SLT (110)
  alucomp comp_inst (
    .A(A),
    .B(B),
    .Y(comp_result)
  );

  // Final mux to select result based on alu_ctrl
  wire signed [31:0] result;
  assign result = (alu_ctrl == 3'b001) ? add_sub_result :  // ADD
                  (alu_ctrl == 3'b000) ? add_sub_result :  // SUB
                  (alu_ctrl == 3'b010) ? logic_result :    // AND
                  (alu_ctrl == 3'b011) ? logic_result :    // OR
                  (alu_ctrl == 3'b100) ? shift_result :    // SLL
                  (alu_ctrl == 3'b101) ? shift_result :    // SRL
                  (alu_ctrl == 3'b110) ? comp_result :     // SLT
                  32'b0;                                    // Reserved -> 0

  assign #1 Y = result;
  assign #1 zero = (result == 32'b0);

endmodule
