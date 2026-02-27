module dut (a,b,cin,cout,sum);
input a,b,cin;
output cout,sum;
wire t1,t2,t3;
xor x1(t1,a,b);
xor x2(sum,t1,cin);
and a1(t2,a,b);
and a2(t3,t1,cin);
or o1(cout,t2,t3);
endmodule