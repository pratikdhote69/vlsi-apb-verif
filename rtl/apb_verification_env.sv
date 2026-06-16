`timescale 1ns/1ps
module apb_verification_env (
    input  pclk,
    input  presetn,
    input  [31:0] paddr,
    input  pwrite,
    input  psel,
    input  penable,
    output [31:0] paddr_out,
    output pwrite_out,
    output psel_out,
    output penable_out
);
    // Internal signal declarations
    reg [31:0] addr_reg;
    reg write_reg;
    reg sel_reg;
    reg enable_reg;

    // Always blocks
    always @(posedge pclk) begin
        // Handle setup phase
        if (psel && penable) begin
            addr_reg <= paddr;
            write_reg <= pwrite;
            sel_reg <= psel;
            enable_reg <= penable;
        end
        // Handle access phase
        else if (psel && !penable) begin
            addr_reg <= addr_reg; // This is just to make the compiler happy, it will be overwritten by the assign statement below.
            write_reg <= write_reg; 
            sel_reg <= sel_reg; 
            enable_reg <= enable_reg; 
        end
    end

    // Assign outputs
    assign paddr_out = addr_reg;
    assign pwrite_out = write_reg;
    assign psel_out = sel_reg;
    assign penable_out = enable_reg;
endmodule