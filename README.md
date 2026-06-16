# APB Verification Environment

![CI Status](https://github.com/pratikdhote69/vlsi-apb-verif/actions/workflows/ci.yml/badge.svg)

## Project Description
The APB verification environment is a set of modules designed to verify the functionality of an APB slave module.

## Directory Structure
- `apb_slave.sv`: The APB slave module.
- `apb_driver.sv`: The APB driver module.
- `apb_monitor.sv`: The APB monitor module.
- `apb_scoreboard.sv`: The APB scoreboard module.
- `apb_tb.sv`: The top-level testbench module.
- `apb_sva.sv`: The SystemVerilog Assertions file.
- `apb_coverage_plan.md`: The coverage plan file.
- `README.md`: This file.

## How to Run Simulation
To run the simulation, use the following Icarus Verilog command:
```bash
iverilog -o apb_tb apb_tb.sv apb_slave.sv apb_driver.sv apb_monitor.sv apb_scoreboard.sv
```
Then, run the resulting executable:
```bash
./apb_tb
```
## Expected Output
The simulation will output the following:
```
APB transaction:
  Address: 1000
  Write: 1
  Write data: dead
  Read data: dead
  Ready: 1
  Error: 0
APB scoreboard:
  Expected data: dead
  Actual data: dead
  PASS
```
## Author and Date
This project was created by [Your Name] on [Today's Date].