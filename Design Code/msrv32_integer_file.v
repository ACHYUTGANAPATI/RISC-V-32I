`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 29.06.2024 09:00:42
// Design Name: 
// Module Name: msrv32_integer_file
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


module msrv32_integer_file(ms_riscv32_mp_clk_in, ms_riscv32_mp_rst_in, rs_2_addr_in, rd_addr_in, wr_en_in, rd_in, rs_1_addr_in, rs_1_out, rs_2_out);
input ms_riscv32_mp_clk_in ;
input ms_riscv32_mp_rst_in;
input [4:0]rs_2_addr_in;
input [4:0]rd_addr_in;
input wr_en_in;
input [31:0]rd_in;
input [4:0]rs_1_addr_in;

output reg [31:0] rs_1_out;
output reg [31:0] rs_2_out;
reg [31:0] rs1_out;
reg [31:0] rs2_out;
wire mux_rs1_en;
wire mux_rs2_en;
reg [31:0] intgrfile_regflie [31:0];
always @(posedge ms_riscv32_mp_clk_in or posedge ms_riscv32_mp_rst_in)
begin
    if(ms_riscv32_mp_rst_in) 
    begin
        rs_1_out  <=1'b0;
        rs_2_out <= 1'b0;
    end
    else
    begin
        if(wr_en_in)
        begin
            intgrfile_regflie[rd_addr_in]  = rd_in;
        end
        end
end
 always @(*) begin
        if (ms_riscv32_mp_rst_in) begin
            rs1_out = 32'b0;
            rs2_out = 32'b0;
        end else begin
            rs1_out = intgrfile_regflie[rs_1_addr_in];
            rs2_out = intgrfile_regflie[rs_2_addr_in];
        end
    end
assign mux_rs1_en = (rs_1_addr_in == rd_addr_in && wr_en_in == 1'b1) ? 1'b1 : 1'b0;
assign mux_rs2_en = (rs_2_addr_in == rd_addr_in && wr_en_in == 1'b1) ? 1'b1 : 1'b0;
always @(rs1_out or rs2_out)
begin
        rs_1_out = (mux_rs1_en)? rd_in : rs1_out;
        rs_2_out = (mux_rs2_en)? rd_in : rs2_out;
    end 
endmodule
