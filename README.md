# PC MUX
 
### Block Pins
1.	rst_in : in this code used as Power on Reset pin.
2.	pc_src_in : is used for current state of the core pin.
3.	ahb_ready_in : is used active high signal used to update the i_addr_out.
4.	epic_in : used to trap_return address from csr file.
5.	trap_address_in : is use Address when interrupt occurs (from csr file).
6.	branch_taken_in : used to Indication when branch instruction occurs (from branch unit).
7.	iaddr_in : Adress with addition of immediate value (from immediate adder).
8.	pc_plus_4_out : Registered for stage 2 operation (to Reg block 2).
9.	pc_mux_out : similar to pc_out but not registered (to Reg block 1).

### Explanation – PC Mux - msrv32_pc
The msrv32_pc module is a program counter unit for a RISC-V processor. It takes several inputs, including reset, program counter source, exception program counter, trap address, branch signal, instruction address, AHB ready signal, and current program counter value. Based on the inputs and the state of control signals, it calculates the next program counter value (next_pc) and outputs the updated instruction address, the program counter incremented by 4 (pc_plus_4_out), and a misaligned instruction logic signal. The module uses a multiplexer to select the correct program counter source (pc_mux_out), which could be a boot address, exception address, trap address, or the next program counter value. It also handles misaligned instruction detection by checking the least significant bit of the next program counter value.


# Reg Block 1


### Explanation – Reg Block 1 – msrv32_reg_block_1
The block receives three inputs: pc_mux_in (32-bit data for the PC), ms_riscv32_mp_clk_in (clock signal), and ms_riscv32_mp_rst_in (reset signal).The clock input ms_riscv32_mp_clk_in ensures that the program counter is updated in sync with the processor's clock cycles. The reset input ms_riscv32_mp_rst_in initializes the program counter to a known state, typically zero, to ensure proper start-up and reset behavior. The output pc_out is the current value of the program counter, providing the address of the next instruction to be executed by the processor.

### Block Pins
1.	pc_mux_in - 32-bit input for the program counter value.
2.	ms_riscv32_mp_clk_in - Clock input for synchronization.
3.	ms_riscv32_mp_rst_in - Reset input for initializing the register.
4.	pc_out - 32-bit output representing the current value of the program counter.

# Immediate Generator

### Block Diagram
 
### Explanation – Immediate Generator – msrv32_imm_generator
Block receives two input signals named instr_in (25 bits) and imm_type_in( 3 bits).
Block has one output signal named as imm_out (32 bit). The msrv32_imm_generator module extracts and assembles immediate values based on the instruction format specified by the imm_type_in input. In RISC-V 32I architecture, different instruction types have different ways of encoding immediate values, which the immediate generator handles. For example, I-type instructions use bits [31:20] of the instruction for immediate values, whereas S-type instructions combine bits [31:25] and [11:7]. The instr_in input provides the necessary bits from the instruction, and the imm_type_in input directs the module on how to assemble these bits into a 32-bit immediate value. The output imm_out is then used by other parts of the processor for executing immediate-related operations such as arithmetic operations, memory access, and branch offsets.


### Block Signals – Immediate Generator– msrv32_imm_generator
1)	instr_in : Connected to instruction bits (31 to 7).
2)	imm_type_in : control signal generated by control unit that indicates the type of immediate that must be generated.
3)	Imm_out : 32-bit generated immediate.


# Immediate adder

### Block Diagram 
 


### Block pins – Immediate adder – msrv32_immediate_adder
1)	pc_in : program counter.
2)	rs_1_in : Value of source 1 register.
3)	imm_in : Immediate value used for instruction.
4)	iadder_src_in : Gives indication of which type of instructions.
5)	iadder_out : Resultant address with addition of immediate value with pc_in or rs_1_in.

## Explanation – Immediate adder – msrv32_immediate_adder
The output iadder_out provides the resultant address, which is the sum of the immediate value and either the program counter or the source register value, depending on the iadder_src_in signal. This block is crucial for handling address calculations in instructions such as branches, jumps, and immediate arithmetic operations.


# Write Enable Generator

### Block Diagram
 

### Block pins – Write Enable Generator -msrv32_wr_en_generator
1)	flush_in : Signal to flush the pipeline during exceptions or branch mispredictions.
2)	rf_wr_en_reg_in : Write enable signal for the register file to allow data writing.
3)	csr_wr_en_reg_in : Write enable signal for the Control and Status Registers to allow data writing.
4)	wr_en_int_file_out : Generated write enable signal for internal file operations.
5)	wr_en_csr_file_out : Generated write enable signal for CSR file operations.


### Explanation– Write Enable Generator -msrv32_wr_en_generator 
It gets signals that tell it when to clear the pipeline and when to write data to the main registers and special control registers. Based on these inputs, it sends out signals to allow writing to these areas. This ensures that data is written correctly and the pipeline is managed properly during certain events. Overall, it helps keep the processor running smoothly and efficiently.

# INSTRUCTION MUX
### Block Diagram
 
### Block pins -Instruction mux - msrv32_instruction_mux
1)	flush_in : Flushes the unit(with 32’h00000013 ) when set.
2)	instr_in : Contains the instruction fetched from memory.
3)	opcode_out : Opcode of each instructions.
4)	funct3_out : funct3 field of instruction.
5)	funct7_out : funct7 field of instruction.
6)	rs1_addr_out : Contains the address of the source 1 register.
7)	rs2_addr_out : Contains the address of the source 2 register.
8)	rd_addr_out : Destination register address.
9)	csr_addr_out : Adress of the CSR to read/ write/modify.
10)	 Instr_31_7_out : Connected to immediate generator.

### Explanation -Instruction mux - msrv32_instruction_mux
The msrv32_instruction_mux block takes an instruction input (ms_riscv32_mp_instr_in) and a flush signal (flush_in). If flush_in is active, the block outputs a default instruction (32'h00000013). The block extracts and outputs specific fields from the input instruction: opcode_out, funct3_out, funct7_out, rs1addr_out, rs2addr_out, rdaddr_out, and csr_addr_out. It also outputs the remaining part of the instruction as instr_out. This module is used to process and decode the RISC-V instruction, preparing it for further stages in the processor pipeline.


# INTEGER FILE

 
### Block pins:
1)	ms_riscv32_mp_clk_in: Input clock signal for the module to synchronize operations.
2)	ms_riscv32_mp_rst_in : Input reset signal to initialize or reset the module.
3)	rs_2_addr_in : Input address for the second source register.
4)	rd_addr_in : Input address for the destination register where results are written.
5)	wr_en_in : Input signal to enable writing data to the destination register.
6)	rd_in : Input data to be written to the destination register.
7)	rs_1_out : Output data from the first source register.
8)	rs_1_out : Output data from the second source register.

### Explanation – Integer File -msrv32_integer_file
The msrv32_integer_file module operates as a part of the RISC-V 32I processor architecture. It utilizes the input clock (ms_riscv32_mp_clk_in) and reset (ms_riscv32_mp_rst_in) signals to synchronize and initialize its operations. The module takes addresses for source registers (rs_2_addr_in) and the destination register (rd_addr_in). When the write enable signal (wr_en_in) is active, the input data (rd_in) is written to the specified destination register. The module reads data from the specified source registers and provides the output through rs_1_out (and possibly rs_2_out). This data can then be used by other components of the processor for various arithmetic and logical operations. Overall, the module facilitates the storage, retrieval, and updating of integer data in the processor’s register file, enabling efficient instruction execution.


# BRACH UNIT

### Block Pin
1)	rs1_in (32) : 32-bit input data from the first source register.
2)	rs2_in (32) : 32-bit input data from the second source register.
3)	opcode_in (7) : 7-bit input opcode to specify the type of operation to be performed.
4)	funct3_in (3) : 3-bit input function code to further define the operation specified by the opcode.
5)	branch_taken_out : Output signal indicating whether a branch condition has been met and the branch is taken.


### Examination – Branch Unit - msrv32_branch_unit
The msrv32_branch_unit module is responsible for handling branch instructions in the RISC-V 32I processor. It receives two 32-bit input values (rs1_in and rs2_in) from the source registers. The module also takes a 7-bit opcode (opcode_in) that specifies the type of branch instruction. Additionally, a 3-bit function code (funct3_in) is provided to further define the branch condition. The module compares the two input values based on the provided opcode and function code. If the specified branch condition is met, the module outputs a signal (branch_taken_out) indicating that the branch should be taken. This output signal is used by the processor to determine the next instruction to execute. Overall, the msrv32_branch_unit ensures that branch instructions are correctly processed, enabling the processor to change the flow of execution based on specific conditions.


# STORE UNIT

 
### Block Pins 
1)	funct3_in : connected to the funct3 instruction field. Indicates the data size. (byte, half word or word).([1:0] bit from instruction decoder).
2)	iadder_in : Contains the address (possibly unaligned ) where the data must be written (from Immediate adder)
3)	ahb_ready_in : Active high signal when asserted, updates the ms_riscv32_mp_data_out.
4)	rs2_in : connected to Integer Register file source 2. Contains the data to be written (possibly in the right position).from integer file.
5)	mem_wr_req_in : Connected to the memory in which data to be write (from decoder).
6)	ms_riscv32_mp_dmdata_out : contains the data to be written in the right position.(output of core).
7)	ms_riscv32_mp_dmaddr_out : contains the address (aligned) where the data must be written.
8)	ms_riscv32_mp_dmwr_mask_out : A bitmask that indicates which bytes of data_out must be written.
9)	ms_riscv32_mp_dmwr_req_out : write enable pin for external memory.
10)	ahb_htrans_out : This signal signifies if the transfer is in progress or completed.
 
### Explanation – Store unit – msrv32_store_unit 
The msrv32_store_unit is a vital component in the RISC-V 32I processor, ensuring that data is correctly and efficiently written to memory. It handles various control signals, prepares data, calculates addresses, and coordinates with the AHB bus to perform store operations.


# LOAD UNIT

 
### Signals
1.	load_size_in : Connected to the two least significant bits of the fuct3 instruction field from register block 2.
2.	load_unsigned_in : Connected to the most significant bit of the funct3 from instruction field from register block 2.
3.	Ahb_resp_in : Active Low signal used to load the external data from memory.
4.	Ms_riscv32_mp_dmdata_in : 32 bit word read from memory. (from external memory).
5.	Iadder_out_1_0_in : Indicates the byte half word position in data_in  used only with load byte half word instructions.
6.	Lu_output_out : 32 bit value to be written in the integer Register file.

### Explanation 
The msrv32_load_unit plays a crucial role in handling load operations within the RISC-V 32I processor. It efficiently processes data fetched from memory, ensuring that it is correctly loaded into the processor's registers. The unit supports various data sizes, including byte, halfword, and word, and can handle both signed and unsigned load operations. By processing data accurately based on the load type and size, it maintains the integrity of data transfers within the processor. This unit is vital for the overall functionality of the processor, as it ensures that data is available for subsequent operations and computations. Its efficient design contributes to the processor's performance and reliability, making it an essential component of the RISC-V 32I architecture.


# REG BLOCK 2

### Explanation
All the input signals is store with respect to the clock
Reset_in : is to reset all the values
Clk_in : clock pulses to the registers inside the 


# ALU

 
### Signals -alu
1.	op_1_in : operation first operand
2.	op_2_in : operation second operand
3.	opcode_in : operation code thes is signal is driven by function3 and function7 instruction fields
4.	result_out : Result of the requested operation.


### Explanation
In our RISC-V 32I project, the ALU (Arithmetic Logic Unit) serves as a crucial component for executing arithmetic and logical operations within the processor. It operates using four main signals: op_1_in and op_2_in, which represent the operands involved in the operation, opcode_in driven by function3 and function7 instruction fields, specifying the type of operation to be performed, and result_out, which outputs the computed result of the operation. These signals collectively manage the flow of data and control within the ALU, enabling it to perform tasks like addition, subtraction, bitwise operations, and comparisons as dictated by the processor's instructions.


# Wb Mux Selection out
 
### Signals
1.	wb_mux_sel_reg_in : Selects the data to be written in integer register file 
2.	alu_result_in :the result produced by alu.
3.	Lu_output_in : output of load unit.
4.	Imm_reg_in : Immediate data.
5.	Iadder_out_reg_in : the sum of Immediate data and rs1.
6.	Csr_data_in : data out port of CSR Module.
7.	Pc_plus_4_reg_in: PC + 4
8.	Rs2_reg_in : RS2 register output from Integer file.
9.	Alu_src_reg_in : used to select rs2 register data immediate data.
10.	Wb_mux_out : The output port of wb_mux.
11.	Alu_2nd_src_mux_out: RS2 register output



# DECODER


### Signals – Decoder

1.	Op_code_6_to_2_in : connected to the instruction opcode field.
2.	Funct7_5_in : connected to instruction funct7 field.
3.	Funct3_in : connected to function 3 field.
4.	Iadder_out_1_0_in : used to verify the alignment of loads and stores.
5.	Trap_taken_in : when set is high it indicates that trap will be taken next clock cycle. Connected to machine control module.
6.	Alu_opcode_out : selects the operation to performed by alu.
7.	Mem_wr_req_out : when set high indicates a request to write memory.
8.	Load_size_out : Indicates the word size of load instruction.
9.	Load_unsigned_out :Indicates the type of load instruction.
10.	Alu_src-out : selects alu second operand.
11.	Iadder_src_out : selects immediate adder 2nd operand.
12.	Csr_wr_en_out : controls the wr_en input of CSR register file.
13.	Rf_wr_en_out: controls the input wr_en  of csr file.
14.	 Wb_mux_sel_out : Selects the data to be written in the integer register file.
15.	Imm_type_out : selects the data to be written in the integer file.
16.	Csr_op_out : selects the operation to be performed by CSR Register file.
17.	Illeagle_instr_out: When set is high that indicates an invalid or not implemented instruction was fetched from memory.
18.	Misaligned_load_out : When set is high that an attempt to read data_in disagreement with the memory.
19.	Misaligned_store_out : when set is high indicates an attempt to write data in memory in disagreement 




