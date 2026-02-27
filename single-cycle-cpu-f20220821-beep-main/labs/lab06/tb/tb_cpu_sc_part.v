`timescale 1ns/1ps

module tb_cpu_sc_part;

    // Instantiate the CPU
    cpu_sc_part DUT();

    integer i;
    reg [31:0] p0, p1, p2, p3, p4, p5;

    initial begin
        // Sample program from manual (machine code words)
        // 1: addi x1, x0, 10
        p0 = 32'h00A00093;
        // 2: addi x2, x0, 20
        p1 = 32'h01400113;
        // 3: add x3, x1, x2
        p2 = 32'h002081B3;
        // 4: sw x3, 0(x0)
        p3 = 32'h00302023;
        // 5: lw x4, 0(x0)
        p4 = 32'h00002203;
        // 6: sub x5, x4, x1
        p5 = 32'h401202B3;

        // Load program into IMEM banks via hierarchical access
        // Load words one by one
        DUT.IMEM.bank0[0] = p0[7:0]; DUT.IMEM.bank1[0] = p0[15:8]; DUT.IMEM.bank2[0] = p0[23:16]; DUT.IMEM.bank3[0] = p0[31:24];
        DUT.IMEM.bank0[1] = p1[7:0]; DUT.IMEM.bank1[1] = p1[15:8]; DUT.IMEM.bank2[1] = p1[23:16]; DUT.IMEM.bank3[1] = p1[31:24];
        DUT.IMEM.bank0[2] = p2[7:0]; DUT.IMEM.bank1[2] = p2[15:8]; DUT.IMEM.bank2[2] = p2[23:16]; DUT.IMEM.bank3[2] = p2[31:24];
        DUT.IMEM.bank0[3] = p3[7:0]; DUT.IMEM.bank1[3] = p3[15:8]; DUT.IMEM.bank2[3] = p3[23:16]; DUT.IMEM.bank3[3] = p3[31:24];
        DUT.IMEM.bank0[4] = p4[7:0]; DUT.IMEM.bank1[4] = p4[15:8]; DUT.IMEM.bank2[4] = p4[23:16]; DUT.IMEM.bank3[4] = p4[31:24];
        DUT.IMEM.bank0[5] = p5[7:0]; DUT.IMEM.bank1[5] = p5[15:8]; DUT.IMEM.bank2[5] = p5[23:16]; DUT.IMEM.bank3[5] = p5[31:24];

        // Let CPU run for a number of clock cycles (one instruction per cycle)
        #400; // 400 ns -> plenty of cycles

        // Display register values x1..x5
        $display("x1 = %0d", $signed(DUT.RF.reg_outputs[1]));
        $display("x2 = %0d", $signed(DUT.RF.reg_outputs[2]));
        $display("x3 = %0d", $signed(DUT.RF.reg_outputs[3]));
        $display("x4 = %0d", $signed(DUT.RF.reg_outputs[4]));
        $display("x5 = %0d", $signed(DUT.RF.reg_outputs[5]));

        // Display memory[0]
        $display("mem[0] = 0x%h", {DUT.DMEM.bank3[0], DUT.DMEM.bank2[0], DUT.DMEM.bank1[0], DUT.DMEM.bank0[0]});

        $finish;
    end

endmodule
