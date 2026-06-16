`timescale 1ns/1ps
module apb_slave(
  input  logic        clk,
  input  logic        rst_n,
  input  logic        psel,
  input  logic        penable,
  input  logic [31:0] paddr,
  input  logic        pwrite,
  input  logic [31:0] pwdata,
  output logic [31:0] prdata,
  output logic        pready,
  output logic        perr
);
  logic [31:0] addr;
  logic [31:0] data;
  logic        ready;
  logic        err;

  always_ff @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
      addr  <= 32'd0;
      data  <= 32'd0;
      ready <= 1'b0;
      err   <= 1'b0;
    end else if (psel && penable) begin
      addr  <= paddr;
      data  <= pwdata;
      ready <= 1'b1;
      if (pwrite) begin
        // Write logic
      end else begin
        // Read logic
      end
    end else begin
      ready <= 1'b0;
    end
  end

  assign prdata = data;
  assign pready = ready;
  assign perr   = err;
endmodule