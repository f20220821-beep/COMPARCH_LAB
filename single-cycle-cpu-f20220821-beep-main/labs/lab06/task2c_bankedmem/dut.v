`timescale 1ns/1ps

module BankedMEM (
    input  clk,
    input  writeEn,
    input  [31:0] address,
    input  [31:0] writeData,
    output [31:0] readData
);

    // Four 8-bit memory banks, each with 1024 locations
    reg [7:0] bank0 [0:1023];
    reg [7:0] bank1 [0:1023];
    reg [7:0] bank2 [0:1023];
    reg [7:0] bank3 [0:1023];
    
    // Extract the word address from the 32-bit address
    // Address is word-aligned, so we use bits [11:2] to index 1024 locations (2^10)
    wire [9:0] word_addr = address[11:2];
    
    // Asynchronous read: concatenate outputs from all four banks
    assign readData = {bank3[word_addr], bank2[word_addr], bank1[word_addr], bank0[word_addr]};
    
    // Synchronous write: write data on clock edge
    always @(posedge clk) begin
        if (writeEn) begin
            bank0[word_addr] <= writeData[7:0];
            bank1[word_addr] <= writeData[15:8];
            bank2[word_addr] <= writeData[23:16];
            bank3[word_addr] <= writeData[31:24];
        end
    end

endmodule
