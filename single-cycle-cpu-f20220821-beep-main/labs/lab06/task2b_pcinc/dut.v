`timescale 1ns/1ps

module PCInc (
    input  clk,
    input  [31:0] oldPC,
    output [31:0] newPC
);

    // Use aluaddsub to compute oldPC + 4
    aluaddsub adder_inst (
        .A(oldPC),
        .B(32'd4),
        .ctrl(1'b1),              // ctrl = 1 for ADD
        .Y(newPC),
        .pos_overflow(),
        .neg_overflow()
    );

endmodule
