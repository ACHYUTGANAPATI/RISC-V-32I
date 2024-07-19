`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: maven silicon - VIT Vellore
// Engineer: VLSI Design
// 
// Create Date: 12.07.2024 10:13:36
// Design Name: Regblock 2
// Module Name: msrv32_reg_block_2_tb
// Project Name: RISC V32I
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


module msrv32_reg_block_2_tb;
reg [6:0] rd_addr_in;
    reg [6:0] csr_addr_in;
    reg [6:0] rs1_in;
    reg [6:0] rs2_in;
    reg [6:0] pc_in;
    reg [6:0] pc_plus_4_in;
    reg [6:0] alu_opcode_in;
    reg [6:0] load_size_in;
    reg [6:0] load_unsigned_in;
    reg [6:0] alu_src_in;
    reg [6:0] csr_wr_en_in;
    reg [6:0] rf_wr_en_in;
    reg [6:0] wb_mux_sel_in;
    reg [6:0] csr_op_in;
    reg [6:0] imm_in;
    reg [6:0] iadder_out_in;
    reg branch_taken_in;
    reg reset_in;
    reg clk_in;
    wire [6:0] rd_addr_reg_out;
    wire [6:0] csr_addr_reg_out;
    wire [6:0] rs1_reg_out;
    wire [6:0] rs2_reg_out;
    wire [6:0] pc_reg_out;
    wire [6:0] pc_plus_reg_out;
    wire [6:0] alu_opcode_reg_out;
    wire [6:0] load_size_reg_out;
    wire [6:0] load_unsigned_reg_out;
    wire [6:0] alu_src_reg_out;
    wire [6:0] csr_wr_en_reg_out;
    wire [6:0] rf_wr_en_reg_out;
    wire [6:0] wb_mux_sel_reg_out;
    wire [6:0] csr_op_reg_out;
    wire [6:0] imm_reg_out;
    wire [6:0] iadder_out_reg_out;

    msrv32_reg_block_2 uut (
        .rd_addr_in(rd_addr_in),
        .csr_addr_in(csr_addr_in),
        .rs1_in(rs1_in),
        .rs2_in(rs2_in),
        .pc_in(pc_in),
        .pc_plus_4_in(pc_plus_4_in),
        .alu_opcode_in(alu_opcode_in),
        .load_size_in(load_size_in),
        .load_unsigned_in(load_unsigned_in),
        .alu_src_in(alu_src_in),
        .csr_wr_en_in(csr_wr_en_in),
        .rf_wr_en_in(rf_wr_en_in),
        .wb_mux_sel_in(wb_mux_sel_in),
        .csr_op_in(csr_op_in),
        .imm_in(imm_in),
        .iadder_out_in(iadder_out_in),
        .branch_taken_in(branch_taken_in),
        .reset_in(reset_in),
        .clk_in(clk_in),
        .rd_addr_reg_out(rd_addr_reg_out),
        .csr_addr_reg_out(csr_addr_reg_out),
        .rs1_reg_out(rs1_reg_out),
        .rs2_reg_out(rs2_reg_out),
        .pc_reg_out(pc_reg_out),
        .pc_plus_reg_out(pc_plus_reg_out),
        .alu_opcode_reg_out(alu_opcode_reg_out),
        .load_size_reg_out(load_size_reg_out),
        .load_unsigned_reg_out(load_unsigned_reg_out),
        .alu_src_reg_out(alu_src_reg_out),
        .csr_wr_en_reg_out(csr_wr_en_reg_out),
        .rf_wr_en_reg_out(rf_wr_en_reg_out),
        .wb_mux_sel_reg_out(wb_mux_sel_reg_out),
        .csr_op_reg_out(csr_op_reg_out),
        .imm_reg_out(imm_reg_out),
        .iadder_out_reg_out(iadder_out_reg_out)
    );

    initial begin
        clk_in = 0;
        reset_in = 1;
        #10;
        reset_in = 0;
        #10;

        // Test case 1
        rd_addr_in = 7'b0000001;
        csr_addr_in = 7'b0000010;
        rs1_in = 7'b0000011;
        rs2_in = 7'b0000100;
        pc_in = 7'b0000101;
        pc_plus_4_in = 7'b0000110;
        alu_opcode_in = 7'b0000111;
        load_size_in = 7'b0001000;
        load_unsigned_in = 7'b0001001;
        alu_src_in = 7'b0001010;
        csr_wr_en_in = 7'b0001011;
        rf_wr_en_in = 7'b0001100;
        wb_mux_sel_in = 7'b0001101;
        csr_op_in = 7'b0001110;
        imm_in = 7'b0001111;
        iadder_out_in = 7'b0010000;
        branch_taken_in = 0;
        #20;

        // Test case 2
        rd_addr_in = 7'b0010001;
        csr_addr_in = 7'b0010010;
        rs1_in = 7'b0010011;
        rs2_in = 7'b0010100;
        pc_in = 7'b0010101;
        pc_plus_4_in = 7'b0010110;
        alu_opcode_in = 7'b0010111;
        load_size_in = 7'b0011000;
        load_unsigned_in = 7'b0011001;
        alu_src_in = 7'b0011010;
        csr_wr_en_in = 7'b0011011;
        rf_wr_en_in = 7'b0011100;
        wb_mux_sel_in = 7'b0011101;
        csr_op_in = 7'b0011110;
        imm_in = 7'b0011111;
        iadder_out_in = 7'b0100000;
        branch_taken_in = 1;
        #20;

        // Test case 3
        rd_addr_in = 7'b0100001;
        csr_addr_in = 7'b0100010;
        rs1_in = 7'b0100011;
        rs2_in = 7'b0100100;
        pc_in = 7'b0100101;
        pc_plus_4_in = 7'b0100110;
        alu_opcode_in = 7'b0100111;
        load_size_in = 7'b0101000;
        load_unsigned_in = 7'b0101001;
        alu_src_in = 7'b0101010;
        csr_wr_en_in = 7'b0101011;
        rf_wr_en_in = 7'b0101100;
        wb_mux_sel_in = 7'b0101101;
        csr_op_in = 7'b0101110;
        imm_in = 7'b0101111;
        iadder_out_in = 7'b0110000;
        branch_taken_in = 0;
        #20;

        // Test case 4
        rd_addr_in = 7'b0110001;
        csr_addr_in = 7'b0110010;
        rs1_in = 7'b0110011;
        rs2_in = 7'b0110100;
        pc_in = 7'b0110101;
        pc_plus_4_in = 7'b0110110;
        alu_opcode_in = 7'b0110111;
        load_size_in = 7'b0111000;
        load_unsigned_in = 7'b0111001;
        alu_src_in = 7'b0111010;
        csr_wr_en_in = 7'b0111011;
        rf_wr_en_in = 7'b0111100;
        wb_mux_sel_in = 7'b0111101;
        csr_op_in = 7'b0111110;
        imm_in = 7'b0111111;
        iadder_out_in = 7'b1000000;
        branch_taken_in = 1;
        #20;

        // Test case 5
        rd_addr_in = 7'b1000001;
        csr_addr_in = 7'b1000010;
        rs1_in = 7'b1000011;
        rs2_in = 7'b1000100;
        pc_in = 7'b1000101;
        pc_plus_4_in = 7'b1000110;
        alu_opcode_in = 7'b1000111;
        load_size_in = 7'b1001000;
        load_unsigned_in = 7'b1001001;
        alu_src_in = 7'b1001010;
        csr_wr_en_in = 7'b1001011;
        rf_wr_en_in = 7'b1001100;
        wb_mux_sel_in = 7'b1001101;
        csr_op_in = 7'b1001110;
        imm_in = 7'b1001111;
        iadder_out_in = 7'b1010000;
        branch_taken_in = 0;
        #20;

        $finish;
    end

    always #5 clk_in = ~clk_in;
endmodule
