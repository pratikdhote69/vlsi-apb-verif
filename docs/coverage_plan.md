# Functional Coverage Plan - APB3 Slave Verification

## 1. Functional Coverage Points

| Coverage Point ID | Description | Target Bins | Goal (%) |
|:---|:---|:---|:---:|
| **CP_ADDR** | Verifies accesses to all valid registers and invalid address space. | `REG_0` (0x0), `REG_1` (0x4), `REG_2` (0x8), `REG_3` (0xC), `INVALID` | 100% |
| **CP_WRITE** | Verifies both Read and Write operations. | `WRITE` (1), `READ` (0) | 100% |
| **CP_ERROR** | Verifies error response generation. | `NO_ERROR` (0), `ERROR` (1) | 100% |
| **CROSS_ADDR_WRITE** | Cross coverage of Address and Write/Read operations to ensure all registers are both read and written. | All combinations of valid/invalid addresses and read/write. | 100% |

---

## 2. Covergroup Definition (SystemVerilog Syntax)

```systemverilog
covergroup apb_functional_cov @(posedge PCLK);
  option.per_instance = 1;
  option.goal = 100;

  // Coverpoint for Address Space
  cp_addr: coverpoint PADDR {
    bins reg_0   = {32'h0};
    bins reg_1   = {32'h4};
    bins reg_2   = {32'h8};
    bins reg_3   = {32'hC};
    bins invalid = default;
  }

  // Coverpoint for Read/Write Command
  cp_write: coverpoint PWRITE {
    bins read  = {1'b0};
    bins write = {1'b1};
  }

  // Coverpoint for Error Response
  cp_error: coverpoint PSLVERR {
    bins no_error = {1'b0};
    bins error    = {1'b1};
  }

  // Cross Coverage to ensure every register is read and written
  cross_addr_write: cross cp_addr, cp_write {
    // Exclude write to REG_3 (Read-Only) from 100% coverage target if desired,
    // or keep it to verify write attempts are ignored.
    ignore_bins read_invalid = binsof(cp_addr.invalid) && binsof(cp_write.read);
  }
endgroup
```

---

## 3. Corner Cases to Cover
1. **Wait-State Handshake:** Accessing `REG_2` (0x08) and ensuring `PREADY` is pulled low for exactly 2 cycles before completing the transfer.
2. **Read-Only Register Write:** Attempting to write to `REG_3` (0x0C) and verifying that the internal register value remains `0xDEADBEEF` on a subsequent read.
3. **Out-of-Bounds Access:** Accessing address `0x100` and verifying that `PSLVERR` is asserted.