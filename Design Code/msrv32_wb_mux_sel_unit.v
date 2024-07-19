`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08.07.2024 10:26:08
// Design Name: 
// Module Name: msrv32_wb_mux_sel_unit
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


module msrv32_wb_mux_sel_unit(alu_src_reg_in ,wb_mux_sel_reg_in , alu_result_in, lu_output_in , imm_reg_in, iadder_out_reg_in, csr_data_in, pc_plus_4_reg_in, rs2_reg_in, wb_mux_out, alu_2nd_src_mux_out);
input alu_src_reg_in;
input [2:0]wb_mux_sel_reg_in;
input [31:0] alu_result_in;
input [31:0] lu_output_in;
input [31:0] imm_reg_in;
input [31:0] iadder_out_reg_in;
input [31:0] csr_data_in;
input [31:0] pc_plus_4_reg_in;
input [31:0] rs2_reg_in;
output reg [31:0] wb_mux_out;
output [31:0] alu_2nd_src_mux_out;
assign alu_2nd_src_mux_out = (alu_src_reg_in) ? rs2_reg_in : imm_reg_in;
always  @(*)
begin
    case(wb_mux_sel_reg_in)
        3'b000: wb_mux_out = alu_result_in;
        3'b001: wb_mux_out = lu_output_in;
        3'b010: wb_mux_out = imm_reg_in;
        3'b011: wb_mux_out = iadder_out_reg_in;
        3'b100: wb_mux_out = csr_data_in;
        3'b101: wb_mux_out = pc_plus_4_reg_in;
        3'b110: wb_mux_out = rs2_reg_in;
        default: wb_mux_out = alu_result_in;
    endcase
end



endmodule
