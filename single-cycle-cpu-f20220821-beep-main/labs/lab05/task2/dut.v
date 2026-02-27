`timescale 1ns/1ps

module reg_file (
    input clk,
    input reset,
    input reg_write_en,
    input [4:0] rs1,
    input [4:0] rs2,
    input [4:0] rd,
    input [31:0] wd,
    output [31:0] rdata1,
    output [31:0] rdata2
);

    wire [31:0] reg_outputs [0:31];
    wire [31:0] dec_out;
    
    decoder5to32 decoder_inst (
        .rd(rd),
        .reg_write_en(reg_write_en),
        .dec_out(dec_out)
    );

    genvar i;
    generate
        for (i = 0; i < 32; i = i + 1) begin : reg_gen
            if (i == 0) begin
                assign reg_outputs[0] = 32'b0;
            end else begin
                reg32 reg_inst (
                    .clk(clk),
                    .reset(reset),
                    .we(dec_out[i]),
                    .d(wd),
                    .q(reg_outputs[i])
                );
            end
        end
    endgenerate

    assign #1 rdata1 = reg_outputs[rs1];
    assign #1 rdata2 = reg_outputs[rs2];

endmodule
