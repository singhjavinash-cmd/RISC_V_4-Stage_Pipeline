
## Architecture

This project implements a 4-stage pipelined RISC-V processor in Verilog.

```mermaid
flowchart LR
    A["Program Counter (PC)"] --> B["Instruction Memory"]
    B --> C["IF/ID Pipeline Register"]
    C --> D["Instruction Decode"]
    D --> E["Register File"]
    D --> F["Immediate Generator"]
    E --> G["ID/EXMEM Pipeline Register"]
    F --> G
    G --> H["ALU"]
    H --> I["Data Memory"]
    H --> J["MEM/WB Pipeline Register"]
    I --> J
    J --> K["Writeback"]
    K --> E
```

### Pipeline stages

1. **IF — Instruction Fetch:** PC selects an instruction from instruction memory.
2. **ID — Instruction Decode:** Decode instruction, read registers, generate immediate and control signals.
3. **EX/MEM — Execute and Memory:** ALU performs operations; data memory handles loads and stores.
4. **WB — Writeback:** Write ALU or memory result back to the register file.

### RTL Modules

| Module | Description |
|---|---|
| `program_counter.v` | Program counter |
| `instruction_memory.v` | Instruction storage |
| `register_file.v` | 32 × 32-bit register file |
| `immediate_generator.v` | RISC-V immediate extraction |
| `control_unit.v` | Instruction decode and control |
| `alu.v` | Arithmetic and logic operations |
| `data_memory.v` | Data memory |
| `pipeline_registers.v` | Pipeline stage registers |
| `riscv_top.v` | Processor top-level integration |

### Simulation

Run from the project root:

```bash
iverilog -g2012 -o sim.out rtl/*.v tb/tb_riscv_top.v
vvp sim.out
```

The testbench generates `riscv_wave.vcd`. Open it in a waveform viewer such as GTKWave or Surfer.

## Simulation Waveform

The waveform below shows the basic ADDI instruction execution.

![ADDI waveform](docs/waveform_addi.png)