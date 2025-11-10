`timescale 1ns / 1ps

module mux_2x1_16b(
    input [15:0] data0,
    input [15:0] data1,
    input sel,
    output [15:0] data_out
);

    assign data_out = sel ? data1 : data0;

endmodule
