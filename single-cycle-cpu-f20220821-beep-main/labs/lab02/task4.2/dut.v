
`timescale 1ns/1ps
module dut (
  input wire clk,
  input wire reset,
  output reg [7:0] q
);
  
  // 8-bit up-counter with asynchronous reset
  always @(posedge clk or negedge reset) begin
    if (!reset) begin
      q <= 8'b0;
    end else begin
      q <= q + 1;
    end
  end
  
endmodule
