`timescale 1ns/1ps

module immGen (
    input  [1:0]  immSel,
    input  [31:0] instruction,
    output [31:0] immOut
);

    // Extract immediate values for each instruction type
    // I-type: inst[31:20] (12 bits)
    wire signed [31:0] imm_I = {{20{instruction[31]}}, instruction[31:20]};
    
    // S-type: {inst[31:25], inst[11:7]} (12 bits)
    wire signed [31:0] imm_S = {{20{instruction[31]}}, instruction[31:25], instruction[11:7]};
    
    // B-type: {inst[31], inst[7], inst[30:25], inst[11:8], 1'b0} (13 bits, but we need 32)
    wire signed [31:0] imm_B = {{19{instruction[31]}}, instruction[31], instruction[7], instruction[30:25], instruction[11:8], 1'b0};

    // Multiplexer to select the correct immediate based on immSel
    assign immOut = (immSel == 2'b00) ? imm_I :
                    (immSel == 2'b01) ? imm_S :
                    (immSel == 2'b10) ? imm_B :
                    32'b0;

endmodule
