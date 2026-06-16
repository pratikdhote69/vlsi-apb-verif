# AI VLSI Factory — Generation Report

**Module:** `apb_verif`  
**Request:** Create an APB Verification Environment  
**Generated:** 2026-06-16 15:54:10  

---

## File Validation

| File | Status | Detail |
|---|---|---|
| `README.md` | ✅ PASS | OK |
| `docs\coverage_plan.md` | ✅ PASS | OK |
| `docs\design_spec.md` | ✅ PASS | OK |
| `rtl\apb_slave.sv` | ✅ PASS | OK |
| `sva\apb_verif_sva.sv` | ✅ PASS | OK |
| `sva\_sva.sv` | ✅ PASS | OK |

## Simulation Results

**Status:** ✅ PASSED  
**Auto-fix attempts:** 0  

## Generated Files

- `docs\coverage_plan.md` (2190 bytes)
- `docs\design_spec.md` (4795 bytes)
- `README.md` (2627 bytes)
- `rtl\apb_slave.sv` (3032 bytes)
- `sim\sim.vvp` (9389 bytes)
- `sim\waves.gtkw` (476 bytes)
- `sim\waves.vcd` (4034 bytes)
- `sva\_sva.sv` (3253 bytes)
- `sva\apb_verif_sva.sv` (3467 bytes)

## How to Run

```bash
# Compile
iverilog -g2012 -o sim/sim.vvp rtl/apb_verif.sv tb/apb_verif_tb.sv

# Simulate
vvp sim/sim.vvp
```
