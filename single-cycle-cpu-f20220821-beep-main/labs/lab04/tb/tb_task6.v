`timescale 1ns/1ps

module tb;
  reg  [31:0] A;
  reg  [31:0] B;
  wire [31:0] Y;

  dut DUT (
    .A(A),
    .B(B),
    .Y(Y)
  );

  // Waveform dump
  string vcd_file;
  initial begin
    if ($value$plusargs("vcd=%s", vcd_file))
      $dumpfile(vcd_file);
    else
      $dumpfile("task6.vcd");
    $dumpvars(0, DUT);
  end

  initial begin
    // A < B unsigned: A=1, B=0xFFFFFFFF -> expected Y=1
    A = 32'h00000001; B = 32'hFFFFFFFF; #10;

    // A >= B unsigned: A=0x80000000, B=0x00000001 -> expected Y=0
    A = 32'h80000000; B = 32'h00000001; #10;

    // equal
    A = 32'h00000005; B = 32'h00000005; #10;

    $finish;
  end
endmodule
