`timescale 1ns / 1ps

module procesador_secuencias(
    input [3:0] N,           // Valor de entrada (0-15)
    input OPER,              // 0: Padovan, 1: Moser-de Bruijn
    input CLK,               // Reloj del sistema
    input RST,               // Reset
    output [15:0] RESULT,    // Resultado de la operación
    output FINISH            // Señal de finalización
);

// Señales internas - Padovan
wire wsel_mux_pad, wen_r1_pad, wen_r2_pad, wen_r3_pad, wcomp_pad;
wire [15:0] wpad_result, wr1_pad, wr2_pad, wr3_pad, wsum_pad;

// Señales internas - Moser-de Bruijn
wire wsel_mux_mos, wen_acc_mos, wen_cnt_mos, wcomp_mos;
wire [15:0] wmos_result, wacc_mos, wcnt_mos, wpow_mos;

// Señales de control
wire wfinish;
wire [15:0] wmux_result;

// Contador común
wire wsel_cnt, wen_cnt_main;
wire [15:0] wcnt_main, wcnt_dec;

// ============================================================================
// INSTANCIACIÓN DE MÓDULOS
// ============================================================================

// Unidad de Control Principal
control_unit U_CTRL(
    .clk(CLK),
    .rst(RST),
    .oper(OPER),
    .comp_pad(wcomp_pad),
    .comp_mos(wcomp_mos),
    .sel_mux_pad(wsel_mux_pad),
    .sel_mux_mos(wsel_mux_mos),
    .sel_cnt(wsel_cnt),
    .en_r1_pad(wen_r1_pad),
    .en_r2_pad(wen_r2_pad),
    .en_r3_pad(wen_r3_pad),
    .en_acc_mos(wen_acc_mos),
    .en_cnt_mos(wen_cnt_mos),
    .en_cnt_main(wen_cnt_main),
    .finish(wfinish)
);

// Contador Principal (para N iteraciones)
mux_2x1_16b U_MUX_CNT({12'b0, N}, wcnt_dec, wsel_cnt, wcnt_main);
registro_16b U_REG_CNT(wcnt_main, wen_cnt_main, CLK, RST, wcnt_main);
decrementador U_DEC_CNT(wcnt_main, wcnt_dec);
comparador_zero U_COMP_MAIN(wcnt_main, wcomp_pad);

// ============================================================================
// SUBSISTEMA PADOVAN
// ============================================================================
padovan_subsystem U_PADOVAN(
    .clk(CLK),
    .rst(RST),
    .en_r1(wen_r1_pad),
    .en_r2(wen_r2_pad),
    .en_r3(wen_r3_pad),
    .result(wpad_result)
);

// ============================================================================
// SUBSISTEMA MOSER-DE BRUIJN
// ============================================================================
moser_debruijn_subsystem U_MOSER(
    .clk(CLK),
    .rst(RST),
    .n(N),
    .en_acc(wen_acc_mos),
    .en_cnt(wen_cnt_mos),
    .result(wmos_result)
);

// Multiplexor de salida
mux_2x1_16b U_MUX_OUT(wpad_result, wmos_result, OPER, wmux_result);

assign RESULT = wmux_result;
assign FINISH = wfinish;

endmodule
