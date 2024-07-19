`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Maven Silicon
// Engineer: VLSI Design
// 
// Create Date: 26.06.2024 21:39:59
// Design Name: Immediate adder
// Module Name: msrv32_immediate_adder_tb
// Project Name: RISC -V 32I
// Target Devices: 
// Tool Versions: Achyut's Vivado 
// Description: 
// Dependencies: 
// RTL Design Code
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module msrv32_immediate_adder(pc_in,rs_1_in, iadder_src_in, imm_in,iadder_out);
input [31:0] pc_in;
input [31:0] rs_1_in;
input iadder_src_in;
input [31:0] imm_in;
output [31:0] iadder_out;
reg [31:0] mux_out;
always @(*) begin
    case(iadder_src_in)
        1'b0 : mux_out = pc_in;
        1'b1 : mux_out = rs_1_in;
        default: mux_out = 32'b0; // Add default case to avoid latches
    endcase
end

assign iadder_out = mux_out + imm_in;
endmodule
