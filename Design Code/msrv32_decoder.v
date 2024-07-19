`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: maven silicon - VIT Vellore
// Engineer: Maven Silicon
// 
// Create Date: 08.07.2024 19:38:34
// Design Name: Decoder
// Module Name: msrv32_decoder
// Project Name: RISC V 32I
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


module msrv32_decoder(trap_taken_in, funct7_5_in, opcode_in, funct3_in, iadder_out_1_to_0_in, wb_mux_sel_out, imm_type_out, csr_op_out, mem_wr_req_out, alu_opcode_out, load_size_out, load_unsigned_out, alu_src_out, iadder_src_out,csr_wr_en_out, rf_wr_en_out, illegal_instr_out, misaligned_load_out, misaligned_store_out);
input trap_taken_in;
input funct7_5_in;
input [6:0] opcode_in;
input [2:0] funct3_in;
input [1:0] iadder_out_1_to_0_in;

output [2:0] wb_mux_sel_out;
output [2:0] imm_type_out;
output [2:0] csr_op_out;
output mem_wr_req_out;
output [3:0] alu_opcode_out;
output [1:0] load_size_out;
output load_unsigned_out;
output alu_src_out;
output iadder_src_out;
output csr_wr_en_out;
output rf_wr_en_out;
output illegal_instr_out;
output misaligned_load_out;
output misaligned_store_out;
reg is_branch,is_jal, is_jalr , is_auipc, is_lui, is_op, is_op_imm,is_load,is_store,is_system, is_misc_mem;
reg is_addi,is_slti, is_sltiu, is_andi , is_ori, is_xori;
wire alu_opcode_out_3_wire;
wire csr_or_wire;
wire is_csr;
wire is_implimented_instr;
wire mal_word;
wire mal_half;
wire misaligned;
always @(*)
begin
    case(opcode_in[6:0])
        5'b01100 :{is_op, is_op_imm, is_load, is_store,  is_branch, is_jal, is_jalr, is_lui, is_auipc, is_misc_mem, is_system} =11'b10000000000;
        5'b00100 :{is_op, is_op_imm, is_load, is_store,  is_branch, is_jal, is_jalr, is_lui, is_auipc, is_misc_mem, is_system} =11'b01000000000;
        5'b00000 :{is_op, is_op_imm, is_load, is_store,  is_branch, is_jal, is_jalr, is_lui, is_auipc, is_misc_mem, is_system} =11'b00100000000;
        5'b01000 :{is_op, is_op_imm, is_load, is_store,  is_branch, is_jal, is_jalr, is_lui, is_auipc, is_misc_mem, is_system} =11'b00010000000;
        5'b11000 :{is_op, is_op_imm, is_load, is_store,  is_branch, is_jal, is_jalr, is_lui, is_auipc, is_misc_mem, is_system} =11'b00001000000;
        5'b11011 :{is_op, is_op_imm, is_load, is_store,  is_branch, is_jal, is_jalr, is_lui, is_auipc, is_misc_mem, is_system} =11'b00000100000;
        5'b11001 :{is_op, is_op_imm, is_load, is_store,  is_branch, is_jal, is_jalr, is_lui, is_auipc, is_misc_mem, is_system} =11'b00000010000;
        5'b01101 :{is_op, is_op_imm, is_load, is_store,  is_branch, is_jal, is_jalr, is_lui, is_auipc, is_misc_mem, is_system} =11'b00000001000;
        5'b00101 :{is_op, is_op_imm, is_load, is_store,  is_branch, is_jal, is_jalr, is_lui, is_auipc, is_misc_mem, is_system} =11'b00000000100;
        5'b00011 :{is_op, is_op_imm, is_load, is_store,  is_branch, is_jal, is_jalr, is_lui, is_auipc, is_misc_mem, is_system} =11'b00000000010;
        5'b11100 :{is_op, is_op_imm, is_load, is_store,  is_branch, is_jal, is_jalr, is_lui, is_auipc, is_misc_mem, is_system} =11'b00000000001;
        default    :{is_op, is_op_imm, is_load, is_store,  is_branch, is_jal, is_jalr, is_lui, is_auipc, is_misc_mem, is_system} =11'b00000000000;
    endcase
end
always @*
begin
case(funct3_in)
    3'b000: {is_addi, is_slti, is_sltiu, is_andi, is_ori, is_xori} = {is_op_imm, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0};
    3'b010: {is_addi, is_slti, is_sltiu, is_andi, is_ori, is_xori} = {1'b0, is_op_imm, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0};
    3'b011: {is_addi, is_slti, is_sltiu, is_andi, is_ori, is_xori} = {1'b0, 1'b0, is_op_imm, 1'b0, 1'b0, 1'b0, 1'b0};
    3'b111: {is_addi, is_slti, is_sltiu, is_andi, is_ori, is_xori} = {1'b0, 1'b0, 1'b0, is_op_imm, 1'b0, 1'b0, 1'b0};
    3'b110: {is_addi, is_slti, is_sltiu, is_andi, is_ori, is_xori} = {1'b0, 1'b0, 1'b0, 1'b0, is_op_imm, 1'b0, 1'b0};
    3'b100: {is_addi, is_slti, is_sltiu, is_andi, is_ori, is_xori} = {1'b0, 1'b0, 1'b0, 1'b0, 1'b0,  is_op_imm, 1'b0};
    default:{is_addi, is_slti, is_sltiu, is_andi, is_ori, is_xori} =6'b000000;
endcase
end

assign load_size_out = funct3_in[1:0];
assign load_unsigned_out =funct3_in[2];
assign alu_src_out = opcode_in[5];

assign is_csr = is_system & (funct3_in[2] |funct3_in[1]|funct3_in[0]);
assign csr_wr_en_out = is_csr;
assign csr_op_out =funct3_in;

assign iadder_src_out = is_load |is_store|is_jalr;
assign rf_wr_en_out = is_lui |is_auipc|is_jalr|is_jal|is_op|is_load|is_csr|is_op_imm;
assign alu_opcode_out[2:0] = funct3_in;
assign alu_opcode_out[3] = funct7_5_in &~(is_addi |is_slti|is_sltiu|is_andi|is_ori|is_xori);

assign wb_mux_sel_out[0] = is_load|is_auipc|is_jal|is_jalr;
assign wb_mux_sel_out[1] =is_lui|is_auipc;
assign wb_mux_sel_out[2] =is_csr|is_jal|is_jalr;

assign imm_type_out[0] = is_op_imm|is_load|is_jalr|is_branch|is_jal;
assign imm_type_out[1] = is_store|is_branch|is_csr;
assign imm_type_out[2] = is_lui|is_auipc|is_jal|is_csr;

assign is_implimented_instr = is_op|is_op_imm|is_branch|is_jal|is_jalr|is_auipc|is_lui|is_system|is_misc_mem|is_load|is_store;
assign illegal_instr_out =~opcode_in[1]|~opcode_in[0]|~is_implimented_instr;

assign mal_word = funct3_in[1]&~funct3_in[0]&(iadder_out_1_to_0_in[1]|iadder_out_1_to_0_in[0]);
assign mal_word = ~funct3_in[1]&funct3_in[0]&iadder_out_1_to_0_in[0];
assign misaligned = mal_word|mal_half;
assign misaligned_store_out = is_store&misaligned;
assign misaligned_load_out = is_load&misaligned;

assign mem_wr_req_out = is_store&~misaligned&~trap_taken_in;

endmodule
