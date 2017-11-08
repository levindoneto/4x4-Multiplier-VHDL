# 4x4-Multiplier-VHDL-
__Authors:__ Eduardo Brito, Felipe Tormes, Levindo Neto

A 4x4 Multiplier made in VHDL.

## Algorithm
The used algorithm can be viewed in the image below:
![Algorithmics](resources/Algorithmic.jpg)

## RTL Project
The RTL Project is divided in: 
* ASM Fluxogram
* Control Block (Finite State Machine)
* Operative Block (Registers, Logical Blocks, Functional and Arithmetic Circuits)

### ASM Fluxogram
The ASM fluxogram for the RTL project's model can be seen in the following image:
![ASM Fluxogram](resources/ASM_Fluxogram.jpg)

### Control Block
The finite state machine for the 4x4 Multiplier can be viewed in the image below:
![Control Block](resources/Control_Block.jpg)

### Operative Block
The operative part, with the used registers, logical and arithmetic digital blocks, can be viewed in the image below:
![Operative Block](resources/Operative_Block.jpg)

## Memory Organization
The memory of the 4x4 multiplier is organized in:
* Two single-port memories with 4 positions of 16 bits each for the input matrices.
* One single-port memory with 16 positions of 8 bits each for the output matrix.
The organization of the used memory can be viewed in the following image:
![Memory](resources/Memory.jpg)

## High Level Circuit
The built circuit, in a high level approach, can be seen in the image below:
![HighLevel_Circuit](resources/HighLevel_Circuit.jpg)

## Temporal Simulations
### Simulation Without Delay
![Simulation Without Delay](resources/Simulation_Without_Delay.jpg)

### Simulation with Delay
![Simulation With Delay](resources/Simulation_With_Delay.jpg)

## Other Information

### Area Information
![Area Information](resources/Area_Information.jpg)

### Temporal Information
__Number of Cycles:__ 154.<br/>
__Time to Answer:__ 1535ns using 10 ns of period.<br/>
__Minimum Period:__ 10.233ns.<br/>
__Maximum Frequency:__ 97.723MHz.<br/>
__Minimum Input Arrival Time before Clock:__ 2.382ns.<br/>
__Maximum Output, which is the Required Time after Clock:__ 6.446ns.<br/>
