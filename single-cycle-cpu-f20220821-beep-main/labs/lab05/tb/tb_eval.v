`timescale 1ns/1ps

module tb_eval;
  reg clk;
  reg reset;
  reg [31:0] inst;
  wire [31:0] rd_val;

  // DUT instantiation
  fragment_r_type dut (
    .clk(clk),
    .reset(reset),
    .inst(inst),
    .rd_val(rd_val)
  );

  // ---------------------------------------------------------
  // Waveform dump configuration
  // ---------------------------------------------------------
  string vcd_file;

  initial begin
    if ($value$plusargs("vcd=%s", vcd_file))
      $dumpfile(vcd_file);
    else
      $dumpfile("task_eval.vcd");

    $dumpvars(0, dut);
  end

  // Clock generation
  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end

  // Test sequence
  initial begin
    // Initialize
    reset = 1;
    inst = 32'h00000000;
    #10;

    reset = 0;
    #10;

    // Test: Execute SUB x5, x3, x4
    // Since x0 is hardwired to 0 and all other registers initialize to 0,
    // this will compute 0 - 0 = 0.
    // For demonstration purposes, we trace through the execution path.
    // 
    // Instruction: sub x5, x3, x4
    // funct7[6:0] = 0100000 (bit 5 = 1 for SUB)
    // rs2 = 00100 (x4)
    // rs1 = 00011 (x3)
    // funct3 = 000 (SUB function)
    // rd = 00101 (x5)
    // opcode = 0110011
    // Binary: 01000000010000110000010110110011
    // Hex: 0x40303433
    
    $display("Test: SUB x5, x3, x4");
    inst = 32'h40303433;
    #1;  // Combinational path settles
    
    $display("  Instruction: 0x%08h", inst);
    $display("  Result (rd_val): 0x%08h", rd_val);
    $display("  Expected: 0x00000000 (0-0=0)");
    
    #20;  // Wait for register write to complete (on next clock edge)

    $finish;
  end

endmodule
