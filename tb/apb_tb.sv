`timescale 1ns/1ps
module apb_tb;
  logic        clk;
  logic        rst_n;
  logic        psel;
  logic        penable;
  logic [31:0] paddr;
  logic        pwrite;
  logic [31:0] pwdata;
  logic [31:0] prdata;
  logic        pready;
  logic        perr;

  // apb_driver OWNS clk/rst_n/psel/penable/paddr/pwrite/pwdata —
  // it drives all of these itself (including its own clock generator
  // and its own $finish), so apb_tb must NOT also drive them.
  apb_driver u_apb_driver(
    .clk(clk),
    .rst_n(rst_n),
    .psel(psel),
    .penable(penable),
    .paddr(paddr),
    .pwrite(pwrite),
    .pwdata(pwdata)
  );

  apb_slave u_apb_slave(
    .clk(clk),
    .rst_n(rst_n),
    .psel(psel),
    .penable(penable),
    .paddr(paddr),
    .pwrite(pwrite),
    .pwdata(pwdata),
    .prdata(prdata),
    .pready(pready),
    .perr(perr)
  );

  apb_monitor u_apb_monitor(
    .clk(clk),
    .rst_n(rst_n),
    .psel(psel),
    .penable(penable),
    .paddr(paddr),
    .pwrite(pwrite),
    .pwdata(pwdata),
    .prdata(prdata),
    .pready(pready),
    .perr(perr)
  );

 apb_scoreboard u_apb_scoreboard(
    .clk(clk),
    .rst_n(rst_n),
    .psel(psel),
    .penable(penable),
    .pwrite(pwrite),
    .pwdata(pwdata),
    .prdata(prdata),
    .pready(pready)
  );

  initial begin
    $dumpfile("sim/waves.vcd");
    $dumpvars(0, apb_tb);
  end

  // Watchdog: apb_driver already calls $finish at the end of its own
  // stimulus sequence, but keep this as a safety net in case that
  // sequence stalls for any reason.
  initial begin
    #100000;
    $display("ERROR: Watchdog timeout - simulation did not finish in time");
    $finish;
  end
endmodule