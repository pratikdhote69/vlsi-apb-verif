`timescale 1ns/1ps
module apb_scoreboard(
  input  logic        clk,
  input  logic        rst_n,
  input  logic        psel,
  input  logic        penable,
  input  logic        pwrite,
  input  logic [31:0] pwdata,
  input  logic [31:0] prdata,
  input  logic        pready
);
  logic [31:0] expected_data;
  logic        write_pending;

  // Capture the written value when a write transfer completes
  always @(posedge clk) begin
    if (~rst_n) begin
      expected_data <= 32'd0;
      write_pending  <= 1'b0;
    end else if (psel && penable && pready && pwrite) begin
      expected_data <= pwdata;
      write_pending  <= 1'b1;
    end
  end

  // Check the read-back value on the NEXT read transfer after a write
  always @(posedge clk) begin
    if (rst_n && psel && penable && pready && !pwrite && write_pending) begin
      $display("[SCOREBOARD] [%0t ns] Checking read-back:", $time);
      $display("  Expected: %h", expected_data);
      $display("  Actual:   %h", prdata);
      if (expected_data == prdata)
        $display("  PASS");
      else
        $display("  FAIL");
    end
  end
endmodule