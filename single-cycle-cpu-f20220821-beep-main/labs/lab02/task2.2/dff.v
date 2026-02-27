`timescale 1ns/1ps
module dff (
  input wire clk,
  input wire d,
  input reset,
  output reg q
);
  always @(posedge clk or negedge reset) begin
    if (!reset) begin
      q <= 0;
    end else begin
      q <= d;
    end
  end
endmodule