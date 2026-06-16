`timescale 1ns/1ps
module apb_sva (
    input pclk,
    input presetn,
    input [31:0] paddr,
    input pwrite,
    input psel,
    input penable,
    output [31:0] paddr_out,
    output pwrite_out,
    output psel_out,
    output penable_out
);
    // Reset property: no output activity during reset
    property reset_prop;
        @(posedge pclk) disable iff (!presetn) paddr_out == 32'h0 && pwrite_out == 1'b0 && psel_out == 1'b0 && penable_out == 1'b0;
    endproperty
    assert property (@(posedge pclk) reset_prop) else $display("ERROR: Reset property failed");

    // Protocol-specific assertions
    property write_assert;
        @(posedge pclk) psel && penable && pwrite -> paddr_out == paddr;
    endproperty
    assert property (@(posedge pclk) write_assert) else $display("ERROR: Write assertion failed");

    property read_assert;
        @(posedge pclk) psel && !penable -> paddr_out == paddr;
    endproperty
    assert property (@(posedge pclk) read_assert) else $display("ERROR: Read assertion failed");

    // Cover properties
    covergroup cg @(posedge pclk);
        coverpoint paddr;
        coverpoint pwrite;
        coverpoint psel;
        coverpoint penable;
    endgroup
    cg cg_inst;
endmodule