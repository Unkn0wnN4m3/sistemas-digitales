`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11.10.2025 13:50:19
// Design Name: 
// Module Name: mealy_fsm_detector
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


module mealy_fsm_detector(
        input  logic       clk,
        input  logic       rst,
        input  logic [1:0] data_in,
        output logic [1:0] data_out
    );
    
    // state def
    typedef enum logic [1:0] { q0, q1, q2, q3 } state_t;
    
    // state reg
    state_t current_state, next_state;
    
    // secuential state reg
    always_ff @(posedge clk, posedge rst)
    begin
        if (rst)
            current_state <= q0;
        else
            current_state <= next_state;
    end
    
    // comb logic
    always_comb
    begin
        case (current_state)
            q0: begin
                case (data_in)
                    2'b10: begin
                        next_state = q1;
                        data_out = 2'b00;
                    end
                    2'b00, 2'b01, 2'b11: begin
                        next_state = q0;
                        data_out = 2'b00;
                    end
                endcase
            end

            q1: begin
                case (data_in)
                    2'b00: begin
                        next_state = q2;
                        data_out = 2'b00;
                    end
                    2'b01, 2'b10, 2'b11: begin
                        next_state = q0;
                        data_out = 2'b00;
                    end
                endcase
            end

            q2: begin
                case (data_in)
                    2'b01: begin
                        next_state = q3;
                        data_out = 2'b00;
                    end
                    2'b00, 2'b10, 2'b11: begin
                        next_state = q0;
                        data_out = 2'b00;
                    end
                endcase
            end

            q3: begin
                case (data_in)
                    2'b10: begin
                        next_state = q0;
                        data_out = 2'b01; // final output siganl
                    end
                    2'b00, 2'b01, 2'b11: begin
                        next_state = q0;
                        data_out = 2'b00;
                    end
                endcase
            end

            default: begin
                next_state = q0;
                data_out = 2'b00;
            end
        endcase
    end
endmodule
