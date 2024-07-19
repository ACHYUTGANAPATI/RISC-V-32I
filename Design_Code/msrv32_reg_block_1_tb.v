`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Maven Silicon - VIT Vellore
// Engineer: VLSI Design
// 
// Create Date: 27.06.2024 14:17:43
// Design Name: Reg Block 1
// Module Name: msrv32_reg_block_1_tb
// Project Name: RISC- V 32I
// Target Devices: 
// Tool Versions: Achyut's vivado 
// Description: 
// Testbench code 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module msrv32_reg_block_1_tb;
// Inputs
    reg [31:0] pc_mux_in;
    reg ms_riscv32_mp_clk_in;
    reg ms_riscv32_mp_rst_in;

    // Outputs
    wire [31:0] pc_out;
    
msrv32_reg_block_1 uut (
        .pc_mux_in(pc_mux_in),
        .ms_riscv32_mp_clk_in(ms_riscv32_mp_clk_in),
        .ms_riscv32_mp_rst_in(ms_riscv32_mp_rst_in),
        .pc_out(pc_out)
    );
    always #5 ms_riscv32_mp_clk_in = ~ms_riscv32_mp_clk_in;
    initial begin
        // Initialize Inputs
        pc_mux_in = 0;
        ms_riscv32_mp_clk_in = 0;
        ms_riscv32_mp_rst_in = 0;

        // Wait for global reset to finish
        #10;

        // Apply reset
        ms_riscv32_mp_rst_in = 1;
        #10;
        ms_riscv32_mp_rst_in = 0;
        #10;

        // Test Case 1: Apply a value to pc_mux_in
        pc_mux_in = 32'h00000130;
        #10;
        pc_mux_in = 32'h00000013;
        #10;

        // Test Case 2: Apply reset while pc_mux_in is non-zero
        ms_riscv32_mp_rst_in = 1;
        #10;
        ms_riscv32_mp_rst_in = 0;
        #10;

        // Test Case 3: Apply another value to pc_mux_in
        pc_mux_in = 32'hFFFFFFFF;
        #10;

        // Test Case 4: Apply another reset
        ms_riscv32_mp_rst_in = 1;
        #10;
        ms_riscv32_mp_rst_in = 0;
        #10;
        pc_mux_in = 32'h00044430;
        #10;
        pc_mux_in = 32'h02300013;
        #10;
        ms_riscv32_mp_rst_in = 1;
        #10;
        ms_riscv32_mp_rst_in = 0;
        #10;

        // Finish the simulation
        $stop;
    end
      
endmodule
