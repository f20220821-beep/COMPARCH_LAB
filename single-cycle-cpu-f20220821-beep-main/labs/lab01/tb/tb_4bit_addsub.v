module tb;
  reg [3:0]a;
  reg [3:0]b;
  reg sub;
  wire [3:0]sum;
  wire cout;

  dut DUT(.a(a),.b(b),.sub(sub),.sum(sum),.cout(cout));

  initial begin
    if ($value$plusargs("vcd=%s", vcd_file))
      $dumpfile(vcd_file);
    else
      $dumpfile("artefacts/default.vcd");

    $dumpvars(0, DUT);

    a=4'H4; b=4'H0; sub=0;#10;
    a=4'H8; b=4'HB; sub=0;#10;
    a=4'HD; b=4'HF; sub=0;#10;
    a=4'H3; b=4'H1; sub=0;#10;
    a=4'H0; b=4'H9; sub=0;#10;
    a=4'HF; b=4'H0; sub=0;#10;

    a=4'H4; b=4'H0; sub=1;#10;
    a=4'H8; b=4'HB; sub=1;#10;
    a=4'HD; b=4'HF; sub=1;#10;
    a=4'H3; b=4'H1; sub=1;#10;
    a=4'H0; b=4'H9; sub=1;#10;
    a=4'HF; b=4'H0; sub=1;#10;

    $finish;
  end

endmodule