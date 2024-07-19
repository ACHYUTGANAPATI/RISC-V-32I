`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.06.2024 17:06:31
// Design Name: 
// Module Name: msrv32_pc
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


module msrv32_pc(rst_in, pc_src_in, epc_in, trap_address_in,branch_taken_in,iaddr_in, ahb_ready_in,pc_in,iaddr_out,pc_plus_4_out,misaligned_instr_logic_out,pc_mux_out);
input rst_in;
input [1:0] pc_src_in;
input [31:0] epc_in;
input [31:0] trap_address_in;
input branch_taken_in;
input [30:0] iaddr_in;
input ahb_ready_in;
input [31:0] pc_in;


output [31:0] iaddr_out;
output [31:0] pc_plus_4_out;
output misaligned_instr_logic_out;
output reg [31:0] pc_mux_out;
//wire iaddr_in_concat;
reg [31:0] next_pc;
wire [31:0] muxtomux;
reg [31:0] boot_address;
//assign iaddr_in_concat = {iaddr_in[30:0],1'b0};
assign pc_plus_4_out = pc_in[31:0] +4;
//next_pc = branch_taken_in ? iaddr_in_concat : pc_plus_4_out;
always @(*)
begin
    next_pc = branch_taken_in ? {iaddr_in[30:0],1'b0} : pc_plus_4_out;
    boot_address = 32'h00000000;
    case(pc_src_in)
        2'b00 : pc_mux_out <= boot_address;
        2'b01: pc_mux_out <= epc_in;
        2'b10 : pc_mux_out <= trap_address_in;
        2'b11 : pc_mux_out <= next_pc;
        default :pc_mux_out = 1'b0;
    endcase
end
//assign pc_mux_out =(pc_src_in==2'b00) ?boot_address:
//    (pc_src_in==2'b01)? epc_in:
//   (pc_src_in==2'b10)? trap_address_in: next_pc;
assign muxtomux = (ahb_ready_in)? pc_mux_out :iaddr_out;
assign iaddr_out = (rst_in)? boot_address:muxtomux;

assign misaligned_instr_logic_out = next_pc[0] & branch_taken_in;
endmodule
