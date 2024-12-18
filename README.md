# VHDL-MIPS-Processor

# MIPS Processor in VHDL

This project implements a MIPS processor using VHDL, designed to execute a subset of the MIPS instruction set. The processor includes essential components such as an Arithmetic Logic Unit (ALU), register file, and control unit. The design has been verified through simulation and synthesized for hardware implementation.

## Features

- **Arithmetic and Logical Operations**: Supports basic arithmetic (ADD, SUB) and logical operations (AND, OR, XOR).
- **Memory Access**: Implements load (`LW`) and store (`SW`) instructions.
- **Control Flow**: Supports branching instructions (`BEQ`, `BNE`) and jump operations (`J`, `JR`).
- **Register File**: Contains 32 registers for data storage and manipulation.
- **Modular Design**: Components like ALU, control unit, and data path are designed as independent modules for flexibility and scalability.

## Project Structure

- **`mips.vhd`**: Main VHDL file implementing the processor's architecture.
- **Testbenches**: VHDL testbench files for simulation and verification of the processor and its components.
- **Simulation Outputs**: Logs and waveforms generated during simulation using tools like ModelSim.

## Tools Used

- **VHDL**: Hardware description language used for the design.
- **ModelSim**: For simulation and functional verification.
- **Synthesis Tools**: Compatible with FPGA tools such as Xilinx Vivado and Intel Quartus.

## How to Use

### Simulation

1. Open ModelSim or another VHDL-compatible simulation tool.
2. Load the provided VHDL files into the project.
3. Compile the source file (`mips.vhd`) along with the corresponding testbenches.
4. Run simulations and verify the output using the provided waveform viewer or simulation logs.

### Synthesis

1. Import `mips.vhd` into an FPGA design suite (e.g., Vivado, Quartus).
2. Synthesize the design to generate a hardware bitstream.
3. Load the bitstream onto an FPGA for hardware testing.

## Example Instructions

- **Arithmetic**: `ADD R1, R2, R3`  
   - Adds the values in registers `R2` and `R3`, and stores the result in `R1`.
- **Memory Access**: `LW R1, 0(R2)`  
   - Loads data from memory address specified by `R2` into `R1`.
- **Control Flow**: `BEQ R1, R2, Label`  
   - Branches to the specified label if `R1` and `R2` are equal.

## Future Enhancements

- **Pipelining**: Introduce instruction pipelining for improved performance.
- **Extended Instruction Set**: Add support for more advanced instructions like floating-point operations.
- **Hazard Management**: Implement hazard detection and resolution mechanisms.

## Applications

- **Educational**: Ideal for teaching and learning computer architecture concepts.
- **Prototyping**: Useful for developing custom processors for embedded systems.
- **Research**: Provides a baseline for experimenting with advanced processor features.
