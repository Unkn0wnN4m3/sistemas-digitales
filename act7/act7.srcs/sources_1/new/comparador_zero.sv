`timescale 1ns / 1ps

module comparador_zero(
    input [15:0] data_in,
    output comp
);

assign comp = (data_in == 16'd0) ? 1'b1 : 1'b0;

endmodule
