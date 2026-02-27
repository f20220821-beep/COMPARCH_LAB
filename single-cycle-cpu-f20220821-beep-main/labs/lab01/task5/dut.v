module dut(input [3:0]a,
           input [3:0]b,
           input sub,
           output [3:0]sum,
           output cout);

wire [3:0]b_xor;
wire cin;

// Two's complement: when sub=1, invert b and set carry-in=1
assign b_xor = b ^ {4{sub}};
assign cin = sub;

// Instantiate 4-bit adder
adder4bit adder(a, b_xor, cin, sum, cout);

endmodule