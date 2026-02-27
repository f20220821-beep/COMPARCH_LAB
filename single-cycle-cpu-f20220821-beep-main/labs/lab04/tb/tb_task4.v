`timescale 1ns/1ps

module tb_task4;

  reg signed [31:0] A, B;
  wire [31:0] Y;

  dut uut (
    .A(A),
    .B(B),
    .Y(Y)
  );

  // VCD dump configuration
  string vcd_file;
  initial begin
    if ($value$plusargs("vcd=%s", vcd_file))
      $dumpfile(vcd_file);
    else
      $dumpfile("task4.vcd");
    $dumpvars(0, uut);
  end

  initial begin
    // Test 1: 3 < 5 -> true
    A = 3; B = 5; #10;
    $display("3 < 5 -> Y=%d", Y);

    // Test 2: -2 < 1 -> true
    A = -2; B = 1; #10;
    $display("-2 < 1 -> Y=%d", Y);

    // Test 3: 5 < 3 -> false
    A = 5; B = 3; #10;
    $display("5 < 3 -> Y=%d", Y);

    // Test 4: negative comparison -5 < -3 -> true
    A = -5; B = -3; #10;
    $display("-5 < -3 -> Y=%d", Y);

    // Test 5: overflow case: A = 0x7FFFFFFF, B = -1
    // A - B overflows, check SLT (should be false: max pos > -1)
    A = 32'sh7FFFFFFF; B = -1; #10;
    $display("0x7FFFFFFF < -1 -> Y=%d (expect 0)", Y);

    // Test 6: overflow case: A = -2147483648, B = 1
    // A < B true
    A = -32'sd2147483648; B = 1; #10;
    $display("-2147483648 < 1 -> Y=%d (expect 1)", Y);

    $finish;
  end

endmodule
