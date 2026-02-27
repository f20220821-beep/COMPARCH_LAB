
`timescale 1ns/1ps

module tb_task1;

  reg signed [31:0] A, B;
  reg [0:0] ctrl;
  wire signed [31:0] Y;
  wire pos_overflow, neg_overflow;

  dut uut (
    .A(A),
    .B(B),
    .ctrl(ctrl),
    .Y(Y),
    .pos_overflow(pos_overflow),
    .neg_overflow(neg_overflow)
  );

  // VCD dump configuration
  string vcd_file;

  initial begin
    if ($value$plusargs("vcd=%s", vcd_file))
      $dumpfile(vcd_file);
    else
      $dumpfile("task1.vcd");

    $dumpvars(0, uut);
  end

  // Test cases
  initial begin
    // Test 1: positive + positive (no overflow)
    A = 32'h00000005;  // 5
    B = 32'h00000003;  // 3
    ctrl = 1'b1;       // ADD
    #10;
    $display("Test 1 (5 + 3): Y=%d, pos_ovf=%b, neg_ovf=%b", Y, pos_overflow, neg_overflow);

    // Test 2: positive + positive (positive overflow)
    A = 32'h7FFFFFFF;  // 2147483647 (max positive)
    B = 32'h00000001;  // 1
    ctrl = 1'b1;       // ADD
    #10;
    $display("Test 2 (0x7FFF + 1): Y=0x%h, pos_ovf=%b, neg_ovf=%b", Y, pos_overflow, neg_overflow);

    // Test 3: negative + negative (negative overflow)
    A = 32'h80000000;  // -2147483648 (min negative)
    B = 32'hFFFFFFFF;  // -1
    ctrl = 1'b1;       // ADD
    #10;
    $display("Test 3 (0x8000 + -1): Y=0x%h, pos_ovf=%b, neg_ovf=%b", Y, pos_overflow, neg_overflow);

    // Test 4: positive + negative (no overflow)
    A = 32'h00000005;  // 5
    B = 32'hFFFFFFFE;  // -2
    ctrl = 1'b1;       // ADD
    #10;
    $display("Test 4 (5 + (-2)): Y=%d, pos_ovf=%b, neg_ovf=%b", Y, pos_overflow, neg_overflow);

    // Test 5: SUB - positive - positive (no overflow)
    A = 32'h00000005;  // 5
    B = 32'h00000003;  // 3
    ctrl = 1'b0;       // SUB
    #10;
    $display("Test 5 (5 - 3): Y=%d, pos_ovf=%b, neg_ovf=%b", Y, pos_overflow, neg_overflow);

    // Test 6: SUB - negative result
    A = 32'h00000003;  // 3
    B = 32'h00000005;  // 5
    ctrl = 1'b0;       // SUB
    #10;
    $display("Test 6 (3 - 5): Y=%d, pos_ovf=%b, neg_ovf=%b", Y, pos_overflow, neg_overflow);

    // Test 7: SUB - positive - negative (positive overflow)
    A = 32'h7FFFFFFF;  // 2147483647 (max positive)
    B = 32'h80000000;  // -2147483648 (min negative)
    ctrl = 1'b0;       // SUB
    #10;
    $display("Test 7 (0x7FFF - (-0x8000)): Y=0x%h, pos_ovf=%b, neg_ovf=%b", Y, pos_overflow, neg_overflow);

    // Test 8: SUB - negative - positive (negative overflow)
    A = 32'h80000000;  // -2147483648 (min negative)
    B = 32'h00000001;  // 1
    ctrl = 1'b0;       // SUB
    #10;
    $display("Test 8 (-0x8000 - 1): Y=0x%h, pos_ovf=%b, neg_ovf=%b", Y, pos_overflow, neg_overflow);

    $finish;
  end

endmodule
