`timescale 1ns/1ps

module tb_task2;

  reg [31:0] A, B;
  reg [0:0]  ctrl;
  wire [31:0] Y;

  dut uut (
    .A(A),
    .B(B),
    .ctrl(ctrl),
    .Y(Y)
  );

  // VCD dump configuration
  string vcd_file;
  initial begin
    if ($value$plusargs("vcd=%s", vcd_file))
      $dumpfile(vcd_file);
    else
      $dumpfile("task2.vcd");
    $dumpvars(0, uut);
  end

  initial begin
    // Test 1: AND basic
    A = 32'hFFFF0000; B = 32'h0F0F0F0F; ctrl = 1'b0; // AND
    #10;
    $display("AND: A=0x%h B=0x%h Y=0x%h", A, B, Y);

    // Test 2: OR basic
    A = 32'h0000FFFF; B = 32'h00FF00FF; ctrl = 1'b1; // OR
    #10;
    $display("OR:  A=0x%h B=0x%h Y=0x%h", A, B, Y);

    // Test 3: all zeros
    A = 32'h00000000; B = 32'h00000000; ctrl = 1'b0; // AND
    #10;
    $display("ALL ZERO AND: Y=0x%h", Y);

    // Test 4: all ones
    A = 32'hFFFFFFFF; B = 32'hFFFFFFFF; ctrl = 1'b1; // OR
    #10;
    $display("ALL ONES OR: Y=0x%h", Y);

    // Test 5: random pattern
    A = 32'hA5A5A5A5; B = 32'h5A5A5A5A; ctrl = 1'b0; // AND
    #10;
    $display("RND AND: Y=0x%h", Y);

    $finish;
  end

endmodule
