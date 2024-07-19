`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11.07.2024 09:45:10
// Design Name: 
// Module Name: msrv32_machine_control
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


module msrv32_machine_control( 
                                input  clk_in, reset_in,
                               // from control unit
                               input  illegal_instr_in,misaligned_load_in,misaligned_store_in,
                               // from pipeline stage 1
                               input  misaligned_instr_in,
                               // from instruction
                               input  [6:2] opcode_6_to_2_in,
                               input  [2:0] funct3_in,
                               input  [6:0] funct7_in,
                               input  [4:0] rs1_addr_in,
                               input  [4:0] rs2_addr_in,
                               input  [4:0] rd_addr_in,
                               // from interrupt controller
                               input  e_irq_in,t_irq_in, s_irq_in,
                               // from CSR file
                               input  mie_in, meie_in,mtie_in, msie_in, meip_in,mtip_in,msip_in,
                               // to CSR file
                               output reg i_or_e_out, set_epc_out, set_cause_out,
                               output reg [3:0] cause_out,
                               output reg instret_inc_out, mie_clear_out, mie_set_out,
                                          misaligned_exception_out,
                               // to PC MUX
                               output reg [1:0] pc_src_out,
                               // to pipeline stage 2 register
                               output reg flush_out,
                               // to Control Unit
                               output reg trap_taken_out 
     );
localparam CAUSE_ILLEGAL_INSTRUCTION = 4'd2;
    localparam CAUSE_MISALIGNED_LOAD = 4'd4;
    localparam CAUSE_MISALIGNED_STORE = 4'd6;
    localparam CAUSE_MISALIGNED_INSTRUCTION = 4'd0;
    localparam CAUSE_INTERRUPT_EXTERNAL = 4'd11;
    localparam CAUSE_INTERRUPT_TIMER = 4'd7;
    localparam CAUSE_INTERRUPT_SOFTWARE = 4'd3;

    // Internal signals
    reg exception;
    reg interrupt;
    reg [3:0] cause;

    // Exception and interrupt handling
    always @(*) begin
        exception = 1'b0;
        interrupt = 1'b0;
        cause = 4'b0000;
        
        // Check for exceptions
        if (illegal_instr_in) begin
            exception = 1'b0;
            cause = CAUSE_ILLEGAL_INSTRUCTION;
        end else if (misaligned_load_in) begin
            exception = 1'b1;
            cause = CAUSE_MISALIGNED_LOAD;
        end else if (misaligned_store_in) begin
            exception = 1'b1;
            cause = CAUSE_MISALIGNED_STORE;
        end else if (misaligned_instr_in) begin
            exception = 1'b1;
            cause = CAUSE_MISALIGNED_INSTRUCTION;
        end
        
        // Check for interrupts
        if (mie_in) begin
            if (meip_in && meie_in) begin
                interrupt = 1'b1;
                cause = CAUSE_INTERRUPT_EXTERNAL;
            end else if (mtip_in && mtie_in) begin
                interrupt = 1'b1;
                cause = CAUSE_INTERRUPT_TIMER;
            end else if (msip_in && msie_in) begin
                interrupt = 1'b1;
                cause = CAUSE_INTERRUPT_SOFTWARE;
            end
        end
    end

    // Sequential logic for setting outputs
    always @(posedge clk_in or posedge reset_in) begin
        if (reset_in) begin
            i_or_e_out <= 1'b0;
            set_epc_out <= 1'b0;
            set_cause_out <= 1'b0;
            cause_out <= 4'b0000;
            instret_inc_out <= 1'b0;
            mie_clear_out <= 1'b0;
            mie_set_out <= 1'b0;
            misaligned_exception_out <= 1'b0;
            pc_src_out <= 2'b00;
            flush_out <= 1'b0;
            trap_taken_out <= 1'b0;
        end else begin
            // Update outputs based on exceptions and interrupts
            if (exception || interrupt) begin
                trap_taken_out <= 1'b1;
                i_or_e_out <= interrupt;
                set_epc_out <= 1'b1;
                set_cause_out <= 1'b1;
                cause_out <= cause;
                misaligned_exception_out <= misaligned_instr_in;
                pc_src_out <= 2'b10; // Assuming trap vector base address
                flush_out <= 1'b1;
            end else begin
                trap_taken_out <= 1'b0;
                set_epc_out <= 1'b0;
                set_cause_out <= 1'b0;
                cause_out <= 4'b0000;
                misaligned_exception_out <= 1'b0;
                pc_src_out <= 2'b00;
                flush_out <= 1'b0;
            end
            
            // Instruction retirement increment
            instret_inc_out <= ~trap_taken_out;

            // Manage MIE bit
            if (trap_taken_out) begin
                mie_clear_out <= 1'b1;
                mie_set_out <= 1'b0;
            end else begin
                mie_clear_out <= 1'b0;
                mie_set_out <= 1'b0;
            end
        end
    end

endmodule
