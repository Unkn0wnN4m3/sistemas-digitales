`timescale 1ns / 1ps

module padovan_subsystem(

    input clk,
    input rst,
    input en_r1,
    input en_r2,
    input en_r3,
    output [15:0] result
);

wire [15:0] r1_out, r2_out, r3_out, sum_out;

// P(n) = P(n-2) + P(n-3)
// Inicialización correcta: P(0)=1, P(1)=1, P(2)=1

registro_padovan U_R1(sum_out, en_r1, clk, rst, 16'd1, r1_out);    // P(n) - inicia en 1
registro_padovan U_R2(r1_out, en_r2, clk, rst, 16'd1, r2_out);     // P(n-1) - inicia en 1
registro_padovan U_R3(r2_out, en_r3, clk, rst, 16'd1, r3_out);     // P(n-2) - inicia en 1

sumador_16b U_SUM(r2_out, r3_out, sum_out);

assign result = r1_out;

endmodule
