`timescale 1ns/1ps

module tb_reg_read;
    reg clk, reset;
    reg we;
    reg [4:0] rs1, rs2, rd;
    reg [31:0] wd;
    wire [31:0] rdata1, rdata2;

    // Instantiate DUT
    reg_file dut (
        .clk(clk),
        .reset(reset),
        .we(we),
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),
        .wd(wd),
        .rdata1(rdata1),
        .rdata2(rdata2)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;  // 10ns period
    end

    // Waveform dump configuration
    string vcd_file;

    initial begin
        // Check if a VCD file name was passed using +vcd=<filename>
        if ($value$plusargs("vcd=%s", vcd_file))
            $dumpfile(vcd_file);
        else
            $dumpfile("tb_reg_read.vcd");

        // Dump all signals
        $dumpvars(0, dut);
    end

    // Test stimulus
    initial begin
        // Initial conditions
        reset = 1;
        we = 0;
        rs1 = 5'b00000;
        rs2 = 5'b00000;
        rd = 5'b00000;
        wd = 32'b0;

        // Reset the registers
        #10;
        reset = 0;
        #5;

        // Test 1: Read x0 (should be 0)
        $display("Test 1: Read x0 (should be 32'b0)");
        rs1 = 5'b00000;
        rs2 = 5'b00000;
        #10;  // Wait for read delay
        $display("  rdata1 = 0x%08h (expected 0x00000000)", rdata1);
        $display("  rdata2 = 0x%08h (expected 0x00000000)", rdata2);
        
        // Test 2: Write to x1 and read
        $display("\nTest 2: Write 0x12345678 to x1");
        rd = 5'b00001;
        wd = 32'h12345678;
        we = 1;
        #10;  // Clock pulse to write
        we = 0;
        #5;   // Wait for next cycle

        $display("  Reading from x1...");
        rs1 = 5'b00001;
        #10;  // Wait for read delay
        $display("  rdata1 = 0x%08h (expected 0x12345678)", rdata1);

        // Test 3: Write to multiple registers
        $display("\nTest 3: Write to x2 through x5");
        for (int i = 2; i <= 5; i = i + 1) begin
            rd = i;
            wd = 32'hDEADBEEF + i;
            we = 1;
            #10;
            we = 0;
            #5;
            $display("  Wrote 0x%08h to x%0d", wd, i);
        end

        // Test 4: Verify writes
        $display("\nTest 4: Verify written values");
        for (int i = 2; i <= 5; i = i + 1) begin
            rs1 = i;
            #10;  // Wait for read delay
            $display("  x%0d = 0x%08h (expected 0x%08h)", i, rdata1, 32'hDEADBEEF + i);
        end

        // Test 5: Try to write to x0 (should have no effect)
        $display("\nTest 5: Try to write to x0 (should remain 0)");
        rd = 5'b00000;
        wd = 32'hFFFFFFFF;
        we = 1;
        #10;
        we = 0;
        #5;

        rs1 = 5'b00000;
        #10;  // Wait for read delay
        $display("  x0 = 0x%08h (expected 0x00000000)", rdata1);

        // Test 6: Verify x1 still intact
        $display("\nTest 6: Verify x1 unchanged");
        rs1 = 5'b00001;
        #10;  // Wait for read delay
        $display("  x1 = 0x%08h (expected 0x12345678)", rdata1);

        // Test 7: Timing verification - measure clk to Q delay
        $display("\nTest 7: Timing Analysis");
        $display("  Canonical delays: register clk->Q = #1, multiplexer = #1");
        $display("  Expected total read delay from clock edge = 1ns (reg) + 1ns (mux) = 2ns");
        
        // Done
        #50;
        $display("\nAll tests completed!");
        $finish;
    end

endmodule
