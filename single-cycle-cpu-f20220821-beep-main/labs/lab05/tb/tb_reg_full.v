`timescale 1ns/1ps

module tb_reg_full;
    reg clk, reset;
    reg reg_write_en;
    reg [4:0] rs1, rs2, rd;
    reg [31:0] wd;
    wire [31:0] rdata1, rdata2;

    // Instantiate DUT
    reg_file dut (
        .clk(clk),
        .reset(reset),
        .reg_write_en(reg_write_en),
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
            $dumpfile("tb_reg_full.vcd");

        // Dump all signals
        $dumpvars(0, dut);
    end

    // Test stimulus
    initial begin
        // =========== INITIALIZATION ===========
        $display("========================================");
        $display("Task 2: Register File Write Path Tests");
        $display("========================================\n");

        reset = 1;
        reg_write_en = 0;
        rs1 = 5'b00000;
        rs2 = 5'b00000;
        rd = 5'b00000;
        wd = 32'b0;

        // Reset the registers
        #10;
        reset = 0;
        #5;

        // =========== TEST 1: Verify x0 is always 0 ===========
        $display("\n[TEST 1] x0 is hard-wired to 0");
        rs1 = 5'b00000;
        #10;
        $display("  Before any writes: rdata1 = 0x%08h (expected 0x00000000)", rdata1);
        if (rdata1 === 32'h00000000)
            $display("  ✓ PASS");
        else
            $display("  ✗ FAIL");

        // =========== TEST 2: Write to x1 and read ===========
        $display("\n[TEST 2] Write to x1 (register 1)");
        rd = 5'b00001;
        wd = 32'hDEADBEEF;
        reg_write_en = 1;
        #10;  // Clock pulse
        reg_write_en = 0;
        #5;

        $display("  After write cycle:");
        rs1 = 5'b00001;
        #10;  // Wait for read delay
        $display("  rdata1 = 0x%08h (expected 0xDEADBEEF)", rdata1);
        if (rdata1 === 32'hDEADBEEF)
            $display("  ✓ PASS");
        else
            $display("  ✗ FAIL");

        // =========== TEST 3: Write multiple registers ===========
        $display("\n[TEST 3] Write to multiple registers (x2-x7)");
        for (int i = 2; i <= 7; i = i + 1) begin
            rd = i;
            wd = 32'h10000000 + (i << 20);  // Distinct pattern per register
            reg_write_en = 1;
            #10;
            reg_write_en = 0;
            #5;
        end
        $display("  Written values to x2-x7");

        // =========== TEST 4: Verify all writes ===========
        $display("\n[TEST 4] Verify all written registers");
        reg_write_en = 0;  // Disable writes for read verification
        for (int i = 2; i <= 7; i = i + 1) begin
            rs1 = i;
            #10;
            $display("  x%0d = 0x%08h (expected 0x%08h)", i, rdata1, 32'h10000000 + (i << 20));
            if (rdata1 === (32'h10000000 + (i << 20)))
                $display("    ✓ PASS");
            else
                $display("    ✗ FAIL");
        end

        // =========== TEST 5: Simultaneous dual read ===========
        $display("\n[TEST 5] Dual-port simultaneous read");
        rs1 = 5'b00001;  // x1 = 0xDEADBEEF
        rs2 = 5'b00010;  // x2 = 0x10200000
        #10;
        $display("  rdata1 (from x1) = 0x%08h (expected 0xDEADBEEF)", rdata1);
        $display("  rdata2 (from x2) = 0x%08h (expected 0x10200000)", rdata2);
        if ((rdata1 === 32'hDEADBEEF) && (rdata2 === 32'h10200000))
            $display("  ✓ PASS");
        else
            $display("  ✗ FAIL");

        // =========== TEST 6: x0 write protection ===========
        $display("\n[TEST 6] Attempt to write 0xFFFFFFFF to x0");
        rd = 5'b00000;
        wd = 32'hFFFFFFFF;
        reg_write_en = 1;
        #10;
        reg_write_en = 0;
        #5;

        $display("  After attempted write to x0:");
        rs1 = 5'b00000;
        #10;
        $display("  x0 = 0x%08h (expected 0x00000000)", rdata1);
        if (rdata1 === 32'h00000000)
            $display("  ✓ PASS - x0 is write-protected");
        else
            $display("  ✗ FAIL - x0 was corrupted!");

        // =========== TEST 7: Verify x1 unchanged after x0 write attempt ===========
        $display("\n[TEST 7] Verify x1 unchanged after x0 write attempt");
        rs1 = 5'b00001;
        #10;
        $display("  x1 = 0x%08h (expected 0xDEADBEEF)", rdata1);
        if (rdata1 === 32'hDEADBEEF)
            $display("  ✓ PASS");
        else
            $display("  ✗ FAIL");

        // =========== TEST 8: Write with read disable ===========
        $display("\n[TEST 8] Overwrite existing register (x5)");
        rd = 5'b00101;
        wd = 32'hCAFEBABE;
        reg_write_en = 1;
        #10;
        reg_write_en = 0;
        #5;

        rs1 = 5'b00101;
        #10;
        $display("  x5 after overwrite = 0x%08h (expected 0xCAFEBABE)", rdata1);
        if (rdata1 === 32'hCAFEBABE)
            $display("  ✓ PASS");
        else
            $display("  ✗ FAIL");

        // =========== TEST 9: Disable write enable (reg_write_en = 0) ===========
        $display("\n[TEST 9] Write with reg_write_en = 0 (no write)");
        rd = 5'b00011;
        wd = 32'h12345678;
        reg_write_en = 0;  // Disabled
        #10;

        rs1 = 5'b00011;
        #10;
        $display("  x3 = 0x%08h (expected 0x10300000 - unchanged)", rdata1);
        if (rdata1 === 32'h10300000)
            $display("  ✓ PASS - Write correctly blocked by reg_write_en");
        else
            $display("  ✗ FAIL");

        // =========== TIMING ANALYSIS ===========
        $display("\n========================================");
        $display("Task 2C: Write Timing Path Analysis");
        $display("========================================");
        $display("\nWrite timing path:");
        $display("  rd (stable) → Decoder (#1) → reg[i].we port");
        $display("  → Clock edge (t=0) → Register update (t=1ns via clk->Q)");
        $display("\nCanonical delays:");
        $display("  Decoder output delay: #1 = 1ns");
        $display("  Register clk->Q delay: #1 = 1ns");
        $display("\nSetup time requirement:");
        $display("  Data (wd) and control (rd, reg_write_en) must be stable");
        $display("  at least 1ns before clock edge (decoder delay).");
        $display("  Register update appears at output 1ns after clock edge.");
        $display("\nTotal write-to-read latency: ~2 cycles (20ns @ 10ns/cycle)");
        $display("  Cycle 1: Write issued (rd, wd, reg_write_en stable)");
        $display("  Cycle 2: Clock edge triggers register update");
        $display("  Cycle 3: Read path available (rdata valid at t+2ns after read)");

        // =========== COMPLETION ===========
        #50;
        $display("\n========================================");
        $display("All tests completed!");
        $display("========================================\n");
        $finish;
    end

endmodule
