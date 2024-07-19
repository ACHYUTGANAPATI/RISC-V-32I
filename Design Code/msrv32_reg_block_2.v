`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Maven Silicon - VIT Vellore
// Engineer: VLSI Design
// 
// Create Date: 03.07.2024 20:35:55
// Design Name: Reg block 2
// Module Name: msrv32_reg_block_2
// Project Name: RISC V 32I
// Target Devices: 
// Tool Versions: Achyut's Vivado
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module msrv32_reg_block_2 (
    input [6:0] rd_addr_in,
    input [6:0] csr_addr_in,
    input [6:0] rs1_in,
    input [6:0] rs2_in,
    input [6:0] pc_in,
    input [6:0] pc_plus_4_in,
    input [6:0] alu_opcode_in,
    input [6:0] load_size_in,
    input [6:0] load_unsigned_in,
    input [6:0] alu_src_in,
    input [6:0] csr_wr_en_in,
    input [6:0] rf_wr_en_in,
    input [6:0] wb_mux_sel_in,
    input [6:0] csr_op_in,
    input [6:0] imm_in,
    input [6:0] iadder_out_in,
    input branch_taken_in,
    input reset_in,
    input clk_in,
    output reg [6:0] rd_addr_reg_out,
    output reg [6:0] csr_addr_reg_out,
    output reg [6:0] rs1_reg_out,
    output reg [6:0] rs2_reg_out,
    output reg [6:0] pc_reg_out,
    output reg [6:0] pc_plus_reg_out,
    output reg [6:0] alu_opcode_reg_out,
    output reg [6:0] load_size_reg_out,
    output reg [6:0] load_unsigned_reg_out,
    output reg [6:0] alu_src_reg_out,
    output reg [6:0] csr_wr_en_reg_out,
    output reg [6:0] rf_wr_en_reg_out,
    output reg [6:0] wb_mux_sel_reg_out,
    output reg [6:0] csr_op_reg_out,
    output reg [6:0] imm_reg_out,
    output reg [6:0] iadder_out_reg_out
);

always @(posedge clk_in or posedge reset_in) begin
    if (reset_in) begin
        rd_addr_reg_out <= 7'b0;
        csr_addr_reg_out <= 7'b0;
        rs1_reg_out <= 7'b0;
        rs2_reg_out <= 7'b0;
        pc_reg_out <= 7'b0;
        pc_plus_reg_out <= 7'b0;
        alu_opcode_reg_out <= 7'b0;
        load_size_reg_out <= 7'b0;
        load_unsigned_reg_out <= 7'b0;
        alu_src_reg_out <= 7'b0;
        csr_wr_en_reg_out <= 7'b0;
        rf_wr_en_reg_out <= 7'b0;
        wb_mux_sel_reg_out <= 7'b0;
        csr_op_reg_out <= 7'b0;
        imm_reg_out <= 7'b0;
        iadder_out_reg_out <= 7'b0;
    end else begin
        rd_addr_reg_out <= rd_addr_in;
        csr_addr_reg_out <= csr_addr_in;
        rs1_reg_out <= rs1_in;
        rs2_reg_out <= rs2_in;
        pc_reg_out <= pc_in;
        pc_plus_reg_out <= pc_plus_4_in;
        alu_opcode_reg_out <= alu_opcode_in;
        load_size_reg_out <= load_size_in;
        load_unsigned_reg_out <= load_unsigned_in;
        alu_src_reg_out <= alu_src_in;
        csr_wr_en_reg_out <= csr_wr_en_in;
        rf_wr_en_reg_out <= rf_wr_en_in;
        wb_mux_sel_reg_out <= wb_mux_sel_in;
        csr_op_reg_out <= csr_op_in;
        imm_reg_out <= imm_in;
        iadder_out_reg_out <= (branch_taken_in) ? 1'b0 : iadder_out_in[0];
    end
end

endmodule
