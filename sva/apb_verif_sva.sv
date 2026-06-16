`timescale 1ns/1ps

module apb_assertions (
    input  logic        PCLK,
    input  logic        PRESETn,
    input  logic [31:0] PADDR,
    input  logic        PSEL,
    input  logic        PENABLE,
    input  logic        PWRITE,
    input  logic [31:0] PWDATA,
    input  logic [3:0]  PSTRB,
    input  logic [31:0] PRDATA,
    input  logic        PREADY,
    input  logic        PSLVERR
);

    // 1. Reset Property: No output activity during reset
    property p_reset_behavior;
        @(posedge PCLK) !PRESETn |-> (PREADY == 1'b0 && PSLVERR == 1'b0 && PRDATA == 32'h0);
    endproperty
    a_reset_behavior: assert property (p_reset_behavior)
        else $error("[SVA_ERR] Outputs active during reset!");

    // 2. Protocol: PENABLE must only assert 1 cycle after PSEL
    property p_penable_rise;
        @(posedge PCLK) disable iff (!PRESETn)
        $rose(PENABLE) |-> $past(PSEL);
    endproperty
    a_penable_rise: assert property (p_penable_rise)
        else $error("[SVA_ERR] PENABLE rose without PSEL being active in the previous cycle!");

    // 3. Protocol: Control signals must remain stable during access phase
    property p_control_stable;
        @(posedge PCLK) disable iff (!PRESETn)
        (PSEL && !PREADY) |-> $stable(PADDR) && $stable(PWRITE) && $stable(PSTRB);
    endproperty
    a_control_stable: assert property (p_control_stable)
        else $error("[SVA_ERR] Bus control signals changed while PREADY was low!");

    // 4. Protocol: PENABLE must fall after transfer completes
    property p_penable_fall;
        @(posedge PCLK) disable iff (!PRESETn)
        (PENABLE && PREADY) |-> ##1 !PENABLE;
    endproperty
    a_penable_fall: assert property (p_penable_fall)
        else $error("[SVA_ERR] PENABLE did not fall after transfer completion!");

    // 5. Protocol: PSLVERR only active when PSEL and PENABLE are active
    property p_pslverr_valid;
        @(posedge PCLK) disable iff (!PRESETn)
        PSLVERR |-> (PSEL && PENABLE);
    endproperty
    a_pslverr_valid: assert property (p_pslverr_valid)
        else $error("[SVA_ERR] PSLVERR asserted outside of valid access phase!");

    // 6. Data Integrity: PRDATA must be stable when PREADY is high during read
    property p_prdata_stable;
        @(posedge PCLK) disable iff (!PRESETn)
        (PSEL && PENABLE && !PWRITE && PREADY) |-> !$isunknown(PRDATA);
    endproperty
    a_prdata_stable: assert property (p_prdata_stable)
        else $error("[SVA_ERR] PRDATA contains unknown values during valid read completion!");

    // Cover Properties
    c_write_transfer: cover property (@(posedge PCLK) disable iff (!PRESETn) PSEL && PENABLE && PWRITE && PREADY);
    c_read_transfer:  cover property (@(posedge PCLK) disable iff (!PRESETn) PSEL && PENABLE && !PWRITE && PREADY);
    c_wait_state:     cover property (@(posedge PCLK) disable iff (!PRESETn) PSEL && PENABLE && !PREADY ##1 PREADY);
    c_error_response: cover property (@(posedge PCLK) disable iff (!PRESETn) PSEL && PENABLE && PSLVERR);

endmodule

// Bind Statement to attach assertions to the RTL module
bind apb_slave apb_assertions u_apb_assertions_bind (
    .PCLK    (PCLK),
    .PRESETn (PRESETn),
    .PADDR   (PADDR),
    .PSEL    (PSEL),
    .PENABLE (PENABLE),
    .PWRITE  (PWRITE),
    .PWDATA  (PWDATA),
    .PSTRB   (PSTRB),
    .PRDATA  (PRDATA),
    .PREADY  (PREADY),
    .PSLVERR (PSLVERR)
);