`timescale 1ns/1ps

module reg_file (
    input clk,
    input reset,
    input we,
    input [4:0] rs1,
    input [4:0] rs2,
    input [4:0] rd,
    input [31:0] wd,
    output [31:0] rdata1,
    output [31:0] rdata2
);

    // Array of 32 registers
    wire [31:0] reg_outputs [0:31];
    
    // Task 1B: Generate 32 registers using generate block
    genvar i;
    generate
        for (i = 0; i < 32; i = i + 1) begin : reg_gen
            if (i == 0) begin
                // x0 (register 0) is hard-wired to 0
                assign reg_outputs[0] = 32'b0;
            end else begin
                // Regular 32-bit registers
                reg32 reg_inst (
                    .clk(clk),
                    .reset(reset),
                    .we(we && (rd == i)),  // Write enable for this register
                    .d(wd),
                    .q(reg_outputs[i])
                );
            end
        end
    endgenerate

    // Task 1C: Read path implementation with multiplexers
    // Behavioral multiplexers with #1 delay per canonical timing model
    assign #1 rdata1 = reg_outputs[rs1];
    assign #1 rdata2 = reg_outputs[rs2];

endmodule
