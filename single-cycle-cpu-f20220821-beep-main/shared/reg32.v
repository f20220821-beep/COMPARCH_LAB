`timescale 1ns/1ps

module reg32 (
    input clk,
    input reset,
    input we,
    input [31:0] d,
    output [31:0] q
);

    reg [31:0] data;

    // Synchronous reset and write operation
    always @(posedge clk) begin
        if (reset)
            data <= 32'b0;
        else if (we)
            data <= d;
    end

    // clk->Q propagation delay of #1
    assign #1 q = data;

endmodule
