`timescale 1ns / 1ps

module main (
    input logic clk,
    input logic rst,
    input logic [2:0] buttons,
    input logic [7:0] switches,
    output logic [3:0] an,
    output logic [6:0] sseg
    );

    logic [1:0] led_status;
    logic [3:0] display_hex3, display_hex2, display_hex1, display_hex0;

    // Instancia del módulo de la cerradura
    SecretCodeDoorLock lock_inst (
        .clk(clk),
        .rst(rst),
        .buttons(buttons),
        .switches(switches),
        .led(led_status)
    );

    // Lógica para determinar qué mostrar en los displays
    always_comb begin
        case (led_status)
            2'b01: begin // Código Correcto: Muestra "PASS"
                display_hex3 = 4'hA; // P
                display_hex2 = 4'hA; // A
                display_hex1 = 4'h5; // S
                display_hex0 = 4'h5; // S
            end
            2'b10: begin // Código Incorrecto: Muestra "ERR"
                display_hex3 = 4'hE; // E
                display_hex2 = 4'hF; // r (usando un valor no estándar, se puede ajustar)
                display_hex1 = 4'hF; // r
                display_hex0 = 4'hF; // Apagado
            end
            default: begin // Estado inicial o intermedio: Displays apagados
                display_hex3 = 4'hF;
                display_hex2 = 4'hF;
                display_hex1 = 4'hF;
                display_hex0 = 4'hF;
            end
        endcase
    end

    // Instancia del controlador de los displays de 7 segmentos
    x7segmux display_inst (
        .clk(clk),
        .reset(rst),
        .hex3(display_hex3),
        .hex2(display_hex2),
        .hex1(display_hex1),
        .hex0(display_hex0),
        .dp_in(4'b0000), // Puntos decimales no utilizados
        .an(an),
        .sseg(sseg)
    );

endmodule
