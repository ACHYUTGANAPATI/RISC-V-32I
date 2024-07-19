`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Maven Silicon
// Engineer: VLSI Design
// 
// Create Date: 27.06.2024 20:38:59
// Design Name: Immediate adder
// Module Name: msrv32_immediate_adder_tb
// Project Name: RISC -V 32I
// Target Devices: 
// Tool Versions: Achyut's Vivado 
// Description: 
// Simulation code
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module msrv32_immediate_adder_tb;
reg [31:0] pc_in;
reg [31:0] rs_1_in;
reg iadder_src_in;
reg [31:0] imm_in;

// Outputs
wire [31:0] iadder_out;

// Instantiate the Unit Under Test (UUT)
msrv32_immediate_adder uut (
    .pc_in(pc_in), 
    .rs_1_in(rs_1_in), 
    .iadder_src_in(iadder_src_in), 
    .imm_in(imm_in), 
    .iadder_out(iadder_out)
);
initial begin
    // Initialize Inputs
    pc_in = 32'h00000000;
    rs_1_in = 32'h00000000;
    iadder_src_in = 0;
    imm_in = 32'h00000000;
    // Wait for global reset to finish
    #30;
    
    pc_in = 32'h12233435;
    rs_1_in = 32'hAAAAAA00;
    iadder_src_in = 1;
    imm_in = 32'hD;
    #10;
    pc_in = 32'h12233435;
    rs_1_in = 32'hAAAAAA00;
    iadder_src_in = 0;
    imm_in = 32'h12345678;
    #10;
    pc_in = 32'hABCD1234;
    rs_1_in = 32'hFADBC123;
    iadder_src_in = 0;
    imm_in = 32'h100A00D;
    #10;
    pc_in = 32'hABCD1234;
    rs_1_in = 32'hFADBC123;
    iadder_src_in = 1;
    imm_in = 32'h100A00D;
    #10;
    
    pc_in = 32'h00000010;
    imm_in = 32'h00000004;
    iadder_src_in = 0; // Select pc_in
    #10;
    
    rs_1_in = 32'h00000020;
    imm_in = 32'h00000008;
    iadder_src_in = 1; // Select rs_1_in
    #10;
    
    // Test Case 3: Add imm_in to pc_in with different values
    pc_in = 32'h00000030;
    imm_in = 32'h00000010;
    iadder_src_in = 0; // Select pc_in
    #10;
    
    // Test Case 4: Add imm_in to rs_1_in with different values
    rs_1_in = 32'h00000040;
    imm_in = 32'h00000020;
    iadder_src_in = 1; // Select rs_1_in
    #10;

    // Add more test cases as needed
    
    $finish;
end
    
    
endmodule
