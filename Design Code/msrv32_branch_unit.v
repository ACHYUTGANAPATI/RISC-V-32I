`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 29.06.2024 12:15:46
// Design Name: 
// Module Name: msrv32_branch_unit
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


module msrv32_branch_unit(rs1_in,rs2_in, opecode_in,funct3_in,branch_taken_out);
input [31:0] rs1_in;
input [31:0] rs2_in;
input [6:0]  opecode_in;
input [2:0] funct3_in;
output reg branch_taken_out;
wire signed[31:0] rs1,rs2;
assign rs1= rs1_in;
assign rs2= rs2_in;
always @(*)
begin
    case(opecode_in[6:2])
    5'b11000: begin
        case(funct3_in)
            3'b000 : branch_taken_out = (rs1_in == rs2_in);
            3'b001 : branch_taken_out = (rs1_in != rs2_in);
            3'b100 : branch_taken_out = (rs1 <rs2);
            3'b101 : branch_taken_out = (rs1 >=rs2);
            3'b110 : branch_taken_out = (rs1_in < rs2_in);
            3'b111 : branch_taken_out = (rs1_in >= rs2_in);
            default :branch_taken_out =0;
         endcase
    end
    5'b11011: branch_taken_out=1; //jal
    5'b11001:branch_taken_out =1; //jalr 
    default :branch_taken_out =0;
    endcase
end
endmodule
