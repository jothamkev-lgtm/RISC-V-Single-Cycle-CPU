# Running the RISC-V Single-Cycle CPU

This project implements a 32-bit, single-cycle RISC-V processor supporting R-type `ADD` and `SUB` instructions.

## Requirements

- Ubuntu (including Ubuntu under WSL)
- Verilator 5.x
- Git

Check Verilator:

```bash
verilator --version
```

## 1. Clone the repository

If you have access to the private GitHub repository:

```bash
git clone https://github.com/jothamkev-lgtm/RISC-V-Single-Cycle-CPU.git
cd RISC-V-Single-Cycle-CPU
```

If the project is already on your computer, enter its directory instead:

```bash
cd ~/riscv_cpu
```

## 2. Run the complete CPU

Compile the RTL modules with the CPU testbench:

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

Run the simulation:

```bash
./obj_dir/Vr_type_cpu_tb
```

The testbench initializes `x1 = 10` and `x2 = 3`, then executes five `ADD` instructions followed by five `SUB` instructions.

Expected final register values:

| Register | Expected value |
|---|---:|
| x0 | 0 |
| x1 | 10 |
| x2 | 3 |
| x3 | 29 |
| x4 | 26 |
| x5 | 16 |
| x6 | 13 |
| x7 | 3 |

## 3. Run individual module testbenches

Compile and run each testbench separately. Verilator creates or updates the `obj_dir/` build directory.

### Register file

```bash
verilator --binary --timing --Wall \
  --top-module register_file_tb \
  register_file_32x32.sv \
  register_file_tb.sv

./obj_dir/Vregister_file_tb
```

### Instruction memory

```bash
verilator --binary --timing --Wall \
  --top-module instruction_memory_tb \
  instruction_memory.sv \
  instruction_memory_tb.sv

./obj_dir/Vinstruction_memory_tb
```

### Instruction decoder

```bash
verilator --binary --timing --Wall \
  --top-module instruction_decoder_tb \
  instruction_decoder.sv \
  instruction_decoder_tb.sv

./obj_dir/Vinstruction_decoder_tb
```

### Program counter

```bash
verilator --binary --timing --Wall \
  --top-module program_counter_tb \
  program_counter.sv \
  program_counter_tb.sv

./obj_dir/Vprogram_counter_tb
```

### ALU

The current project file list includes `cit_alu.sv`, but no standalone ALU testbench. The ALU is exercised by the complete CPU testbench.

## 4. Project source files

| File | Purpose |
|---|---|
| `cit_alu.sv` | 32-bit ALU supporting ADD and SUB |
| `register_file_32x32.sv` | 32 registers, each 32 bits wide |
| `instruction_memory.sv` | 16-entry instruction memory |
| `instruction_decoder.sv` | Decodes supported R-type ADD and SUB instructions |
| `program_counter.sv` | PC register; advances by 4 bytes |
| `r_type_cpu.sv` | Integrates the CPU datapath and control connections |
| `r_type_cpu_tb.sv` | Testbench for the complete CPU |
| `register_file_tb.sv` | Register-file testbench |
| `instruction_memory_tb.sv` | Instruction-memory testbench |
| `instruction_decoder_tb.sv` | Decoder testbench |
| `program_counter_tb.sv` | Program-counter testbench |

## 5. Notes

- `-Wno-UNUSEDSIGNAL` is used for the complete CPU build because some current ALU/debug signals are intentionally not consumed.
- `obj_dir/` contains generated Verilator build files and should not be committed to Git.
- Each compile command can replace the executable in `obj_dir/`. Run the executable immediately after its corresponding compile command.
- The expected register values above are based on the current instruction program and testbench initialization.

## 6. Update GitHub after editing this file

```bash
git add RUNNING.md
git commit -m "Add project simulation instructions"
git push
```
