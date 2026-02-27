`timescale 1ns/1ps

// Top-level module for R-type instruction execution
// Integrates register file, ALU control, and ALU for complete R-type execution
module fragment_r_type (
  input  clk,
  input  reset,
  input  [31:0] inst,
  output [31:0] rd_val
);

  // ===== Part 1: Field Extraction =====
  wire [4:0]  rs1    = inst[19:15];
  wire [4:0]  rs2    = inst[24:20];
  wire [4:0]  rd     = inst[11:7];
  wire [2:0]  funct3 = inst[14:12];
  wire [6:0]  funct7 = inst[31:25];

  // ===== Part 2: Register File =====
  wire [31:0] rdata1;
  wire [31:0] rdata2;

  reg_file regfile_inst (
    .clk(clk),
    .reset(reset),
    .reg_write_en(1'b1),  // Always enable writes for simplicity in this testbench
    .rs1(rs1),
    .rs2(rs2),
    .rd(rd),
    .wd(alu_result),      // Write-back ALU result
    .rdata1(rdata1),
    .rdata2(rdata2)
  );

  // ===== Part 3: ALU Control Logic =====
  wire [2:0] alu_ctrl;

  alu_ctrl alu_ctrl_inst (
    .funct3(funct3),
    .funct7(funct7),
    .alu_ctrl(alu_ctrl)
  );

  // ===== Part 4: ALU Execution =====
  wire [31:0] alu_result;
  wire        alu_zero;

  rv32ialu alu_inst (
    .A(rdata1),
    .B(rdata2),
    .alu_ctrl(alu_ctrl),
    .Y(alu_result),
    .zero(alu_zero)
  );

  // ===== Part 5: Write-Back =====
  // Result is written back to register file on next clock cycle
  // (Handled by reg_file itself)

  assign rd_val = alu_result;

endmodule
