`timescale 1ns / 1ps

module main_tb;

    logic clk;
    logic rst;
    logic [2:0] buttons;
    logic [7:0] switches;
    logic [3:0] an;
    logic [6:0] sseg;

    // Instancia del módulo superior a probar
    main dut (
        .clk(clk),
        .rst(rst),
        .buttons(buttons),
        .switches(switches),
        .an(an),
        .sseg(sseg)
    );

    // Generación de la señal de reloj
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Proceso de simulación
    initial begin
        // 1. Caso de prueba: Código Correcto (2-0-1-2)
        $display("Caso de prueba 1: Código Correcto");
        rst = 1;
        switches = 8'b10000110; // Código secreto: 2-0-1-2
        buttons = 3'b000;
        #10;
        rst = 0;
        #10;

        // Simulación de la introducción de "2-0-1-2"
        buttons = 3'b100; #10; buttons = 3'b000; #10;
        buttons = 3'b001; #10; buttons = 3'b000; #10;
        buttons = 3'b010; #10; buttons = 3'b000; #10;
        buttons = 3'b100; #10; buttons = 3'b000; #20;

        $display("Prueba 1: Se espera el mensaje 'PASS' en los displays.");
        // Aquí se podría añadir una verificación más detallada de las señales 'an' y 'sseg'

        #100; // Tiempo para observar el resultado en simulación

        // 2. Caso de prueba: Código Incorrecto (1-1-1-1)
        $display("Caso de prueba 2: Código Incorrecto");
        rst = 1;
        #10;
        rst = 0;
        #10;

        // Simulación de la introducción de "1-1-1-1"
        buttons = 3'b010; #10; buttons = 3'b000; #10;
        buttons = 3'b010; #10; buttons = 3'b000; #10;
        buttons = 3'b010; #10; buttons = 3'b000; #10;
        buttons = 3'b010; #10; buttons = 3'b000; #20;

        $display("Prueba 2: Se espera el mensaje 'ERR' en los displays.");

        #100;

        $stop;
    end

endmodule
