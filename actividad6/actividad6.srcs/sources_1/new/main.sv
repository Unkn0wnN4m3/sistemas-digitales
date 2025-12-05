`timescale 1ns / 1ps

module main(
    input  logic        clk,    // Reloj de 100MHz de la tarjeta
    input  logic [15:0] sw,     // 16 interruptores
    input  logic        btnC,   // Botón central para 'go'
    input  logic        btnU,   // Botón superior para 'clr' (reset)
    output logic [15:0] led     // 16 LEDs
);

    // Señales internas para conectar los módulos
    logic       go_pulse, clr_signal;
    logic       xsel, ysel, xld, yld, gld, done_flag;
    logic       eqflg, ltflg;
    logic [7:0] gcd_out_val;
    logic [7:0] xin_val, yin_val;

    // Asignar interruptores a las entradas de 8 bits
    assign xin_val = sw[15:8];
    assign yin_val = sw[7:0];
    
    // El reset es el botón 'U' (activo alto)
    assign clr_signal = btnU;
    
    // Generador de pulso de un ciclo para la señal 'go'
    // Esto evita que 'go' permanezca en alto y reinicie el cálculo constantemente
    logic btnC_dly;
    always_ff @(posedge clk) begin
        btnC_dly <= btnC;
    end
    assign go_pulse = btnC && !btnC_dly; // Detecta el flanco de subida

    // Instancia de la Unidad de Control
    control_unit cu_inst (
        .clk(clk),
        .clr(clr_signal),
        .go(go_pulse),
        .eqflg(eqflg),
        .ltflg(ltflg),
        .xsel(xsel),
        .ysel(ysel),
        .xld(xld),
        .yld(yld),
        .gld(gld),
        .done_flag(done_flag)
    );

    // Instancia del Datapath
    datapath dp_inst (
        .clk(clk),
        .clr(clr_signal),
        .xsel(xsel), .ysel(ysel),
        .xld(xld),   .yld(yld),   .gld(gld),
        .xin(xin_val),
        .yin(yin_val),
        .eqflg(eqflg),
        .ltflg(ltflg),
        .gcd_out(gcd_out_val)
    );
    
    // Asignar salidas a los LEDs
    assign led[7:0] = gcd_out_val; // El resultado en los 8 LEDs inferiores
    assign led[15]  = done_flag;  // Un LED para indicar que el cálculo ha terminado

endmodule
