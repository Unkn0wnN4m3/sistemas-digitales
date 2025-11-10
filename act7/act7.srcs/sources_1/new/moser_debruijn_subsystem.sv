`timescale 1ns / 1ps

module moser_debruijn_subsystem(

    input clk,
    input rst,
    input [3:0] n,
    input en_acc,
    input en_cnt,
    output [15:0] result
);

// Moser-de Bruijn: suma de potencias de 4
// S(n) = suma de 4^i para i donde bit i de n es 1

wire [15:0] acc_out, pow4_out, cnt_out, sum_out;
wire bit_n;

registro_16b U_ACC(sum_out, en_acc, clk, rst, acc_out);
registro_16b U_CNT(16'd0, en_cnt, clk, rst, cnt_out);

// Extraer bit correspondiente de N
assign bit_n = n[cnt_out[3:0]];

// Calcular 4^cnt
potencia_4 U_POW4(cnt_out[3:0], pow4_out);

// Si bit es 1, sumar 4^cnt al acumulador
assign sum_out = bit_n ? (acc_out + pow4_out) : acc_out;

assign result = acc_out;

endmodule
