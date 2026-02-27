# CS F342 – Computer Architecture
## Lab 4: Structural Design of a 32-bit ALU

## Submission

Submit:
- Add all tasks to your codespace. Submit take-home part by committing and pushing with the exact message `lab04-eval`
- **Ensure all tasks are placed in the correct folder.** Especially the evaluative code. Otherwise it will not be graded. We are not responsible for missed marks due to incorrect file organization.

---


## Objective

The objective of **Lab 4** is to design a **structural, timing-aware Arithmetic Logic Unit (ALU)**.

This lab emphasizes:
- **Structural (datapath-level) RTL design**
- **Timing awareness** through canonical delay annotation
- Understanding how **critical paths** arise in processor datapaths
- Deep reasoning about **two’s complement arithmetic** and **interpretation vs operation**
- **Writing your own testbenches**

---

## Background

### 1. Why Timing Matters in Architecture

In a synchronous processor:

```
Register → Combinational Logic → Register
```

The **longest combinational delay** between two registers determines:
- the **minimum clock period**
- the **maximum clock frequency**

From this lab onward, *all designs are expected to be timing-aware*.

### 2. Important architectural points:

- The ALU **does not decode instructions**
- The ALU **does not see opcodes, funct3, or funct7**
- Instruction decoding produces a **final ALU control signal**
- The same ALU hardware is reused for:
  - arithmetic instructions
  - logical instructions
  - address calculation
  - branch comparison

In this lab, instruction decoding is assumed to be already done.

---

## Design Philosophy and Constraints

### 1. Structural Design Requirement

You must design the ALU **structurally**, by composing it from smaller submodules.

❌ A single behavioral `case` statement that directly computes all operations is **not allowed**.

✔ Behavioral code *inside submodules* is allowed.

### 2. Datapath Reuse

You are expected to reuse hardware wherever possible:

- A single **adder/subtractor** must support:
  - ADD
  - SUB
  - SLT (signed)
- A single **shifter** must support:
  - SLL
  - SRL
- Comparison operations must reuse arithmetic results

### 3. Timing-Aware RTL Requirement

All **combinational submodules** must include **explicit delay annotations** (`#`) that represent **relative logic depth**, not physical silicon delay. The delays you will use are indicated below.

### 4. Canonical Delay Budget

Use the following canonical delay budget consistently:

| Component | Canonical Delay |
|---------|-----------------|
| 32-bit Adder/Subtractor | `#3` |
| Comparator logic (in addition to adder/subtractor) | `#1` |
| Logic unit (AND / OR) | `#1` |
| Shifter (SLL / SRL) | `#2` |
| Multiplexer | `#1` |
| Register clk→Q | `#1` |
| Register setup time | `#1` |

These values are abstract and technology-independent. Delays are provided at the timescale of 1 ns. Include this line to make it explicit in your code: ```
`timescale 1ns/1ps```. The syntax is ```
`timescale <time_unit> / <time_precision>```.

---

## ALU Interface Specification

Your ALU must implement the following interface:

```verilog
input  signed [31:0] A,
input  signed [31:0] B,
input  [2:0]         alu_ctrl,
output signed [31:0] Y,
output               zero
```

### Signal meanings

- `A`, `B`: 32-bit signed operands
- `alu_ctrl`: final ALU control signal (generated elsewhere)
- `Y`: 32-bit ALU result
- `zero`: asserted when `Y == 0`

For shift operations, the shift amount must be taken from `B[4:0]`.

---

## Supported Operations

Your ALU must support the following operations:

| alu_ctrl | Operation | Description |
|---------|-----------|-------------|
| 000 | SUB | Signed subtraction |
| 001 | ADD | Signed addition |
| 010 | AND | Bitwise AND |
| 011 | OR  | Bitwise OR |
| 100 | SLL | Logical left shift |
| 101 | SRL | Logical right shift |
| 110 | SLT | Set-less-than (signed) |
| 111 | Reserved | Output zero |
---
### General Guide to Writing a Verilog Testbench
---


A testbench is a standalone module with **no input or output ports**.  
It simply wraps and drives the Design Under Test (DUT).

**Read the comments below carefully to learn about writing testbenches and practical tips.**

```verilog
module tb;
reg  [31:0] A, B;             // input of the DUT are declared as reg
reg  [2:0]  alu_ctrl;         // outputs are declared as wires
wire [31:0] Y;                // in a test bench
wire        zero;             

alu dut (                     // the module that needs to simulated 
    .A(A),                    // is instantiated under an instance name
    .B(B),                    // i.e., "dut" in this case
    .alu_ctrl(alu_ctrl),
    .Y(Y),
    .zero(zero)
);

// ----------------------------------------------------------------------------------------------
// ENSURE YOU INCLUDE THIS BLOCK FOR COMPILATION TO WORK CORRECTLY!!!!!!!!!!!!!
// Waveform dump configuration
// ----------------------------------------------------------------------------------------------
// This string will store the VCD file name passed from the command line.
string vcd_file;

// This initial block runs once at the start of simulation.
initial begin
   // Check if a VCD file name was passed using +vcd=<filename>
   if ($value$plusargs("vcd=%s", vcd_file))
   // If provided, dump waveforms to that file
   $dumpfile(vcd_file);
   else
   // Otherwise, use a default file name
   $dumpfile("fa.vcd");

   // Dump all signals inside the DUT hierarchy
   $dumpvars(0, DUT);
end

// ----------------------------------------------------------------------------------------------
// Test logic
// This will generate waveforms that you can test manually
// You can also print 'test results' directly by comparing to expected outputs
// See https://github.com/csf342/csf342-p2-labs-csf342-labs/blob/main/labs/lab01/tb/tb_fa.v for reference.
// ----------------------------------------------------------------------------------------------

initial begin                 // Stimulus generation
    // Test case 1
    A = 10; B = 5; alu_ctrl = 3'b000;   // ADD
    #10;

    // Test case 2
    A = -4; B = 7; alu_ctrl = 3'b001;   // SUB
    #10;

    $finish;
end


endmodule
```
---

## In-Lab Tasks

* For each task, create the actual module in the `../../shared` folder, which should already exist.  
* In the task folder, such as `task0`, create a wrapper module named `dut`, which uses the actual module from `shared`.  
* This will allow you to reuse your modules for later tasks and labs.
* The module names to be used in the `shared` folder are specified. Make sure you use exactly that name without **any** change.

### Task 1: Timing-Aware 32-bit Adder / Subtractor

**Objective:**  
Design a 32-bit signed adder/subtractor module.  
Module name: `aluaddsub`

**Requirements:**
- One module must support both addition and subtraction
- Subtraction must be implemented using **two’s complement**
- You may use Verilog `+` internally
- Output must be 32-bit signed
- Negative overflow flag and positive overflow flag
   - Incoming carry into MSB is 1 and outgoing carry is 0 -- positive overflow
   - Incoming carry into MSB is 0 and outgoing carry is 1 -- negative overflow


**What to test:**
- positive + positive
- positive + negative
- subtraction resulting in negative values

**For each of the above, report the delay in `ns` between application of input to stabilization of output** in the box below. Use the waveform viewer for this.
```

```

---

### Task 2: Logic Unit

**Objective:**  
Design a logic unit that computes bitwise operations.
Module name: `alulogic`

**Requirements:**
- Support AND and OR
- Operands must be 32-bit
- Output must be combinational

**What to test:**
- random bit patterns
- edge cases (all zeros, all ones)

**For each of the above, report the delay between application of input to stabilization of output** in the box below. Use the waveform viewer for this.
```

```

---

### Task 3: Shifter

**Objective:**  
Design a logical shifter module.
Module name: `alushift`

**Requirements:**
- Support SLL and SRL
- Shift amount must be `B[4:0]`
- Shifts must be logical (no sign extension)

**What to test:**
- shift by 0
- shift by 1
- shift by -1 (what do you expect? Is the behavior consistent with your intuition?)

**For each of the above, report the delay between application of input to stabilization of output** in the box below. Use the waveform viewer for this.
```

```

---

### Task 4: Signed Comparator (SLT)

**Objective:**  
Implement signed comparison using existing arithmetic hardware (you can import and reuse the adder/subtractor module from task 1, `aluaddsub`).
Module name: `alucomp`

**Requirements:**
- Output `32'b1` if `A < B`, else `32'b0`
- Must reuse subtraction result
- Must handle overflow correctly

**Hint:**  
Signed comparison is not simply checking the sign bit when overflow occurs.

**For each of the above, report the delay between application of input to stabilization of output** in the box below. Use the waveform viewer for this.
```

```

**Side Exercise:** <br>
Go through the ALU Control signal and check whether it's synthesizable on microarchitectural level if we used 000 for ADD and 001 for SUB. <br>
(hint : Subtractor and SLT use the same operation, so they can use single control bit to select both of the operations). Comment below:
```

```

---

### Task 5: Integrated Structural ALU

**Objective:**  
Integrate all submodules into a single structural ALU.
Module name: `rv32ialu`

**Requirements:**
- All submodules compute in parallel
- A multiplexer selects final output based on `alu_ctrl`
- `zero` flag is derived from final output only
- No instruction decoding logic allowed inside the ALU

**Tming analysis:** based on the observations above, which operation is the slowest for the ALU you designed?
```

```

---

## Testing Expectations

You are expected to:
- Write systematic test cases on your own test bench  
**Follow the same convention as before**:
   - Top level module to be tested should be named `dut`
   - Test benches should live in the `tb` folder under `lab04` with appropriate names (`taskx` works best)
   - Each task should live in its own folder
   - But the actual module should be in `../../shared`
- Test boundary conditions
- Use waveforms for debugging`

---

## Take-Home Evaluative Component  
## Signed vs Unsigned Interpretation in ALU Design

---

### Part A: Two’s Complement and Overflow (Conceptual)

Answer the following in the space provided below:

1. Explain how signed overflow occurs in two’s complement addition.
   ```
   Signed overflow happens when two operands with the same sign produce a result
   with the opposite sign. Equivalently, it is detected when the carry into the
   sign bit (bit 31) differs from the carry out of the sign bit (carry_in ^ carry_out = 1).
   This means the high-order addition caused the sign to flip unexpectedly, so
   the interpreted signed magnitude is incorrect.

   Examples: adding two positive numbers that yield a negative result, or two
   negative numbers that yield a positive result.
   ```

2. Why does carry-out fail to indicate signed overflow?
   ```
   Carry-out is an unsigned indicator: it shows a carry beyond the MSB in
   binary arithmetic (magnitude carry). Signed overflow depends on the relation
   between carries into and out of the sign bit (or on operand/result sign bits).
   A carry-out can occur without a signed overflow and vice versa, so it alone
   is not sufficient to detect signed overflow.
   ```

3. Why does RISC-V avoid exposing overflow flags in the ISA?
   ```
   RISC‑V keeps the ISA simple and orthogonal by avoiding implicit, processor-wide
   flags that complicate pipelining, exception handling, and composability of
   instructions. Overflow is a semantic property that compilers or higher-level
   runtime checks can handle explicitly when needed; keeping no global overflow
   flag simplifies implementation and avoids hidden state.
   ```

Your explanation must refer to:
- sign bits
- operand signs
- result sign

---

### Part B: Same Hardware, Different Meaning

For each case below, fill the table and explain your reasoning.

| A (hex) | B (hex) | Operation | Result (hex) | Signed Meaning | Unsigned Meaning |
|--------|---------|-----------|--------------|----------------|------------------|
| 0x80000000 | 0x00000001 | A + B | 0x80000001 | Signed: -2147483647 (negative) | Unsigned: 2147483649 |
| 0xFFFFFFFF | 0x00000001 | A + B | 0x00000000 | Signed: 0 | Unsigned: 0 |
| 0x00000001 | 0xFFFFFFFF | A < B | (signed) 0x00000000 / (unsigned) 0x00000001 | Signed: 1 < -1 → false (0) | Unsigned: 1 < 4294967295 → true (1) |

Explain:
```
The ALU computes bitwise addition/subtraction and comparison primitives on raw
two's-complement bit patterns. The same resulting bits can represent different
numeric values depending on interpretation: for signed numbers the MSB is a
sign bit, while for unsigned numbers it contributes to magnitude. Therefore the
same binary result (e.g., 0x80000001) maps to different decimal values under
signed vs unsigned interpretation.
```

---

### Part C: Signed vs Unsigned Comparison (Conceptual)

1. Explain how `SLT` (signed) can be implemented using subtraction.
   ```
   Compute R = A - B (two's complement). Signed `A < B` is true when R is
   negative after accounting for overflow. A correct implementation uses the
   sign bit XOR overflow: `SLT = R[31] ^ overflow`, where
   `overflow = carry_into_msb ^ carry_out_of_msb`.
   ```

2. Explain why `SLTU` (unsigned set less than) cannot rely on the sign bit.
   ```
   For unsigned numbers the MSB is part of the magnitude, not a sign. The
   result sign bit from two's-complement subtraction does not indicate unsigned
   ordering. Unsigned comparison must inspect borrow/carry (see next answer)
   rather than the result sign bit.
   ```

3. Explain what role carry / borrow plays in unsigned comparison.
   ```
   When computing A - B as A + (~B) + 1, the final carry-out bit indicates if
   a borrow occurred. If `carry_out == 1` then A >= B (no borrow). If
   `carry_out == 0` then A < B (borrow). Thus `SLTU = ~carry_out`.
   ```

---

### Part D: Design Extension – SLTU Support

Extend your ALU to support:

```
SLTU: rd = (A < B) ? 1 : 0   // unsigned comparison
```

**Constraints:**
- Do NOT add a second subtractor
- Do NOT use Verilog’s `<` operator for unsigned comparison
- Reuse existing arithmetic hardware

**What to submit:**
1. Block-level explanation of how SLTU is implemented
   ```
   Compute an extended 33-bit subtraction `S = {1'b0, A} + {1'b0, ~B} + 33'b1`.
   The MSB of `S` (`S[32]`) is the carry-out. If `S[32] == 0` then A < B in
   unsigned arithmetic. No extra subtractor module is required; the existing
   adder-style arithmetic is reused and only the extended carry is inspected to
   generate the `SLTU` result.
   ```
   
2. Implementation file (under `lab04/task6`)
3. Explanation of why SLT and SLTU differ despite identical hardware
   ```
   The same adder computes bit patterns for A-B, but SLT and SLTU look at
   different status signals: SLT uses the signed result sign combined with
   overflow, whereas SLTU uses the unsigned carry/borrow. Identical datapath
   bits, different post-processing -> different semantic outcomes.
   ```

---

### Part E: Reflection

In **5–7 lines**, answer:

> What is the most important architectural insight you gained from implementing SLTU?
   ```
   ```
   The key insight is that datapath hardware is value-agnostic: the same adder
   can serve both signed and unsigned semantics if control logic inspects the
   appropriate status signals (overflow vs carry). This encourages reuse and
   keeps hardware compact, while pushing interpretation to the control path.
   It also clarifies why ISAs avoid implicit flags — interpretation should be
   explicit and composable rather than baked into hidden processor state.
   ```

---