# EV19 RISC-V Softcore

## Microarchitecture
<p align="center">
  <img src="https://raw.githubusercontent.com/tlifschitz/EV19-RISC-V/master/Images/EV19%20RISC-V%20Microarchitecture.png" />
</p>

This project took place in the context of a computer architecture course, of the Electronic Engineering degree at ITBA (Technological Institute of Buenos Aires). The main objective was to desig a microarchitecutre implementing a modern ISA, and synthetize it as a softcore in an FPGA so as to test it in the real world, beyond the verification in the simulation software. 

The objective was not to design the ISA, so an open source instruction set was chosen. RISC-V was selected due to its detailed documentation, and it's constantly-growing community. Furthermore it's modular design was convenient to work with a base implementation and extend support for other modules later.

The overall design consists of a five stage standard RISC pipeline, and a harvard architecture with two separates memories for instructions and data. The instructions are decoded into a control word which propagates through each stage of the pipeline, and data hazards are prevented using a specialized module. The final design adds a branch predictor unit which improves the performance of the architecture.

### Fetch
The first stage of the pipeline reads instruccions from the instruction memory, using the memory address stored in the PC (Program Counter) register. In a completely sequenctial program this would simply be a monotonicaly increasing counter, but jumps in the code makes this a more complex task. With this taken this into account, the next memory address is selected among different options depending on the state of other signals. If the next instruction to fetch is the one inmedialty after the previous one, the PC simply increments in 4. On the other hand if the pipeline is temporary stalled because of a instruction in a further stage needs more cycles to finish, the PC stays with the same value until the execution resumes. Finally if a branch is indeed taken, this is signaled from the Execute stage, together with the destination address of the jump. So the PC jumps to that point in memory, and instuctions stored in Fetch and Decode are flushed since they must not be executed.

### Decode
This stage decodes the instruction type and buils a control word with signals designed to drive this michroarchitecture, which will propagate through the further pipeline stages. The register bank defined by the ISA is implemented in this stage, and their content is read if the instruction requires it. A possible immediate value embedded in the instruction it is also decoded here.  

### Execute 
At this point the instruction can be executed, using the operands decoded in the previous stage and feeding them to de ALU (Arithmetical Logic Unit). This stage also must resolve branch executions and notify Fetch stage the result to continue running the code. The memory operations (read and writes) are also issued at this point in order to have the result in the next stage. The stores are handled with a specialized module, which implements the different formats defined by the ISA (word, half, byte).

### Memory access
At this point the raw value, result of a read operation, is formated according the specific instruction depending on the width of the data and it's sign.  

### Writeback
The last stage in the pipeline selects the corresponging value from the output of the ALU or from the memory stage, and commits the result to the register bank.

### Hazard and Forwarding Unit
This module is crutial for the correct operation of the pipeline. In the first place, it detects data hazards between the stages and prevents them. In case of a RAW (Read After Write) hazard, a technique called data forwarding is used. It basically consists of using as operand for the input of the ALU a value from a posterior stage in the pipeline (not yet stored back to the register bank). In the second place it handles memory latency, stalling the execution in case an operation does not finish a execution cycle. Finally this module flushes the corresponding pipeline registers in case its value becomes invalid (in a branch misprediction).

### Branch Predictor
This feature was the last to be design and integrated to the micrhoarchitecture. It improves the performance when encountering exectuion branches with the help of two primarly structures. The branch hystory table (BHT) which effectivly makes a predicion for each PC value, consists of a state machine with four states (strongly taken, weakly taken, wakly not taken, strongly not taken). On the other hand the branch target buffer (BTB) acts like a cache storing the destination of each branch or jump instruction. Note that the prediction of the BHT is only valid if there is a hit in the BTB, which implies that that instruction has already been executed and it's destination stored.
These structures are read from the Fetch stage, and modified from the Execute stage when the branches are resolved. 

<p align="center">
  <img src="https://raw.githubusercontent.com/EV19-RISC-V/HDL/master/Images/BranchPredictionUnit.png" />
</p>
In this way, the fields start in an invalid state and are completed as the jump instructions appear. Conditional jumps update both BTB and BHT, while unconditional ones only update the BTB. The execute stage is also in charge of correcting the errors of the predictor. When the prediction differs from the actual jump result, the PC is corrected by the Execute stage. If the jump should have been taken the calculated destination is used, while if the jump was wrongly taken the instruction following the jump is used. In both cases it is necessary to flush the Fetch and Fecode stages.


## System on a Chip (SoC)
To enrich the implementation features, the Intel Platform Designer Tool was leveraged to map different peripherals to the processor memory. This include different memory blocks, a memory controller to access an off-chip DRAM, timers, leds, among others. A bus arbitrer is used to access the external RAM since it acts like a video buffer. The two masters accessing it are the EV19 core writing frames, and the VGA controller reading them to generate the digital RGB signals, which are routed to phisical pins in the evaluation board and converted to analog voltages, so as to connect a VGA cable and see the image in a monitor.

<p align="center">
  <img src="https://raw.githubusercontent.com/tlifschitz/EV19-RISC-V/master/Images/EV19%20SoC.png" />
</p>

### Memory mapped peripherals
In the screenshot below, the design in Platform Designer can be seen in detail. Note the EV19 core has two bus masters: the instruction master only connected only to the instruction memory, while the data master connected to the entire memory map.
<p align="center">
  <img src="https://raw.githubusercontent.com/EV19-RISC-V/HDL/master/Images/platform-designer-peripherals.png" />
</p>

### Video output
The VGA subsystem to generate the video output stream was implemented as shown below. 
<p align="center">
  <img src="https://raw.githubusercontent.com/EV19-RISC-V/HDL/master/Images/platform-designer-video-output.png" />
</p>

