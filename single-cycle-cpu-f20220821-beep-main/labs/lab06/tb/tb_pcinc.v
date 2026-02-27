`timescale 1ns/1ps

module tb_pcinc;

    reg clk;
    reg [31:0] oldPC;
    wire [31:0] newPC;

    PCInc dut (
        .clk(clk),
        .oldPC(oldPC),
        .newPC(newPC)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        
        // Test case 1: PC = 0
        oldPC = 32'd0;
        #5;
        $display("PC test 1: oldPC = %d, newPC = %d (expected 4)", oldPC, newPC);
        
        // Test case 2: PC = 100
        oldPC = 32'd100;
        #5;
        $display("PC test 2: oldPC = %d, newPC = %d (expected 104)", oldPC, newPC);
        
        // Test case 3: PC = 1000
        oldPC = 32'd1000;
        #5;
        $display("PC test 3: oldPC = %d, newPC = %d (expected 1004)", oldPC, newPC);

        $finish;
    end

endmodule
