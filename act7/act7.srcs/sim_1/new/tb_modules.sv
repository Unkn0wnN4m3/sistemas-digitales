`timescale 1ns / 1ps

module tb_modules;

reg [3:0] N;
reg OPER;
reg CLK;
reg RST;
wire [15:0] RESULT;
wire FINISH;

procesador_secuencias DUT (
    .N(N),
    .OPER(OPER),
    .CLK(CLK),
    .RST(RST),
    .RESULT(RESULT),
    .FINISH(FINISH)
);

// Generación del reloj
initial CLK = 0;
always #5 CLK = ~CLK;


initial begin
    // Inicialización
    RST = 1;
    OPER = 0;  // Padovan
    N = 4'd10;
    #20;
    RST = 0;
    
    // Esperar a que termine
    wait(FINISH == 1);
    #20;

    $finish;
end

endmodule
