# AutoCircuit MCP examples

Verilog designs for trying [AutoCircuit MCP](https://autocircuit.aamirakbar.com) from an AI app:
Claude Code, OpenAI Codex, Gemini CLI or OpenCode. You ask in plain words, and your app sends a
design to the server. The server checks it, or runs the GA ECO workflow on it: OpenLane synthesis
with the sky130A PDK, then six flows, each scored by OpenROAD on area, timing, power and slew.
The six are the baseline, OpenROAD `repair_design`, and four genetic-algorithm (GA) flows, for
timing, power, area and balance.

## Set up

1. Ask the AutoCircuit team to approve your email address. You sign in with a code sent to it.
2. Add the server to your app and sign in, following the steps for your app at
   [autocircuit.aamirakbar.com](https://autocircuit.aamirakbar.com). The server's address is
   `https://autocircuit.aamirakbar.com/mcp`.
3. Clone this repository, and start your app in its folder, so the app can read the designs.

## The examples

| Example | File | Top module | Size, roughly |
| --- | --- | --- | --- |
| UART | `Examples/uart/uart.v` | `uart` | 360 cells |
| 32-bit barrel shifter | `Examples/barrel_shifter/barrel_shifter.v` | `barrel_shifter` | 300 cells |
| 16 × 16-bit multiplier | `Examples/multiplier/individual_clk.v` | `individual_clk` | 1,100 cells |
| PicoRV32 RISC-V CPU | `Examples/riscv/picorv32.v` | `picorv32` | 7,800 cells |
| AES block cipher | the seven files in `Examples/aes/` | `aes` | 18,000 cells |
| FIFO, 512 × 32 bits | `Examples/fifo/fifo.v` | `fifo` | 39,000 cells |

Sizes are `sky130_fd_sc_hd` cells after synthesis. Each top module has the `clk` input the
workflow needs. Start with the UART: it has reference results to compare with (below).

## Run one

Ask your app, for example:

1. *"Check Examples/uart/uart.v with autocircuit."* The server checks the file
   (`submit_design_file`).
2. *"Run a GA job on Examples/uart/uart.v, top module uart."* The server starts a job and returns
   its ID at once (`start_ga_job`).
3. Hours later: *"Has my GA job finished? Show me its report."* (`get_ga_job`)
4. *"Save flow 4's netlist as uart_power.v."* Your app downloads it (`get_ga_job_files`).

In Claude Code, typing `@Examples/uart/uart.v` attaches the file to your request.

Good to know:

- **One file per job.** Combine the AES files first, then run the job on the result, with top
  module `aes`:

  ```bash
  cat Examples/aes/*.v > aes_all.v
  ```

- **The clock.** The workflow measures the design's critical path and adds 10% to set the clock
  period, unless you give one: *"…, clock 10 ns"*. An input named `reset` is left out of timing;
  designs with another reset name, or none, run as they are.
- **Your own constraints.** You may add an SDC file. Give a clock period with it.
- **Time.** A job takes hours: about four for the UART, and longer for bigger designs. Jobs share
  one server, so cancel the ones you no longer need (`cancel_ga_job`).
- **Your jobs are yours.** Only you see them, and they are deleted after 30 days.
  *"List my GA jobs."* finds them again (`list_ga_jobs`).

## The UART's reference results

With the clock period left to the workflow, a UART job's report has these lines, between its
ruled lines:

```text
  FINAL ECO REPORT (6 FLOWS) - Clock: 2.95 ns
Flow                   | Area (um^2)   | WNS (ns)   | Power (mW)   | Slew (ns)  | LEC
1. Baseline            | 3904.00       | 0.27       | 1.490        | 0.49       | N/A
2. Repair ECO          | 3610.00       | 0.61       | 1.400        | 0.20       | ✅
```

Flows 3 to 6, the GA's, differ a little from one job to the next.

## Sources

- `Examples/aes/`: Joachim Strömbergson's AES core, © 2013–2014 Secworks Sweden AB, under the
  BSD-style licence in each file's header.
- `Examples/riscv/picorv32/`: [PicoRV32](https://github.com/YosysHQ/picorv32) by Claire Xenia
  Wolf, under the ISC licence in its `COPYING`, with its tests and firmware.
  `Examples/riscv/picorv32.v` is a copy of its `picorv32.v`, the one file a GA job needs.
