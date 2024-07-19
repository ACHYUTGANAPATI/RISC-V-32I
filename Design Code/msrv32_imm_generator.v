`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Maven Silicon - VIT Vellore
// Engineer: VLSI Design
// 
// Create Date: 25.06.2024 21:06:29
// Design Name: Immediate Generator
// Module Name: msrv32_imm_generator
// Project Name: RISC -V 32I
// Target Devices: 
// Tool Versions: Achyut's Vivado
// Description: 
// Design Verilog code
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module msrv32_imm_generator(instr_in, imm_type_in, imm_out);
input [31:0] instr_in;
input [2:0] imm_type_in;
output reg [31:0] imm_out;
reg [31:0] i_type;
reg [31:0] s_type;
reg [31:0] b_type;
reg [31:0] u_type;
reg [31:0] j_type;
reg [31:0] csr_type;

always @(*)
begin
    i_type <= {{20{instr_in[31]}}, instr_in[31:20]};
    s_type <={{20{instr_in[31]}}, instr_in[31:25], instr_in[11:7]};
    b_type <={{20{instr_in[31]}}, instr_in[7], instr_in[30 :25], instr_in[11:8],1'b0};
    u_type <={instr_in[31 :12],12'h000};
    j_type <= {{12{instr_in[31]}}, instr_in[19:12], instr_in[20], instr_in[30:21], 1'b0};
    csr_type <={27'b0,instr_in[19:15]};
end
always @(*)
begin
    case(imm_type_in)
        3'b000 : imm_out <= i_type;
        3'b001 : imm_out <= i_type;
        3'b010 : imm_out <= s_type;
        3'b011 : imm_out <= b_type;
        3'b100 : imm_out <= u_type;
        3'b101 : imm_out <= j_type;
        3'b110 : imm_out <= csr_type;
        3'b111 : imm_out <= i_type;
        default :imm_out <= i_type;
    endcase
end
endmodule
