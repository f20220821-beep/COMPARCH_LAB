`timescale 1ns/1ps

module tb_bankedmem;

    reg clk;
    reg writeEn;
    reg [31:0] address;
    reg [31:0] writeData;
    wire [31:0] readData;

    BankedMEM dut (
        .clk(clk),
        .writeEn(writeEn),
        .address(address),
        .writeData(writeData),
        .readData(readData)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        writeEn = 0;
        address = 0;
        writeData = 0;
        
        // Test write and read
        #10;
        writeEn = 1;
        address = 32'd0;
        writeData = 32'hDEADBEEF;
        #10;
        
        writeEn = 0;
        #1;
        $display("Memory test 1: Write 0xDEADBEEF to address 0, read: 0x%h (expected 0xdeadbeef)", readData);
        
        // Test write to address 4 (word address 1)
        writeEn = 1;
        address = 32'd4;
        writeData = 32'h12345678;
        #10;
        
        writeEn = 0;
        #1;
        $display("Memory test 2: Write 0x12345678 to address 4, read: 0x%h (expected 0x12345678)", readData);
        
        // Read from address 0 again
        address = 32'd0;
        #1;
        $display("Memory test 3: Read from address 0: 0x%h (expected 0xdeadbeef)", readData);

        $finish;
    end

endmodule
