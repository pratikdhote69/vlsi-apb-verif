# APB3 Slave Verification Environment

![CI Status](https://github.com/pratikdhote69/vlsi-apb-verif/actions/workflows/ci.yml/badge.svg)


This project contains a production-ready, synthesizable **AMBA APB3 Slave** RTL design and a complete, lightweight, non-UVM SystemVerilog verification environment.

## Directory Structure
```text
├── apb_slave.sv        # Synthesizable APB3 Slave RTL
├── apb_pkg.sv          # SystemVerilog Package containing transaction structures
├── apb_if.sv           # SystemVerilog Interface encapsulating APB signals
├── apb_driver.sv       # Lightweight non-UVM Driver
├── apb_monitor.sv      # Passive Monitor capturing transactions
├── apb_scoreboard.sv   # Self-checking Scoreboard
├── apb_assertions.sv   # SystemVerilog Assertions (SVA) for protocol compliance
├── apb_tb.sv           # Top-level Testbench
└── README.md           # Documentation (this file)
```

---

## How to Run Simulation

You can compile and run this simulation using **Icarus Verilog** (v11 or newer recommended for SystemVerilog support) or any standard SystemVerilog simulator (such as Questa, VCS, or Xcelium).

### Compilation and Execution with Icarus Verilog:
```bash
# Create a simulation directory
mkdir -p sim

# Compile all files in the correct dependency order
iverilog -g2012 -o sim/apb_sim.vvp \
  apb_pkg.sv \
  apb_if.sv \
  apb_slave.sv \
  apb_driver.sv \
  apb_monitor.sv \
  apb_scoreboard.sv \
  apb_assertions.sv \
  apb_tb.sv

# Run the simulation
vvp sim/apb_sim.vvp
```

---

## Expected Output
When run, the simulation will output detailed transaction logs from the monitor and verification checks from the scoreboard:

```text
Starting APB Verification Testbench...

--- TEST CASE 1: Read Read-Only Register (0xC) ---
[MON] 75000: Captured READ Access - Addr: 0x0000000c, Data: 0xdeadbeef, Error: 0
[SB] 75000: PASS: Read Data match! Addr: 0x0000000c, Data: 0xdeadbeef
[SB] 75000: PASS: Read Error check passed for Addr: 0x0000000c

--- TEST CASE 2: Write/Read to REG_0 (0x0) ---
[MON] 115000: Captured WRITE Access - Addr: 0x00000000, Data: 0xaaaa5555, Error: 0
[SB] 115000: Mirror updated - Addr: 0x00000000, Data: 0xaaaa5555
[SB] 115000: PASS: Write Error check passed for Addr: 0x00000000
[MON] 145000: Captured READ Access - Addr: 0x00000000, Data: 0xaaaa5555, Error: 0
[SB] 145000: PASS: Read Data match! Addr: 0x00000000, Data: 0xaaaa5555
[SB] 145000: PASS: Read Error check passed for Addr: 0x00000000

...

All test cases completed. Simulation finished successfully.
```

---
**Author:** Principal VLSI Design Verification Engineer  
**Date:** October 2023