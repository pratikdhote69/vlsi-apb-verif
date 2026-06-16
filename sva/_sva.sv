`timescale 1ns/1ps

module apb_assertions (
  input logic        PCLK,
  input logic        PRESETn,
  input logic [31:0] PADDR,
  input logic        PSEL,
  input logic        PENABLE,
  input logic        PWRITE,
  input logic [31:0] PWDATA,
  input logic        PREADY,
  input logic [31:0] PRDATA,
  input logic        PSLVERR
);

  // 1. Reset Property: During reset, PSEL and PENABLE must be low
  property p_reset_state;
    @(posedge PCLK) !PRESETn |-> (!PSEL && !PENABLE);
  endproperty
  assert_reset_state: assert property (p_reset_state) 
    else $error("SVA_ERR: PSEL or PENABLE active during reset!");

  // 2. Setup Phase: PENABLE must be low when PSEL is first asserted
  property p_psel_before_penable;
    @(posedge PCLK) disable iff (!PRESETn)
    $rose(PSEL) |-> !PENABLE;
  endproperty
  assert_psel_before_penable: assert property (p_psel_before_penable) 
    else $error("SVA_ERR: PENABLE asserted too early in Setup Phase!");

  // 3. Access Phase: PENABLE must be asserted one cycle after PSEL is asserted
  property p_penable_after_psel;
    @(posedge PCLK) disable iff (!PRESETn)
    (PSEL && !PENABLE) |=> PENABLE;
  endproperty
  assert_penable_after_psel: assert property (p_penable_after_psel) 
    else $error("SVA_ERR: PENABLE not asserted one cycle after PSEL!");

  // 4. Address Stability: PADDR must remain stable throughout the entire transfer
  property p_paddr_stable;
    @(posedge PCLK) disable iff (!PRESETn)
    (PSEL && !PREADY) |=> $stable(PADDR);
  endproperty
  assert_paddr_stable: assert property (p_paddr_stable) 
    else $error("SVA_ERR: PADDR changed during active transfer!");

  // 5. Write Data Stability: PWDATA must remain stable throughout a write transfer
  property p_pwdata_stable;
    @(posedge PCLK) disable iff (!PRESETn)
    (PSEL && PWRITE && !PREADY) |=> $stable(PWDATA);
  endproperty
  assert_pwdata_stable: assert property (p_pwdata_stable) 
    else $error("SVA_ERR: PWDATA changed during active write transfer!");

  // 6. Control Signals Stability: PWRITE and PSEL must remain stable during the access phase
  property p_ctrl_stable;
    @(posedge PCLK) disable iff (!PRESETn)
    (PSEL && PENABLE && !PREADY) |=> ($stable(PSEL) && $stable(PWRITE));
  endproperty
  assert_ctrl_stable: assert property (p_ctrl_stable) 
    else $error("SVA_ERR: PSEL or PWRITE changed during active transfer!");

  // Cover properties for key scenarios
  cover_write_transfer: cover property (@(posedge PCLK) disable iff (!PRESETn) PSEL && PENABLE && PWRITE && PREADY);
  cover_read_transfer:  cover property (@(posedge PCLK) disable iff (!PRESETn) PSEL && PENABLE && !PWRITE && PREADY);
  cover_wait_states:    cover property (@(posedge PCLK) disable iff (!PRESETn) PSEL && PENABLE && !PREADY);
  cover_error_response: cover property (@(posedge PCLK) disable iff (!PRESETn) PSEL && PENABLE && PREADY && PSLVERR);

endmodule

// Bind statement to attach SVA to the RTL module
bind apb_slave apb_assertions u_apb_assertions (
  .PCLK(PCLK),
  .PRESETn(PRESETn),
  .PADDR(PADDR),
  .PSEL(PSEL),
  .PENABLE(PENABLE),
  .PWRITE(PWRITE),
  .PWDATA(PWDATA),
  .PREADY(PREADY),
  .PRDATA(PRDATA),
  .PSLVERR(PSLVERR)
);