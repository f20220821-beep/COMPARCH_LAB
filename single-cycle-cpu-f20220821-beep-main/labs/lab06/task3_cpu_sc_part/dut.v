`timescale 1ns/1ps

module cpu_sc_part();

    // Internal clock and reset
    reg clk;
    reg reset;

    // Program Counter register
    wire [31:0] pc;
    wire [31:0] pc_plus4;

    // Instruction fetched
    wire [31:0] instruction;

    // Control signals
    wire RegWrite;
    wire ALUSrc;
    wire MemWrite;
    wire MemRead;
    wire [2:0] ALUOp;
    wire [1:0] ImmSel;

    // Register file connections
    wire [31:0] rdata1;
    wire [31:0] rdata2;

    // Immediate
    wire [31:0] immOut;

    // ALU
    wire [31:0] alu_b;
    wire [31:0] alu_result;
    wire alu_zero;

    // Data memory
    wire [31:0] mem_read_data;

    // Write back data
    wire [31:0] wb_data;

    // Instantiate PC register (write enabled always)
    reg32 PC_reg (
        .clk(clk),
        .reset(reset),
        .we(1'b1),
        .d(pc_plus4),
        .q(pc)
    );

    // PC incrementer
    PCInc pcinc_inst (
        .clk(clk),
        .oldPC(pc),
        .newPC(pc_plus4)
    );

    // Instruction memory (read-only IMEM)
    BankedMEM IMEM (
        .clk(clk),
        .writeEn(1'b0),
        .address(pc),
        .writeData(32'b0),
        .readData(instruction)
    );

    // Control Unit
    ControlUnit CU (
        .instruction(instruction),
        .RegWrite(RegWrite),
        .ALUSrc(ALUSrc),
        .MemWrite(MemWrite),
        .MemRead(MemRead),
        .ALUOp(ALUOp),
        .ImmSel(ImmSel)
    );

    // Immediate Generator
    immGen IMM (
        .immSel(ImmSel),
        .instruction(instruction),
        .immOut(immOut)
    );

    // Register file
    reg_file RF (
        .clk(clk),
        .reset(reset),
        .reg_write_en(RegWrite),
        .rs1(instruction[19:15]),
        .rs2(instruction[24:20]),
        .rd(instruction[11:7]),
        .wd(wb_data),
        .rdata1(rdata1),
        .rdata2(rdata2)
    );

    // ALU
    assign alu_b = ALUSrc ? immOut : rdata2;

    rv32ialu ALU (
        .A(rdata1),
        .B(alu_b),
        .alu_ctrl(ALUOp),
        .Y(alu_result),
        .zero(alu_zero)
    );

    // Data memory
    BankedMEM DMEM (
        .clk(clk),
        .writeEn(MemWrite),
        .address(alu_result),
        .writeData(rdata2),
        .readData(mem_read_data)
    );

    // Write back: if MemRead then data from memory else ALU result
    assign wb_data = MemRead ? mem_read_data : alu_result;

    // Simple clock generator inside CPU
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Reset sequence
    initial begin
        reset = 1'b1;
        #10;
        reset = 1'b0;
    end

endmodule
