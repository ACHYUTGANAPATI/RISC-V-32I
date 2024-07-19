`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Maven Silicon - VIT vellore
// Engineer: VLSI Design
// 
// Create Date: 26.06.2024 16:06:47
// Design Name: Write Enable Generator
// Module Name: msrv2_wr_en_generator
// Project Name: RISC -V 32I
// Target Devices: 
// Tool Versions: Achyut's Vivado
// Description: 
// RTL Design code`
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module msrv2_wr_en_generator(flush_in, rf_wr_en_reg_in, csr_wr_en_reg_in, wr_en_int_file_out, wr_en_csr_file_out);
input flush_in;
input rf_wr_en_reg_in;
input csr_wr_en_reg_in;

output wr_en_int_file_out;
output wr_en_csr_file_out;


assign wr_en_int_file_out = (flush_in) ? 1'b0:rf_wr_en_reg_in;
assign  wr_en_csr_file_out = (flush_in) ? 1'b0:csr_wr_en_reg_in;
endmodule
