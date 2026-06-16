`timescale 1ns/1ps

module apb_slave #(
  parameter int ADDR_WIDTH = 32,
  parameter int DATA_WIDTH = 32
) (
  input  logic                    PCLK,
  input  logic                    PRESETn,
  input  logic [ADDR_WIDTH-1:0]   PADDR,
  input  logic                    PSEL,
  input  logic                    PENABLE,
  input  logic                    PWRITE,
  input  logic [DATA_WIDTH-1:0]   PWDATA,
  output logic                    PREADY,
  output logic [DATA_WIDTH-1:0]   PRDATA,
  output logic                    PSLVERR
);

  // Internal Registers
  logic [DATA_WIDTH-1:0] reg_0;
  logic [DATA_WIDTH-1:0] reg_1;
  logic [DATA_WIDTH-1:0] reg_2;
  logic [DATA_WIDTH-1:0] reg_3; // Read-only register

  // Wait state counter
  logic [1:0] wait_cnt;
  logic       is_wait_addr;

  // Address decoding for wait states (REG_2 at 0x08 has wait states)
  assign is_wait_addr = (PADDR == 32'h8);

  // APB Register Write and Wait State Logic
  always_ff @(posedge PCLK or negedge PRESETn) begin
    if (!PRESETn) begin
      reg_0    <= 32'h0;
      reg_1    <= 32'h0;
      reg_2    <= 32'h0;
      reg_3    <= 32'hDEADBEEF; // Hardcoded Read-Only value
      wait_cnt <= 2'b0;
    end else begin
      if (PSEL && !PENABLE) begin
        // Setup Phase: Initialize wait counter if accessing wait-state address
        if (is_wait_addr) begin
          wait_cnt <= 2'd2;
        end else begin
          wait_cnt <= 2'd0;
        end
      end else if (PSEL && PENABLE) begin
        // Access Phase
        if (wait_cnt > 2'd0) begin
          wait_cnt <= wait_cnt - 1'b1;
        end else begin
          // Perform Write when PREADY is high
          if (PWRITE) begin
            case (PADDR)
              32'h0: reg_0 <= PWDATA;
              32'h4: reg_1 <= PWDATA;
              32'h8: reg_2 <= PWDATA;
              default: ; // Ignore writes to read-only or invalid addresses
            endcase
          end
        end
      end
    end
  end

  // PREADY Generation
  always_comb begin
    if (PSEL && PENABLE) begin
      if (is_wait_addr && (wait_cnt > 2'd0)) begin
        PREADY = 1'b0; // Hold master during wait states
      end else begin
        PREADY = 1'b1;
      end
    end else begin
      PREADY = 1'b1; // Default high when idle
    end
  end

  // PRDATA Generation
  always_comb begin
    PRDATA = {DATA_WIDTH{1'b0}};
    if (PSEL && !PWRITE) begin
      case (PADDR)
        32'h0: PRDATA = reg_0;
        32'h4: PRDATA = reg_1;
        32'h8: PRDATA = reg_2;
        32'hC: PRDATA = reg_3;
        default: PRDATA = {DATA_WIDTH{1'b0}};
      endcase
    end
  end

  // PSLVERR Generation (Asserted for invalid addresses)
  always_comb begin
    if (PSEL) begin
      if (PADDR != 32'h0 && PADDR != 32'h4 && PADDR != 32'h8 && PADDR != 32'hC) begin
        PSLVERR = 1'b1;
      end else begin
        PSLVERR = 1'b0;
      end
    end else begin
      PSLVERR = 1'b0;
    end
  end

endmodule