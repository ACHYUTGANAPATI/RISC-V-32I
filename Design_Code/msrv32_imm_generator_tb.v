`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Maven Silicon - VIT Vellore
// Engineer: VLSI Design
// 
// Create Date: 27.06.2024 18:56:29
// Design Name: Immediate generator 
// Module Name: msrv32_imm_generator_tb
// Project Name: RISC -V 32I
// Target Devices: 
// Tool Versions: Achyut's vivado
// Description: 
// Simulation testbench verilog code
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module msrv32_imm_generator_tb;
reg [31:0] instr_in;
reg [2:0] imm_type_in;

// Outputs
wire [31:0] imm_out;

// Instantiate the Unit Under Test (UUT)
msrv32_imm_generator uut (
    .instr_in(instr_in), 
    .imm_type_in(imm_type_in), 
    .imm_out(imm_out)
);
initial 
begin
      instr_in = 32'b0;
      imm_type_in = 3'b0;
      #20;
      instr_in = 32'h81234567;
      imm_type_in = 3'b000;
      #10;
      imm_type_in = 3'b010;
      #10;
      imm_type_in = 3'b001;
      #10;
      imm_type_in = 3'b011;
      #10;
      imm_type_in = 3'b100;
      #10;
      imm_type_in = 3'b110;
      #10;
      imm_type_in = 3'b111;
      #30;
      instr_in = 32'hFF23AB35;
      imm_type_in = 3'b000;
      #10;
      imm_type_in = 3'b010;
      #10;
      imm_type_in = 3'b001;
      #10;
      imm_type_in = 3'b011;
      #10;
      imm_type_in = 3'b100;
      #10;
      imm_type_in = 3'b110;
      #10;
      imm_type_in = 3'b111;
      #30;
      instr_in = 32'h11111111;
      imm_type_in = 3'b000;
      #10;
      imm_type_in = 3'b010;
      #10;
      imm_type_in = 3'b001;
      #10;
      imm_type_in = 3'b011;
      #10;
      imm_type_in = 3'b100;
      #10;
      imm_type_in = 3'b110;
      #10;
      imm_type_in = 3'b111;
      #30;
      instr_in = 32'hABCDE13F;
      imm_type_in = 3'b000;
      #10;
      imm_type_in = 3'b010;
      #10;
      imm_type_in = 3'b001;
      #10;
      imm_type_in = 3'b011;
      #10;
      imm_type_in = 3'b100;
      #10;
      imm_type_in = 3'b110;
      #10;
      imm_type_in = 3'b111;
      #30;
      $finish;
end
endmodule
