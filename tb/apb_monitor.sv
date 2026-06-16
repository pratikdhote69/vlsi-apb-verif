`timescale 1ns/1ps
module apb_monitor(
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
  // Sample on every clock edge where a transfer actually completes
  // (psel && penable && pready), instead of once at time 0.
  always @(posedge clk) begin
    if (rst_n && psel && penable && pready) begin
      $display("[MONITOR] [%0t ns] APB transaction:", $time);
      $display("  Address:    %h", paddr);
      $display("  Write:      %b", pwrite);
      $display("  Write data: %h", pwdata);
      $display("  Read data:  %h", prdata);
      $display("  Error:      %b", perr);
    end
  end
endmodule