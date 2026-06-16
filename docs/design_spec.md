# APB Verification Environment Design Specification
## Module Name and Description
The APB (Advanced Peripheral Bus) verification environment consists of several modules:
- `apb_slave`: The Design Under Test (DUT), an APB slave module.
- `apb_driver`: A lightweight, non-UVM driver that drives stimulus into the DUT.
- `apb_monitor`: A lightweight, non-UVM monitor that observes DUT signals and reports transactions.
- `apb_scoreboard`: A lightweight, non-UVM scoreboard that compares expected vs actual results.

## Port List
The `apb_slave` module has the following ports:
- `clk` (input, 1-bit): The clock signal.
- `rst_n` (input, 1-bit): The active-low reset signal.
- `psel` (input, 1-bit): The select signal.
- `penable` (input, 1-bit): The enable signal.
- `paddr` (input, 32-bit): The address signal.
- `pwrite` (input, 1-bit): The write signal.
- `pwdata` (input, 32-bit): The write data signal.
- `prdata` (output, 32-bit): The read data signal.
- `pready` (output, 1-bit): The ready signal.
- `perr` (output, 1-bit): The error signal.

## Functional Description
The APB slave module responds to APB transactions. When selected (`psel` is high), it checks the address and responds accordingly.

## Timing Diagram
```
          +---------------+
          |         clk  |
          +---------------+
                  _________
                 /         \
                /           \
               /             \
              /               \
             /                 \
            /                   \
           /                     \
          /                       \
         /                         \
        /                           \
       /                             \
      /                               \
     /                                 \
    /                                   \
   |                 psel          |
   |  _______       _______     |
   | /       \     /       \   |
   |/         \   |/         \  |
   |  paddr    |   |  paddr    | 
   |  _______  |   |  _______  | 
   |/         \|   |/         \|
   |  pwrite   |   |  pwrite   |
   |  _______  |   |  _______  |
   |/         \|   |/         \|
   |  pwdata   |   |  pwdata   |
   |  _______  |   |  _______  |
   |  prdata   |   |  prdata   |
   |  _______  |   |  _______  |
   |  pready   |   |  pready   |
   |  _______  |   |  _______  |
   |  perr     |   |  perr     |
   +---------------+---------------+
```

## State Machine Description
The APB slave module has two states:
- `IDLE`: The module is not selected.
- `SELECTED`: The module is selected and checking the address.

## File Breakdown
- `apb_slave.sv`: The APB slave module.
- `apb_driver.sv`: The APB driver module.
- `apb_monitor.sv`: The APB monitor module.
- `apb_scoreboard.sv`: The APB scoreboard module.
- `apb_tb.sv`: The top-level testbench module.
- `apb_sva.sv`: The SystemVerilog Assertions file.
- `apb_coverage_plan.md`: The coverage plan file.
- `README.md`: The project README file.

## Key Design Decisions
- The APB slave module is designed to respond to APB transactions.
- The APB driver module is designed to drive stimulus into the DUT.
- The APB monitor module is designed to observe DUT signals and report transactions.
- The APB scoreboard module is designed to compare expected vs actual results.