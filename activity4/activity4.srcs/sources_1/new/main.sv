`timescale 1ns / 1ps

module main(
    input logic clk,
    input logic reset,
    input logic [7:0] switches,   // SW[7:0] - Define secret code
    input logic btn_0,            // Button for digit "0"
    input logic btn_1,            // Button for digit "1"
    input logic btn_2,            // Button for digit "2"
    output logic led_correct,     // LED[0] - code correct
    output logic led_incorrect,   // LED[1] - code incorrect
    output logic [3:0] an,        // 7-segment anodes
    output logic [6:0] sseg       // 7-segment cathodes
);

    // Internal signals
    logic [3:0] result;
    logic [3:0] hex3, hex2, hex1, hex0;
    logic [3:0] dp_in;
    
    // Instantiate door lock FSM
    door_lock door_fsm (
        .clk(clk),
        .reset(reset),
        .switches(switches),
        .btn_0(btn_0),
        .btn_1(btn_1),
        .btn_2(btn_2),
        .led_correct(led_correct),
        .led_incorrect(led_incorrect),
        .result(result)
    );
    
    // Configure 7-segment displays
    assign hex0 = result;      // Show result on rightmost display
    assign hex1 = 4'hF;        // Blank
    assign hex2 = 4'hF;        // Blank
    assign hex3 = 4'hF;        // Blank
    assign dp_in = 4'b0000;    // No decimal points
    
    // Instantiate 7-segment display multiplexer
    x7segmux seg_display (
        .clk(clk),
        .reset(reset),
        .hex3(hex3),
        .hex2(hex2),
        .hex1(hex1),
        .hex0(hex0),
        .dp_in(dp_in),
        .an(an),
        .sseg(sseg)
    );

endmodule