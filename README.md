
# Asynchronous FIFO

## Overview
This repository contains a synthesizable asynchronous FIFO implementation designed for safe data transfer between independent clock domains. The design follows CDC techniques using Gray-coded pointers and multi-stage synchronizers to ensure reliable full and empty detection across clock boundaries.
## Typical Asynchronous FIFO Block Diagram
![Block_diagram](./doc/async_fifo_typ_block_diagram.png)
## Interface
**Key signals**
- **Write domain**: `wclk`, `wrst_n`, `wen`, `wdata`, `wfull`
- **Read domain**: `rclk`, `rrst_n`, `ren`, `rdata`, `rempty`
## Clocks / Resets
- Independent write (`wclk`) and read (`rclk`) clocks.
- Active-low asynchronous resets (`wrst_n`, `rrst_n`) per clock domain.
## Implementation
### Functional Description
#### Write Interface
- When `wen` is asserted and `wfull` is deasserted, `wdata` is captured on the rising edge of `wclk` and written into FIFO memory.
- Each successful write advances the write pointer.
- When the FIFO reaches maximum capacity, `wfull` is asserted to block further writes.
- Writes attempted while `wfull` is asserted are safely ignored.
#### Read Interface
- When `ren` is asserted and `rempty` is deasserted, data is read from FIFO memory and driven on `rdata` on the rising edge of `rclk`.
- Each successful read advances the read pointer.
- When no valid data is available, `rempty` is asserted.
- Reads attempted while `rempty` is asserted do not advance the read pointer, and `rdata` holds the last valid value.
#### Full and Empty Generation
- Independent read and write pointers are extended with an extra MSB to differentiate full and empty states.
- `rempty` is asserted when the local read pointer equals the synchronized write pointer (including MSB).
- `wfull` is asserted when the lower address bits of the local write pointer match the synchronized read pointer and the MSBs differ.

#### Clock Domain Crossing
- Read and write pointers are converted to Gray code before crossing clock domains.
- Pointers are synchronized using two-stage flip-flop synchronizers.
- Full and empty flags are generated using synchronized Gray-coded pointers.
## Submodules
- `custom_sram_1r1w_32_256_freepdk45` – Dual-port FIFO memory. Compiled using OpenRAM.
- `sync_2stage` – Two-flip-flop CDC synchronizer
- `wptr_control` – Write pointer and full-flag logic
- `rptr_control` – Read pointer and empty-flag logic
## Synthesis
The asynchronous FIFO was synthesized using a multi-corner setup (SS, TT, FF) with the FreePDK45 / NanGate 45nm open cell library. 

The FIFO memory is implemented using a 1R1W SRAM macro generated with the OpenRAM tool. The write clock (`wclk`) was constrained to 300 MHz (3.33 ns), while the read clock (`rclk`) was constrained to 175 MHz (5.71 ns).

Timing was achieved across all process corners. The worst-case slack was observed at the SS corner, with a value of 953ps, providing margin for post-synthesis processes.
### Process Corners
| Corner  | Process | Voltage | Temperature |
| ------- | ------- | ------- | ----------- |
| Slow    | SS      | 0.95V   | 125°C       |
| Typical | TT      | 1.1V    | 25°C        |
| Fast    | FF      | 1.25    | 0°C         |
### Timing and Area Summary
| Corner  | Critical Path Slack (ps) | TNS (ps) | Cell Area | Leaf Instances |
| ------- | ------------------------ | -------- | --------- | -------------- |
| Slow    | 953                      | 0        | 40,445    | 205            |
| Typical | 1,356                    | 0        | 40,445    | 205            |
| Fast    | 1,516                    | 0        | 40,445    | 205            |
The design met the timing requirements set with zero total negative slack, achieving a cell area of 40,445.