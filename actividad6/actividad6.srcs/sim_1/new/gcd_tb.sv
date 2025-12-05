
`timescale 1ns / 1ps

module tb_main;

    logic        clk;
    logic [15:0] sw;
    logic        btnC;
    logic        btnU;
    logic [15:0] led;

    main dut (
        .clk(clk),
        .sw(sw),
        .btnC(btnC),
        .btnU(btnU),
        .led(led)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 1'b0;
        sw = 16'h0000;
        btnC = 1'b0;
        
        // Aplicar un pulso de reset al inicio usando el botón 'U'
        btnU = 1'b1;
        #20; // Mantener el reset activo por 2 ciclos de reloj (20 ns)
        
        @(posedge clk);
        btnU = 1'b0; // Liberar el reset
        #10;


        sw = {8'd70, 8'd15};

        // Generar un pulso explícito de un ciclo de reloj para btnC
        @(posedge clk); // Sincronizar con el reloj
        btnC = 1'b1;     // Poner btnC en alto
        @(posedge clk); // Esperar un ciclo completo
        btnC = 1'b0;     // Poner btnC en bajo

        #20;
        $stop;
    end

endmodule
