# APB3 Slave and Verification Environment Design Specification

## 1. Module Description
This project implements a fully compliant **AMBA APB3 Slave** design along with a complete, lightweight, non-UVM SystemVerilog verification environment. 

The APB3 Slave (`apb_slave`) contains four internal 32-bit registers with varying access behaviors:
- **`REG_0` (Address `0x00`):** Read/Write register.
- **`REG_1` (Address `0x04`):** Read/Write register.
- **`REG_2` (Address `0x08`):** Read/Write register with **2 wait states** (simulated using `PREADY` deassertion) to verify wait-state handling.
- **`REG_3` (Address `0x0C`):** Read-Only register hardcoded to `32'hDEADBEEF`. Writes to this register are ignored.
- **Invalid Addresses:** Any access to addresses other than the four listed above will trigger a slave error response (`PSLVERR` = 1).

The verification environment consists of a modular, transaction-based testbench containing a driver, monitor, scoreboard, interface, and SystemVerilog Assertions (SVA) to ensure complete protocol compliance.

---

## 2. Port List

### `apb_slave` Port Definitions
| Port Name | Direction | Width | Description |
|:---|:---:|:---:|:---|
| `PCLK` | Input | 1 | APB Bus Clock |
| `PRESETn` | Input | 1 | APB Bus Reset (Active Low) |
| `PADDR` | Input | 32 | APB Address Bus |
| `PSEL` | Input | 1 | APB Peripheral Select |
| `PENABLE` | Input | 1 | APB Enable (Strobe) |
| `PWRITE` | Input | 1 | APB Write/Read Control (1 = Write, 0 = Read) |
| `PWDATA` | Input | 32 | APB Write Data Bus |
| `PREADY` | Output | 1 | APB Ready (Wait-state control) |
| `PRDATA` | Output | 32 | APB Read Data Bus |
| `PSLVERR` | Output | 1 | APB Slave Error Response |

---

## 3. Functional Description
The APB3 protocol operates in three states: **IDLE**, **SETUP**, and **ACCESS**.
1. **IDLE:** Default state. No transfer is occurring.
2. **SETUP:** Triggered when `PSEL` is asserted. `PENABLE` must remain low. The address and control signals must remain stable.
3. **ACCESS:** Triggered on the next clock edge when `PENABLE` is asserted. The transfer completes when `PREADY` is sampled high at the rising edge of `PCLK`.

### Wait-State Generator
To thoroughly test the driver and monitor's ability to handle wait states, accesses to `REG_2` (Address `0x08`) trigger a 2-cycle wait state. During these cycles, `PREADY` is driven low, forcing the master to hold all address, control, and data signals stable.

### Error Handling
Any access to an address outside the valid range (`0x00`, `0x04`, `0x08`, `0x0C`) causes the slave to assert `PSLVERR` during the ACCESS phase.

---

## 4. Timing Diagram (ASCII)

### Write Transfer with 2 Wait States (Access to `REG_2` at `0x08`)
```text
             __    __    __    __    __    __
PCLK      __/  \__/  \__/  \__/  \__/  \__/  \__
          ______________________________________
PRESETn     \___________________________________
                ______
PADDR     XXXXX/_0x08_\_________________________
                ______
PWDATA    XXXXX/_DATA_\_________________________
                ________________________________
PWRITE    _____/
                ________________________________
PSEL      _____/
                      __________________________
PENABLE   ___________/
                                    ____________
PREADY    _________________________/
```

---

## 5. File Breakdown
The project is structured into modular, single-responsibility files:
1. **`apb_slave.sv`:** Synthesizable APB3 Slave RTL.
2. **`apb_pkg.sv`:** SystemVerilog package containing transaction structures and common definitions.
3. **`apb_if.sv`:** SystemVerilog Interface encapsulating APB signals and modports.
4. **`apb_driver.sv`:** Lightweight driver driving transactions onto the interface.
5. **`apb_monitor.sv`:** Passive monitor capturing bus transactions.
6. **`apb_scoreboard.sv`:** Self-checking scoreboard comparing actual vs. expected results.
7. **`apb_assertions.sv`:** SystemVerilog Assertions (SVA) verifying protocol compliance.
8. **`apb_tb.sv`:** Top-level testbench instantiating all components and running test cases.

---

## 6. Key Design Decisions
- **Strict Separation of Concerns:** Driver, monitor, and scoreboard are implemented in separate files to mimic a professional UVM structure while remaining compatible with lightweight simulators like Icarus Verilog.
- **Interface-Based Design:** Using SystemVerilog interfaces ensures clean signal routing and avoids messy port connections in the testbench.
- **Wait-State Injection:** Hardcoding wait states on a specific register address ensures deterministic testing of the `PREADY` handshake without requiring complex randomized wait-state injection in the RTL.