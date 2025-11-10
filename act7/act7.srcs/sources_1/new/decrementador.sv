`timescale 1ns / 1ps

module decrementador(

    input [15:0] data_in,
    output [15:0] data_out
);

    assign data_out = data_in - 1;

endmodule
