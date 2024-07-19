`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08.07.2024 21:43:41
// Design Name: 
// Module Name: msrv32_main_block
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module msrv32_main_block(
//pc mux input
input ms_riscv32_mp_clk_in,
input ms_riscv32_mp_rst_in,
input ahb_ready_in,
//instruction mux
input [31:0] ms_riscv32_mp_dmdata_in,
input [31:0] ms_riscv32_mp_instr_in,
//pc mux  output
input ahb_resp_in,
input [63:0] ms_riscv32_mp_rc_in,
//machine control
input ms_riscv32_mp_eirq_in,
input ms_riscv32_mp_tirq_in,
input ms_riscv32_mp_sirq_in,
//
//reg_block_1_input
output ms_riscv32_mp_dmwr_req_out,
output [31:0] ms_riscv32_mp_imaddr_out,
output [31:0] ms_riscv32_mp_dmaddr_out,
//reg_block_1_output
output [31:0] ms_riscv32_mp_dmdata_out,

output [3:0] ms_riscv32_mp_dmwr_mask_out,

output [1:0] ahb_htrans_out
);
//pc mux
wire [1:0]from_machine_control_to_pc_mux_pc_src_in;
wire [31:0]from_reg_block_1_to_pc_mux_pc_in;
wire [31:0] from_csr_file_to_pc_mux_epic_in;
wire [31:0] from_csr_file_to_pc_mux_trap_address_in;
wire from_branch_unit_to_pc_mux_branch_taken_in;
wire [1:0] from_immediate_adder_to_pc_mux_iaddr_in;
//Pc mux output wires
wire [31:0] from_pc_mux_to_reg_block_2_pc_plus_4_out;
wire from_pc_mux_to_machine_control_misaligned_instr_out;
wire [31:0] from_pc_mux_out_pc_mux_in;

//Pipeline stage 2

//Immediate adder
//Input
wire [31:0] from_integer_file_rs1_out_to_immediate_adder_branch_unit_reg_block_2_rs1_in;
wire from_decoder_to_immediate_adder_iadder_src_in;
wire [31:0] from_imm_generator_to_immediate_adder_reg_block_2_imm_in;
//output
wire [31:0] from_immediate_adder_to_decoder_iadder_out;

//Immedeaite Generator
wire [24:0] from_instruction_mux_to_imm_generator_ms_riscv32_mp_instr_in;
wire [2:0] from_decoder_to_imm_generator_imm_type_in;

// Integer file
//input
wire [31:0] from_wb_mux_sel_unit_to_Integer_file;
wire from_wr_en_generator_to_integer_file_wr_en_in;
wire [4:0] from_instruction_mux_to_integer_file_rd_addr_in;
wire [4:0] from_instruction_mux_to_integer_file_rs_2_addr_in;
wire [4:0] from_instruction_mux_to_integer_file_rs_1_addr_in;
//output
wire [31:0] from_integer_file_to_reg_block_2_branch_unit_store_unit_rs_2_out;

// Write Enable Generator
//Input
wire from_machine_control_to_wr_en_generator_flush_in;
wire from_reg_block_2_to_wr_en_in_rf_wr_en_reg_in;
wire from_reg_block_2_to_wr_en_in_csr_wr_en_reg_in;
//output
wire from_wr_en_generator_to_csr_file_csr_file_wr_en_out;

//Instruction Mux output
wire [6:0] from_instruction_mux_to_decoder_opcode_out;
wire [2:0] from_instruction_mux_to_decoder_funct3_out;
wire [6:0] from_instruction_mux_to_decoder_funct7_out;
//wire [4:0] from_instruction_mux_to_integer_file_rdaddr_out;
wire [11:0] from_instruction_mux_to_reg_block_2_csr_addr_out;

//wire decoder
wire from_machine_control_to_decoder_trap_taken_in;
wire [2:0] from_decoder_to_store_unit_wb_mux_sel_out;
wire from_decoder_to_store_unit_mem_wr_req_out;
wire  [2:0] from_decoder_to_reg_block_2_csr_op_out;
wire  [3:0] from_decoder_to_reg_block_2_alu_opcode_out;
wire [1:0] from_decoder_to_reg_block_2_load_size_out;
wire from_decoder_to_reg_block_2_load_unsigned_out;
wire  from_decoder_to_reg_block_2_alu_src_out;
wire from_decoder_to_reg_block_2_iadder_src_out;
wire from_decoder_to_reg_block_2_csr_wr_en_out;
wire from_decoder_to_reg_block_2_rf_wr_en_out;

wire from_decoder_to_machine_control_illegal_instr_out;
wire from_decoder_to_machine_control_misaligned_load_unit;
wire from_decoder_to_machine_control_misaligned_store_unit;
//csr file
wire from_csr_file_to_machine_control_mei_in;
wire from_csr_file_to_machine_control_meie_in;
wire from_csr_file_to_machine_control_mtie_in;
wire from_csr_file_to_machine_control_msie_in;
wire from_csr_file_to_machine_control_meip_in;
wire from_csr_file_to_machine_control_mtip_in;
wire from_csr_file_to_machine_control_msip_in;

//csr file to wr_mux_sel_out
wire  [31:0] from_csr_file_to_wr_mux_sel_out_csr_data_out;
//machine control
wire from_machine_control_to_csr_file_i_or_e_out;
wire from_machine_control_to_csr_file_set_epc_out;
wire from_machine_control_to_csr_file_set_cause_out;
wire [3:0] from_machine_control_to_csr_file_cause_out;
wire from_machine_control_to_csr_file_insterct_inc_out;
wire from_machine_control_to_csr_file_mie_clear_out;
wire from_machine_control_to_csr_file_mie_set_out;
wire from_machine_control_to_csr_file_misaligned_exception_out;

//csr to reg block 2
wire [11:0] from_csr_file_to_reg_block_2_csr_addr_in;
wire [2:0 ] from_csr_file_to_reg_block_2_csr_op_in;
wire [4:0 ] from_csr_file_to_reg_block_2_csr_uimm_in;
wire [31:0] from_csr_file_to_reg_block_2_csr_data_in;
wire [31:0] from_csr_file_to_reg_block_2_pc_in;
wire [31:0] from_csr_file_to_reg_block_2_iadder_in;

wire [31:0] from_reg_block_2_wb_mux_sel_unit_rs2_reg_in;
wire [2:0] from_reg_block_2_wb_mux_sel_unit_wb_mux_sel_reg_in;
wire from_reg_block_2_wb_mux_sel_unit_alu_src_reg_in;
wire [31:0] from_reg_block_2_wb_mux_sel_unit_pc_plus_4_reg_in;


//pipe lin 3

wire [31:0] from_load_unit_wb_mux_sel_unit_lu_output_out;
wire [31:0] from_alu_to_wb_mux_sel_alu_result_in;
wire [31:0] from_op_2_in_to_alu_2nd_src_mux_out;
wire rd_addr_reg_out;
wire alu_opcode_reg_out;
wire load_size_reg_out;
wire load_unsigned_reg_out;
wire csr_wr_en_reg_out;

msrv32_pc  PC_MUX_1 (
    .rst_in(ms_riscv32_mp_rst_in),
    .pc_src_in(from_machine_control_to_pc_mux_pc_src_in),
    .epc_in(from_csr_file_to_pc_mux_epic_in),
    .trap_address_in(from_csr_file_to_pc_mux_trap_address_in),
    .branch_taken_in(from_branch_unit_to_pc_mux_branch_taken_in),
    .iaddr_in(from_immediate_adder_to_pc_mux_iaddr_in),
    .ahb_ready_in(ahb_ready_in),
    .pc_in(from_reg_block_1_to_pc_mux_pc_in),
    
    .iaddr_out(ms_riscv32_mp_imaddr_out),
    .pc_plus_4_out(from_pc_mux_to_reg_block_2_pc_plus_4_out),
    .misaligned_instr_logic_out(from_pc_mux_to_machine_control_misaligned_instr_out),
    .pc_mux_out(from_pc_mux_out_pc_mux_in)
     );
// Reg block 1 - pipeline 1
msrv32_reg_block_1 REG_BLOCK_1(
    .pc_mux_in(from_pc_mux_out_pc_mux_in),
    .ms_riscv32_mp_clk_in(ms_riscv32_mp_clk_in),
    .ms_riscv32_mp_rst_in(ms_riscv32_mp_rst_in),
    .pc_out(from_reg_block_1_to_pc_mux_pc_in)
);
// ##########################################################################################
//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!@@@@@@@@@@@@@@@@@@@@@@!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!


//    ----------------------------       PIPELINE  Stage 2   Part 1      ------------------------------------
msrv32_immediate_adder  Immidiate_adder_1(
    .pc_in(from_reg_block_1_to_pc_mux_pc_in),
    .rs_1_in(from_integer_file_rs1_out_to_immediate_adder_branch_unit_reg_block_2_rs1_in),
    .iadder_src_in(from_decoder_to_immediate_adder_iadder_src_in),
    .imm_in(from_imm_generator_to_immediate_adder_reg_block_2_imm_in),
    .iadder_out(from_immediate_adder_to_decoder_iadder_out)
);
msrv32_imm_generator Immediate_Generator_1(
    .instr_in(from_instruction_mux_to_imm_generator_ms_riscv32_mp_instr_in),
    .imm_type_in(from_decoder_to_imm_generator_imm_type_in),
    .imm_out(from_imm_generator_to_immediate_adder_reg_block_2_imm_in)
);

msrv32_integer_file Integer_file(
    .ms_riscv32_mp_clk_in(ms_riscv32_mp_clk_in),
    .ms_riscv32_mp_rst_in(ms_riscv32_mp_rst_in),
    .rs_2_addr_in(from_instruction_mux_to_integer_file_rs_2_addr_in),
    .rd_addr_in(from_instruction_mux_to_integer_file_rd_addr_in),
    .wr_en_in(from_wr_en_generator_to_integer_file_wr_en_in),
    .rd_in(from_wb_mux_sel_unit_to_Integer_file),
    .rs_1_addr_in(from_instruction_mux_to_integer_file_rs_1_addr_in),
    .rs_1_out(from_integer_file_rs1_out_to_immediate_adder_branch_unit_reg_block_2_rs1_in),
    .rs_2_out(from_integer_file_to_reg_block_2_branch_unit_store_unit_rs_2_out)
);

msrv2_wr_en_generator Write_enable_Generator(
    .flush_in(from_machine_control_to_wr_en_generator_flush_in),
    .rf_wr_en_reg_in(from_reg_block_2_to_wr_en_in_rf_wr_en_reg_in),
    .csr_wr_en_reg_in(from_reg_block_2_to_wr_en_in_csr_wr_en_reg_in),
    .wr_en_int_file_out(from_wr_en_generator_to_integer_file_wr_en_in),
    .wr_en_csr_file_out(from_wr_en_generator_to_csr_file_csr_file_wr_en_out)
);

msrv32_instruction_mux  Instruction_Mux(
    .flush_in(from_machine_control_to_wr_en_generator_flush_in),
    .ms_riscv32_mp_instr_in(ms_riscv32_mp_instr_in),
    .opcode_out(from_instruction_mux_to_decoder_opcode_out),
    .funct3_out(from_instruction_mux_to_decoder_funct3_out),
    .funct7_out(from_instruction_mux_to_decoder_funct7_out),
    .rs1addr_out(from_instruction_mux_to_integer_file_rs_1_addr_in),
    .rs2addr_out(from_instruction_mux_to_integer_file_rs_2_addr_in),
    .rdaddr_out(from_instruction_mux_to_integer_file_rd_addr_in),
    .csr_addr_out(from_instruction_mux_to_reg_block_2_csr_addr_out),
    .instr_out(from_instruction_mux_to_imm_generator_ms_riscv32_mp_instr_in)
);

msrv32_branch_unit Branch_unit(
    .rs1_in(from_integer_file_rs1_out_to_immediate_adder_branch_unit_reg_block_2_rs1_in),
    .rs2_in(from_integer_file_to_reg_block_2_branch_unit_store_unit_rs_2_out),
    .opecode_in(from_instruction_mux_to_decoder_opcode_out),
    .funct3_in(from_instruction_mux_to_decoder_funct3_out),
    .branch_taken_out(from_branch_unit_to_pc_mux_branch_taken_in)
);

msrv32_decoder Decoder(
    .trap_taken_in(from_machine_control_to_decoder_trap_taken_in),
    .funct7_5_in(from_instruction_mux_to_decoder_funct7_out),
    .opcode_in(from_instruction_mux_to_decoder_opcode_out),
    .funct3_in(from_instruction_mux_to_decoder_funct3_out),
    .iadder_out_1_to_0_in(from_immediate_adder_to_decoder_iadder_out),
    .wb_mux_sel_out(from_decoder_to_store_unit_wb_mux_sel_out),
    .imm_type_out(from_decoder_to_imm_generator_imm_type_in),
    .csr_op_out(from_decoder_to_reg_block_2_csr_op_out),
    .mem_wr_req_out(from_decoder_to_store_unit_mem_wr_req_out),
    .alu_opcode_out(from_decoder_to_reg_block_2_alu_opcode_out),
    .load_size_out(from_decoder_to_reg_block_2_load_size_out),
    .load_unsigned_out(from_decoder_to_reg_block_2_load_unsigned_out),
    .alu_src_out(from_decoder_to_reg_block_2_alu_src_out),
    .iadder_src_out(from_decoder_to_reg_block_2_iadder_src_out),
    .csr_wr_en_out(from_decoder_to_reg_block_2_csr_wr_en_out),
    .rf_wr_en_out(from_decoder_to_reg_block_2_rf_wr_en_out),
    .illegal_instr_out(from_decoder_to_machine_control_illegal_instr_out),
    .misaligned_load_out(from_decoder_to_machine_control_misaligned_load_unit),
    .misaligned_store_out(from_decoder_to_machine_control_misaligned_store_unit)
);

msrv32_machine_control Machine_control(
    .clk_in(ms_riscv32_mp_clk_in), 
    .reset_in(ms_riscv32_mp_rst_in),
    .illegal_instr_in(from_decoder_to_machine_control_illegal_instr_out),
    .misaligned_load_in(from_decoder_to_machine_control_misaligned_load_unit),
    .misaligned_store_in(from_decoder_to_machine_control_misaligned_store_unit),
    .misaligned_instr_in(from_pc_mux_to_machine_control_misaligned_instr_out),
    .opcode_6_to_2_in(from_instruction_mux_to_decoder_opcode_out),
    .funct3_in(from_instruction_mux_to_decoder_funct3_out),
    .funct7_in(from_instruction_mux_to_decoder_funct7_out),
    .rs1_addr_in(from_instruction_mux_to_integer_file_rs_1_addr_in),
    .rs2_addr_in(from_instruction_mux_to_integer_file_rs_2_addr_in),
    .rd_addr_in(from_instruction_mux_to_integer_file_rd_addr_in),
    .e_irq_in(ms_riscv32_mp_eirq_in),
    .t_irq_in(ms_riscv32_mp_tirq_in),
    .s_irq_in(ms_riscv32_mp_sirq_in),
    .mie_in(from_csr_file_to_machine_control_mei_in),
    .meie_in(from_csr_file_to_machine_control_meie_in),
    .mtie_in(from_csr_file_to_machine_control_mtie_in),
    .msie_in(from_csr_file_to_machine_control_msie_in),
    .meip_in(from_csr_file_to_machine_control_meip_in),
    .mtip_in(from_csr_file_to_machine_control_mtip_in),
    .msip_in(from_csr_file_to_machine_control_msip_in),
    .i_or_e_out(from_machine_control_to_csr_file_i_or_e_out),
    .set_epc_out(from_machine_control_to_csr_file_set_epc_out),
    .set_cause_out(from_machine_control_to_csr_file_set_cause_out),
    .cause_out(from_machine_control_to_csr_file_cause_out),
    .instret_inc_out(from_machine_control_to_csr_file_insterct_inc_out),
    .mie_clear_out(from_machine_control_to_csr_file_mie_clear_out),
    .mie_set_out(from_machine_control_to_csr_file_mie_set_out),
    .misaligned_exception_out(from_machine_control_to_csr_file_misaligned_exception_out),
    .pc_src_out(from_machine_control_to_pc_mux_pc_src_in),
    .flush_out(from_machine_control_to_wr_en_generator_flush_in),
    .trap_taken_out(from_machine_control_to_decoder_trap_taken_in) 
);

msrv32_csr_file Csr_file(
     .clk_in(ms_riscv32_mp_clk_in),
     .rst_in(ms_riscv32_mp_rst_in),
     .wr_en_in(from_wr_en_generator_to_csr_file_csr_file_wr_en_out),
     .csr_addr_in(from_csr_file_to_reg_block_2_csr_addr_in),
     .csr_op_in(from_csr_file_to_reg_block_2_csr_op_in),
     .csr_uimm_in(from_csr_file_to_reg_block_2_csr_uimm_in),
     .csr_data_in(from_csr_file_to_reg_block_2_csr_data_in),
     .pc_in(from_csr_file_to_reg_block_2_pc_in),
     .iadder_in(from_csr_file_to_reg_block_2_iadder_in),
     .e_irq_in(ms_riscv32_mp_eirq_in),
     .s_irq_in(ms_riscv32_mp_sirq_in),
     .t_irq_in(ms_riscv32_mp_tirq_in),
     .i_or_e_in(from_machine_control_to_csr_file_i_or_e_out),
     .set_cause_in(from_machine_control_to_csr_file_set_cause_out),
     .set_epc_in(from_machine_control_to_csr_file_set_epc_out),
     .instret_inc_in(from_machine_control_to_csr_file_insterct_inc_out),
     .mie_clear_in(from_machine_control_to_csr_file_mie_clear_out),
     .mie_set_in(from_machine_control_to_csr_file_mie_set_out),
     .cause_in(from_machine_control_to_csr_file_cause_out),
     .real_time_in(ms_riscv32_mp_rc_in),
     .misaligned_exception_in(from_machine_control_to_csr_file_misaligned_exception_out),
     .csr_data_out(from_csr_file_to_wr_mux_sel_out_csr_data_out),
     .mie_out(from_csr_file_to_machine_control_mei_in),
     .epc_out(from_csr_file_to_pc_mux_epic_in),
     .trap_address_out(from_csr_file_to_pc_mux_trap_address_in),
     .meie_out(from_csr_file_to_machine_control_meie_in),
     .mtie_out(from_csr_file_to_machine_control_mtie_in),
     .msie_out(from_csr_file_to_machine_control_msie_in),
     .meip_out(from_csr_file_to_machine_control_meip_in),
     .mtip_out(from_csr_file_to_machine_control_mtip_in),
     .msip_out(from_csr_file_to_machine_control_msip_in)
);

msrv32_reg_block_2 Regblock_2(
    .rd_addr_in(from_instruction_mux_to_integer_file_rd_addr_in),
    .csr_addr_in(from_instruction_mux_to_reg_block_2_csr_addr_out),
    .rs1_in(from_integer_file_rs1_out_to_immediate_adder_branch_unit_reg_block_2_rs1_in),
    .rs2_in(from_integer_file_to_reg_block_2_branch_unit_store_unit_rs_2_out),
    .pc_in(from_reg_block_1_to_pc_mux_pc_in),
    .pc_plus_4_in(from_pc_mux_to_reg_block_2_pc_plus_4_out),
    .alu_opcode_in(from_decoder_to_reg_block_2_alu_opcode_out),
    .load_size_in(from_decoder_to_reg_block_2_load_size_out),
    .load_unsigned_in(from_decoder_to_reg_block_2_load_unsigned_out),
    .alu_src_in(from_decoder_to_reg_block_2_alu_src_out),
    .csr_wr_en_in(from_decoder_to_reg_block_2_csr_wr_en_out),
    .rf_wr_en_in(from_decoder_to_reg_block_2_rf_wr_en_out),
    .wb_mux_sel_in(from_decoder_to_store_unit_wb_mux_sel_out),
    .csr_op_in(from_decoder_to_reg_block_2_csr_op_out),
    .imm_in(from_imm_generator_to_immediate_adder_reg_block_2_imm_in),
    .iadder_out_in(from_immediate_adder_to_decoder_iadder_out),
    .branch_taken_in(from_branch_unit_to_pc_mux_branch_taken_in),
    .reset_in(ms_riscv32_mp_rst_in),
    .clk_in(ms_riscv32_mp_clk_in),
    .rd_addr_reg_out(rd_addr_reg_out),
    .csr_addr_reg_out(from_csr_file_to_reg_block_2_csr_addr_in),
    .rs1_reg_out(from_csr_file_to_reg_block_2_csr_data_in),
    .rs2_reg_out(from_reg_block_2_wb_mux_sel_unit_rs2_reg_in),
    .pc_reg_out(from_csr_file_to_reg_block_2_pc_in),
    .pc_plus_reg_out(from_reg_block_2_wb_mux_sel_unit_pc_plus_4_reg_in),
    .alu_opcode_reg_out(alu_opcode_reg_out),
    .load_size_reg_out(load_size_reg_out),
    .load_unsigned_reg_out(load_unsigned_reg_out),
    .alu_src_reg_out(from_reg_block_2_wb_mux_sel_unit_alu_src_reg_in),
    .csr_wr_en_reg_out(from_reg_block_2_to_wr_en_in_csr_wr_en_reg_in),
    .rf_wr_en_reg_out(from_reg_block_2_to_wr_en_in_rf_wr_en_reg_in),
    .wb_mux_sel_reg_out(from_reg_block_2_wb_mux_sel_unit_wb_mux_sel_reg_in),
    .csr_op_reg_out(from_csr_file_to_reg_block_2_csr_op_in),
    .imm_reg_out(from_csr_file_to_reg_block_2_csr_uimm_in),
    .iadder_out_reg_out(from_csr_file_to_reg_block_2_iadder_in)    

);
msrv32_store_unit store_unit(
    .funct3_in(from_instruction_mux_to_decoder_funct3_out),
    .iadder_in(from_immediate_adder_to_decoder_iadder_out),
    .rs2_in(from_integer_file_to_reg_block_2_branch_unit_store_unit_rs_2_out),
    .mem_wr_req_in(from_decoder_to_store_unit_mem_wr_req_out),
    .ahb_ready_in(ahb_ready_in),
    .ms_riscv32_mp_dmdata_out(ms_riscv32_mp_dmdata_out),
    .ms_riscv32_mp_dmaddr_out(ms_riscv32_mp_dmaddr_out),
    .ms_riscv32_mp_dmwr_mask_out(ms_riscv32_mp_dmwr_mask_out),
    .ms_riscv32_mp_dmwr_req_out(ms_riscv32_mp_dmwr_req_out),
    .ahb_htrans_out(ahb_htrans_out)

);


//#################################### Pipeline Stage 3  ######################################

msrv32_load_unit LoadUnit(
    .ahb_resp_in(ahb_resp_in),
    .ms_riscv32_mp_dmdata_in(ms_riscv32_mp_dmdata_in),
    .iadder_out_1_to_0_in(from_immediate_adder_to_decoder_iadder_out),
    .load_unsigned_in(from_decoder_to_reg_block_2_load_unsigned_out),
    .load_size_in(from_decoder_to_reg_block_2_load_size_out),
    .lu_output_out(from_load_unit_wb_mux_sel_unit_lu_output_out)
);
msrv32_alu alu(
    .op_1_in(from_csr_file_to_reg_block_2_csr_data_in),
    .op_2_in(from_op_2_in_to_alu_2nd_src_mux_out),
    .opcode_in(from_instruction_mux_to_decoder_opcode_out),
    .result_out(from_alu_to_wb_mux_sel_alu_result_in)
);

msrv32_wb_mux_sel_unit wbmuxunit(
    .alu_src_reg_in(from_reg_block_2_wb_mux_sel_unit_alu_src_reg_in),
    .wb_mux_sel_reg_in(from_reg_block_2_wb_mux_sel_unit_wb_mux_sel_reg_in),
    .alu_result_in(from_alu_to_wb_mux_sel_alu_result_in),
    .lu_output_in(from_load_unit_wb_mux_sel_unit_lu_output_out),
    .imm_reg_in(from_csr_file_to_reg_block_2_csr_uimm_in),
    .iadder_out_reg_in(from_csr_file_to_reg_block_2_iadder_in),
    .csr_data_in(from_csr_file_to_reg_block_2_csr_data_in),
    .pc_plus_4_reg_in(from_reg_block_2_wb_mux_sel_unit_pc_plus_4_reg_in),
    .rs2_reg_in(from_reg_block_2_wb_mux_sel_unit_rs2_reg_in),
    .wb_mux_out(),
    .alu_2nd_src_mux_out(from_op_2_in_to_alu_2nd_src_mux_out)
);



endmodule
