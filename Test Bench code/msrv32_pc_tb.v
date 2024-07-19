`timescale 1ns / 1ps

module msrv32_pc_tb;

  // Inputs
  reg rst_in;
  reg [1:0] pc_src_in;
  reg [31:0] epc_in;
  reg [31:0] trap_address_in;
  reg branch_taken_in;
  reg [30:0] iaddr_in;
  reg ahb_ready_in;
  reg [31:0] pc_in;

  // Outputs
  wire [31:0] iaddr_out;
  wire [31:0] pc_plus_4_out;
  wire misaligned_instr_logic_out;
  wire [31:0] pc_mux_out;

  // Instantiate the Unit Under Test (UUT)
  msrv32_pc uut (
    .rst_in(rst_in), 
    .pc_src_in(pc_src_in), 
    .epc_in(epc_in), 
    .trap_address_in(trap_address_in), 
    .branch_taken_in(branch_taken_in), 
    .iaddr_in(iaddr_in), 
    .ahb_ready_in(ahb_ready_in), 
    .pc_in(pc_in), 
    .iaddr_out(iaddr_out), 
    .pc_plus_4_out(pc_plus_4_out), 
    .misaligned_instr_logic_out(misaligned_instr_logic_out), 
    .pc_mux_out(pc_mux_out)
  );

  initial begin
    // Initialize Inputs
    rst_in = 0;
    pc_src_in = 2'b00;
    epc_in = 32'h00000000;
    trap_address_in = 32'h00000000;
    branch_taken_in = 0;
    iaddr_in = 31'h00000000;
    ahb_ready_in = 0;
    pc_in = 32'h00000000;

    // Wait for global reset to finish
    #100;
      
    // Test Case 1: Reset active
    rst_in = 1;
    #10;
    rst_in = 0;
    #10;

    // Test Case 2: Normal operation with no branch
    pc_in = 32'h00000004;
    pc_src_in = 2'b11; // Select next_pc
    branch_taken_in = 0;
    iaddr_in = 31'h00000008;
    ahb_ready_in = 1;
    #10;
    rst_in = 1;
    #10;
    rst_in = 0;
    #10;

    // Test Case 3: Branch taken
    branch_taken_in = 1;
    iaddr_in = 31'h00000010;
    #10;
    rst_in = 1;
    #10;
    rst_in = 0;
    #10;

    // Test Case 4: Select epc
    pc_src_in = 2'b01;
    epc_in = 32'h00000020;
    #10;
    rst_in = 1;
    #10;
    rst_in = 0;
    #10;

    // Test Case 5: Select trap address
    pc_src_in = 2'b10;
    trap_address_in = 32'h00000030;
    #10;
    rst_in = 1;
    #10;
    rst_in = 0;
    #10;

    // Test Case 6: ahb_ready_in is low
    ahb_ready_in = 0;
    #10;
    rst_in = 1;
    #10;
    rst_in = 0;
    #10;

    // Additional Test Cases
    // Test Case 7: Boot address initialization
    $display("Test Case 7: Boot address initialization");
    pc_src_in = 2'b00; // Select boot address
    #10;
    rst_in = 1;
    #10;
    rst_in = 0;
    #10;

    // Test Case 8: Multiple branches
    $display("Test Case 8: Multiple branches");
    branch_taken_in = 1;
    iaddr_in = 31'h00000020;
    #10;
    branch_taken_in = 0;
    #10;
    branch_taken_in = 1;
    iaddr_in = 31'h00000030;
    #10;
    rst_in = 1;
    #10;
    rst_in = 0;
    #10;

    // Test Case 9: Switching between sources
    $display("Test Case 9: Switching between sources");
    pc_src_in = 2'b01; // Select epc
    #10;
    pc_src_in = 2'b10; // Select trap address
    #10;
    pc_src_in = 2'b11; // Select next_pc
    #10;
    rst_in = 1;
    #10;
    rst_in = 0;
    #10;

    $finish;
  end
      
endmodule
