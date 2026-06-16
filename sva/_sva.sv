`timescale 1ns/1ps
module apb_sva(
  input  logic        clk,
  input  logic        rst_n,
  input  logic        psel,
  input  logic        penable,
  input  logic [31:0] paddr,
  input  logic        pwrite,
  input  logic [31:0] pwdata,
  input  logic [31:0] prdata,
  input  logic        pready,
  input  logic        perr
);
  // Reset property: no output activity during reset
  property reset_prop;
    @(posedge clk) disable iff (~rst_n)
      (psel || penable || pwrite || pwdata || prdata || pready || perr);
  endproperty
  assert property (@(posedge clk) reset_prop) else $display("Reset property failed");

  // APB protocol-specific assertions
  property apb_prop1;
    @(posedge clk) disable iff (~rst_n)
      psel && penable && pwrite -> pwdata == prdata;
  endproperty
  assert property (@(posedge clk) apb_prop1) else $display("APB property 1 failed");

  property apb_prop2;
    @(posedge clk) disable iff (~rst_n)
      psel && penable && ~pwrite -> prdata == pwdata;
  endproperty
  assert property (@(posedge clk) apb_prop2) else $display("APB property 2 failed");

  property apb_prop3;
    @(posedge clk) disable iff (~rst_n)
      psel && penable && pwrite -> pready == 1'b1;
  endproperty
  assert property (@(posedge clk) apb_prop3) else $display("APB property 3 failed");

  property apb_prop4;
    @(posedge clk) disable iff (~rst_n)
      psel && penable && ~pwrite -> pready == 1'b1;
  endproperty
  assert property (@(posedge clk) apb_prop4) else $display("APB property 4 failed");

  property apb_prop5;
    @(posedge clk) disable iff (~rst_n)
      perr -> pready == 1'b0;
  endproperty
  assert property (@(posedge clk) apb_prop5) else $display("APB property 5 failed");
endmodule