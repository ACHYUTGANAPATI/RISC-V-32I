`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12.07.2024 13:16:13
// Design Name: 
// Module Name: msrv32_main_block_tb
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


module msrv32_main_block_tb;
    reg ms_riscv32_mp_clk_in;
    reg ms_riscv32_mp_rst_in;
    reg ahb_ready_in;
    reg [31:0] ms_riscv32_mp_dmdata_in;
    reg [31:0] ms_riscv32_mp_instr_in;
    reg ahb_resp_in;
    reg [63:0] ms_riscv32_mp_rc_in;
    reg ms_riscv32_mp_eirq_in;
    reg ms_riscv32_mp_tirq_in;
    reg ms_riscv32_mp_sirq_in;

    // Outputs
    wire ms_riscv32_mp_dmwr_req_out;
    wire [31:0] ms_riscv32_mp_imaddr_out;
    wire [31:0] ms_riscv32_mp_dmaddr_out;
    wire [31:0] ms_riscv32_mp_dmdata_out;
    wire [3:0] ms_riscv32_mp_dmwr_mask_out;
    wire [1:0] ahb_htrans_out;

    // Instantiate the Unit Under Test (UUT)
    msrv32_main_block uut (
        .ms_riscv32_mp_clk_in(ms_riscv32_mp_clk_in),
        .ms_riscv32_mp_rst_in(ms_riscv32_mp_rst_in),
        .ahb_ready_in(ahb_ready_in),
        .ms_riscv32_mp_dmdata_in(ms_riscv32_mp_dmdata_in),
        .ms_riscv32_mp_instr_in(ms_riscv32_mp_instr_in),
        .ahb_resp_in(ahb_resp_in),
        .ms_riscv32_mp_rc_in(ms_riscv32_mp_rc_in),
        .ms_riscv32_mp_eirq_in(ms_riscv32_mp_eirq_in),
        .ms_riscv32_mp_tirq_in(ms_riscv32_mp_tirq_in),
        .ms_riscv32_mp_sirq_in(ms_riscv32_mp_sirq_in),
        .ms_riscv32_mp_dmwr_req_out(ms_riscv32_mp_dmwr_req_out),
        .ms_riscv32_mp_imaddr_out(ms_riscv32_mp_imaddr_out),
        .ms_riscv32_mp_dmaddr_out(ms_riscv32_mp_dmaddr_out),
        .ms_riscv32_mp_dmdata_out(ms_riscv32_mp_dmdata_out),
        .ms_riscv32_mp_dmwr_mask_out(ms_riscv32_mp_dmwr_mask_out),
        .ahb_htrans_out(ahb_htrans_out)
    );

    // Clock generation
    always #5 ms_riscv32_mp_clk_in = ~ms_riscv32_mp_clk_in;

    initial begin
        // Initialize Inputs
        ms_riscv32_mp_clk_in = 0;
        ms_riscv32_mp_rst_in = 1;
        ahb_ready_in = 0;
        ms_riscv32_mp_dmdata_in = 0;
        ms_riscv32_mp_instr_in = 0;
        ahb_resp_in = 0;
        ms_riscv32_mp_rc_in = 0;
        ms_riscv32_mp_eirq_in = 0;
        ms_riscv32_mp_tirq_in = 0;
        ms_riscv32_mp_sirq_in = 0;

        // Wait for global reset to finish
        #100;

        // Reset deassert
        ms_riscv32_mp_rst_in = 0;

        // Apply test cases
        #20;
        ms_riscv32_mp_instr_in = 32'h00000093; // NOP instruction
        #40;
        ms_riscv32_mp_instr_in = 32'h00100093; // ADDI x1, x0, 1
        #40;
        ms_riscv32_mp_instr_in = 32'h00200093; // ADDI x1, x0, 2
        #40;
        ms_riscv32_mp_instr_in = 32'h00300093; // ADDI x1, x0, 3
        #40;
        ms_riscv32_mp_eirq_in = 1; // External interrupt
        #40;
        ms_riscv32_mp_eirq_in = 0;
        #40;

        // More test cases can be added here

        // Finish simulation
        #100;
        $stop;
    end
endmodule
