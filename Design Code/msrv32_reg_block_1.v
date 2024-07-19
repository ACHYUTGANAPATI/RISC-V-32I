`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Maven Silicon - VIT Vellore
// Engineer: VLSI Design
// 
// Create Date: 25.06.2024 20:00:04
// Design Name: Reg Block 1
// Module Name: msrv32_reg_block_1
// Project Name:  RISC -V 32I
// Target Devices: 
// Tool Versions: Achyut's vivado
// Description: 
// Design file
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module msrv32_reg_block_1(pc_mux_in,ms_riscv32_mp_clk_in,ms_riscv32_mp_rst_in,pc_out);
input [31:0] pc_mux_in;
input ms_riscv32_mp_clk_in;
input ms_riscv32_mp_rst_in;
output reg [31:0] pc_out;
always @(posedge ms_riscv32_mp_clk_in or posedge ms_riscv32_mp_rst_in)
begin
        if(ms_riscv32_mp_rst_in)
            pc_out <=32'h00000000;
        else
            pc_out <= pc_mux_in;
end

endmodule
