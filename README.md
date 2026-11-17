# RISC-V Single-Cycle CPU

A 32-bit single-cycle RISC-V processor implemented in SystemVerilog and simulated using Verilator. The current implementation supports the R-type `ADD` and `SUB` instructions.

## Project Overview

This project brings together the main datapath components of a simple RISC-V processor:

- Program Counter (PC)
- Instruction Memory
- R-type Instruction Decoder
- 32 × 32-bit Register File
- Arithmetic Logic Unit (ALU)
- Register write-back path

The processor fetches an instruction, decodes its fields, reads the source registers, performs the selected ALU operation, and writes the result to the destination register.

## Architecture

```text
                 +----------------------+
                 |   Program Counter    |
                 +----------+-----------+
                            |
                            v
                 +----------------------+
                 |  Instruction Memory  |
                 +----------+-----------+
                            |
                            v
                 +----------------------+
                 | Instruction Decoder |
                 +----------+-----------+
                            |
                    rs1, rs2, rd,
                    alu_op, controls
                            |
                            v
                 +----------------------+
                 |     Register File    |
                 |   32 x 32-bit regs   |
                 +----------+-----------+
                            |
                       rs1_data
                       rs2_data
                            |
                            v
                 +----------------------+
                 |         ALU          |
                 |       ADD / SUB      |
                 +----------+-----------+
                            |
                        alu_result
                            |
                            v
                 +----------------------+
                 |    Register Write    |
                 |       Back           |
                 +----------------------+
```

## Current Features

- 32-bit datapath.
- 32 registers, each 32 bits wide.
- Two register read ports and one synchronous write port.
- Register `x0` is protected and always reads as zero.
- 16-entry instruction memory, with 32-bit instructions.
- Program Counter advances by 4 bytes per instruction.
- R-type instruction decoding for `ADD` and `SUB`.
- ALU supports addition and subtraction.
- Testbench executes five `ADD` instructions followed by five `SUB` instructions.
- Debug outputs expose the PC, instruction, register addresses, ALU result, and control signals.

## Supported Instructions

| Instruction | Opcode | funct3 | funct7 | ALU operation |
|---|---|---|---|---|
| `ADD rd, rs1, rs2` | `0110011` | `000` | `0000000` | Add |
| `SUB rd, rs1, rs2` | `0110011` | `000` | `0100000` | Subtract |

## Technology Stack

- **HDL:** SystemVerilog
- **Simulator and compiler:** Verilator 5.x
- **Environment:** Ubuntu / WSL
- **Waveform viewer:** GTKWave

## Repository Contents

| File | Description |
|---|---|
| `cit_alu.sv` | Parameterized ALU; current CPU uses 32-bit ADD and SUB |
| `register_file_32x32.sv` | 32 × 32-bit register file |
| `instruction_memory.sv` | 16-entry instruction memory and R-type instruction initialization |
| `instruction_decoder.sv` | R-type ADD/SUB instruction decoder |
| `program_counter.sv` | 32-bit PC register, incremented by 4 |
| `r_type_cpu.sv` | Top-level CPU integration module |
| `r_type_cpu_tb.sv` | Complete CPU testbench |
| `register_file_tb.sv` | Register-file testbench |
| `instruction_memory_tb.sv` | Instruction-memory testbench |
| `instruction_decoder_tb.sv` | Decoder testbench |
| `program_counter_tb.sv` | Program-counter testbench |
| `RUNNING.md` | Detailed build and simulation commands |

## Quick Start

### Requirements

Install Verilator on Ubuntu if it is not already installed. Check the installed version:

```bash
verilator --version
```

### Clone the repository

```bash
git clone https://github.com/jothamkev-lgtm/RISC-V-Single-Cycle-CPU.git
cd RISC-V-Single-Cycle-CPU
```

Access to this repository is private and must be granted by the repository owner.

### Compile the complete CPU

```bash
verilator --binary --timing --Wall -Wno-UNUSEDSIGNAL \
  --top-module r_type_cpu_tb \
  cit_alu.sv \
  register_file_32x32.sv \
  instruction_memory.sv \
  instruction_decoder.sv \
  program_counter.sv \
  r_type_cpu.sv \
  r_type_cpu_tb.sv
```

### Run the simulation

```bash
./obj_dir/Vr_type_cpu_tb
```

For individual module testbench commands and further details, see [RUNNING.md](RUNNING.md).

## Verification

The complete CPU testbench initializes:

- `x1 = 10`
- `x2 = 3`

It then executes five `ADD` instructions followed by five `SUB` instructions.

Expected final register values from the current program:

| Register | Expected value |
|---|---:|
| `x0` | 0 |
| `x1` | 10 |
| `x2` | 3 |
| `x3` | 29 |
| `x4` | 26 |
| `x5` | 16 |
| `x6` | 13 |
| `x7` | 3 |

The CPU simulation has been run successfully with Verilator. The waveform can also be inspected using GTKWave after generating a VCD file from the testbench.

## Current Project Scope

This is an educational, R-type-only single-cycle CPU implementation. It currently supports `ADD` and `SUB`; it does not yet implement the full RV32I instruction set, branches, loads, stores, or a pipelined datapath.

## Author

**Jotham Kevin J**  
B.E. – VLSI Design & Technology  
Chennai Institute of Technology

---

For build instructions, refer to [RUNNING.md](RUNNING.md).
