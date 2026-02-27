`timescale 1ns/1ps

module tb_task3;

  reg [31:0] A, B;
  reg ctrl;
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
      $dumpfile("task3.vcd");
    $dumpvars(0, uut);
  end

  initial begin
    // Test 1: shift by 0 (SLL)
    A = 32'hA5A50000; B = 32'd0; ctrl = 1'b0; // SLL
    #10;
    $display("SLL 0: Y=0x%h", Y);

    // Test 2: shift left by 1 (SLL)
    A = 32'h00000001; B = 32'd1; ctrl = 1'b0; // SLL
    #10;
    $display("SLL 1: Y=0x%h", Y);

    // Test 3: shift right logical by 1 (SRL)
    A = 32'h80000000; B = 32'd1; ctrl = 1'b1; // SRL
    #10;
    $display("SRL 1: Y=0x%h", Y);

    // Test 4: shift by -1 (lower 5 bits = 31) using B = -1
    A = 32'h00000001; B = 32'hFFFFFFFF; ctrl = 1'b0; // SLL by 31
    #10;
    $display("SLL 31 (from -1): Y=0x%h", Y);

    // Test 5: shift right logical by 31
    A = 32'hFFFFFFFF; B = 32'd31; ctrl = 1'b1; // SRL by 31
    #10;
    $display("SRL 31: Y=0x%h", Y);

    $finish;
  end

endmodule
