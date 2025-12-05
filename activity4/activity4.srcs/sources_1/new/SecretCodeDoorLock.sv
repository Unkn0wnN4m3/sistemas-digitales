`timescale 1ns / 1ps

module door_lock (
    input logic clk,
    input logic reset,
    input logic [7:0] switches,   // SW[7:0] - Define secret code
    input logic btn_0,            // Button for digit "0"
    input logic btn_1,            // Button for digit "1"
    input logic btn_2,            // Button for digit "2"
    output logic led_correct,     // LED[0] - code correct
    output logic led_incorrect,   // LED[1] - code incorrect
    output logic [3:0] result     // Result for 7-segment display
);

    // Define FSM states
    typedef enum logic [2:0] {
        IDLE,
        DIGIT1,
        DIGIT2,
        DIGIT3,
        DIGIT4,
        CHECK,
        CORRECT,
        INCORRECT
    } state_type;
    
    // State registers
    state_type state_reg, state_next;
    
    // Secret code from switches
    logic [1:0] code_digit1;  // switches[1:0]
    logic [1:0] code_digit2;  // switches[3:2]
    logic [1:0] code_digit3;  // switches[5:4]
    logic [1:0] code_digit4;  // switches[7:6]
    
    // Assign secret code from switches
    assign code_digit1 = switches[1:0];
    assign code_digit2 = switches[3:2];
    assign code_digit3 = switches[5:4];
    assign code_digit4 = switches[7:6];
    
    // Input digit registers (user's entered code)
    logic [1:0] input_digit1_reg, input_digit1_next;
    logic [1:0] input_digit2_reg, input_digit2_next;
    logic [1:0] input_digit3_reg, input_digit3_next;
    logic [1:0] input_digit4_reg, input_digit4_next;
    
    // Edge detection for buttons
    logic btn_0_prev, btn_0_edge;
    logic btn_1_prev, btn_1_edge;
    logic btn_2_prev, btn_2_edge;
    
    // Any button pressed
    logic any_btn_edge;
    logic [1:0] current_digit;
    
    // Button edge detectors
    always_ff @(posedge clk, posedge reset) begin
        if (reset) begin
            btn_0_prev <= 1'b0;
            btn_1_prev <= 1'b0;
            btn_2_prev <= 1'b0;
        end else begin
            btn_0_prev <= btn_0;
            btn_1_prev <= btn_1;
            btn_2_prev <= btn_2;
        end
    end
    
    assign btn_0_edge = btn_0 & ~btn_0_prev;
    assign btn_1_edge = btn_1 & ~btn_1_prev;
    assign btn_2_edge = btn_2 & ~btn_2_prev;
    
    assign any_btn_edge = btn_0_edge | btn_1_edge | btn_2_edge;
    
    // Determine which digit was pressed
    always_comb begin
        if (btn_0_edge)
            current_digit = 2'b00;  // 0
        else if (btn_1_edge)
            current_digit = 2'b01;  // 1
        else if (btn_2_edge)
            current_digit = 2'b10;  // 2
        else
            current_digit = 2'b00;  // Default
    end
    
    // State register
    always_ff @(posedge clk, posedge reset) begin
        if (reset) begin
            state_reg <= IDLE;
            input_digit1_reg <= 2'b00;
            input_digit2_reg <= 2'b00;
            input_digit3_reg <= 2'b00;
            input_digit4_reg <= 2'b00;
        end else begin
            state_reg <= state_next;
            input_digit1_reg <= input_digit1_next;
            input_digit2_reg <= input_digit2_next;
            input_digit3_reg <= input_digit3_next;
            input_digit4_reg <= input_digit4_next;
        end
    end
    
    // Next-state logic and digit capture
    always_comb begin
        // Default: maintain current values
        state_next = state_reg;
        input_digit1_next = input_digit1_reg;
        input_digit2_next = input_digit2_reg;
        input_digit3_next = input_digit3_reg;
        input_digit4_next = input_digit4_reg;
        
        case (state_reg)
            IDLE: begin
                if (any_btn_edge) begin
                    input_digit1_next = current_digit;
                    state_next = DIGIT1;
                end
            end
            
            DIGIT1: begin
                if (any_btn_edge) begin
                    input_digit2_next = current_digit;
                    state_next = DIGIT2;
                end
            end
            
            DIGIT2: begin
                if (any_btn_edge) begin
                    input_digit3_next = current_digit;
                    state_next = DIGIT3;
                end
            end
            
            DIGIT3: begin
                if (any_btn_edge) begin
                    input_digit4_next = current_digit;
                    state_next = DIGIT4;
                end
            end
            
            DIGIT4: begin
                state_next = CHECK;
            end
            
            CHECK: begin
                // Check if all digits match the secret code
                if ((input_digit1_reg == code_digit1) && 
                    (input_digit2_reg == code_digit2) && 
                    (input_digit3_reg == code_digit3) && 
                    (input_digit4_reg == code_digit4)) begin
                    state_next = CORRECT;
                end else begin
                    state_next = INCORRECT;
                end
            end
            
            CORRECT: begin
                if (any_btn_edge)
                    state_next = IDLE;
            end
            
            INCORRECT: begin
                if (any_btn_edge)
                    state_next = IDLE;
            end
            
            default: begin
                state_next = IDLE;
            end
        endcase
    end
    
    // Output logic (Moore outputs)
    assign led_correct = (state_reg == CORRECT);
    assign led_incorrect = (state_reg == INCORRECT);
    
    // Result output for 7-segment display
    always_comb begin
        case (state_reg)
            CORRECT:   result = 4'h1;  // Show "1" for correct
            INCORRECT: result = 4'h0;  // Show "0" for incorrect
            default:   result = 4'hF;  // Blank for other states
        endcase
    end

endmodule