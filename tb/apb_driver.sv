`timescale 1ns/1ps
module apb_driver(
  output logic        clk,
  output logic        rst_n,
  output logic        psel,
  output logic        penable,
  output logic [31:0] paddr,
  output logic        pwrite,
  output logic [31:0] pwdata
);
  initial begin
    clk   = 0;
    rst_n = 0;
    psel  = 0;
    penable = 0;
    paddr  = 32'd0;
    pwrite = 0;
    pwdata = 32'd0;
    #100;
    rst_n = 1;
    #100;
    psel  = 1;
    penable = 1;
    paddr  = 32'h1000;
    pwrite = 1;
    pwdata = 32'hdead;
    #100;
    pwrite = 0;
    #100;
    $finish;
  end

  always #5 clk = ~clk;
endmodule