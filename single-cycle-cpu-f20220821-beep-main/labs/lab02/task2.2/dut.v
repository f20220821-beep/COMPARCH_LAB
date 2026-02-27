`timescale 1ns/1ps
module dut (
  input wire clk,
  input wire [7:0] d,
  input reset,
  output [7:0] q
);

  dff dff0 (.clk(clk), .d(d[0]), .reset(reset), .q(q[0]));
  dff dff1 (.clk(clk), .d(d[1]), .reset(reset), .q(q[1]));
  dff dff2 (.clk(clk), .d(d[2]), .reset(reset), .q(q[2]));
  dff dff3 (.clk(clk), .d(d[3]), .reset(reset), .q(q[3]));
  dff dff4 (.clk(clk), .d(d[4]), .reset(reset), .q(q[4]));
  dff dff5 (.clk(clk), .d(d[5]), .reset(reset), .q(q[5]));
  dff dff6 (.clk(clk), .d(d[6]), .reset(reset), .q(q[6]));
  dff dff7 (.clk(clk), .d(d[7]), .reset(reset), .q(q[7]));

endmodule