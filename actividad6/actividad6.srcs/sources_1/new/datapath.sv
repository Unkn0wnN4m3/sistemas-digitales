`timescale 1ns / 1ps

// datapath.sv
module datapath(
    input  logic        clk,
    input  logic        clr,
    // --- Entradas desde la Unidad de Control ---
    input  logic        xsel, ysel,
    input  logic        xld, yld, gld,
    // --- Entradas de datos externas ---
    input  logic [7:0]  xin, yin,
    // --- Salidas hacia la Unidad de Control ---
    output logic        eqflg, ltflg,
    // --- Salida final del resultado ---
    output logic [7:0]  gcd_out
);

    // Registros internos para x, y, y el resultado final gcd
    logic [7:0] x_reg, y_reg, gcd_reg;
    
    // Salidas de los subtractores
    logic [7:0] x_minus_y, y_minus_x;
    
    // Salidas de los multiplexores
    logic [7:0] x_mux_out, y_mux_out;

    // Lógica combinacional
    // Comparador
    assign eqflg = (x_reg == y_reg);
    assign ltflg = (x_reg < y_reg);
    
    // Subtractores (según el diagrama)
    assign x_minus_y = x_reg - y_reg; // xr(7:0)
    assign y_minus_x = y_reg - x_reg; // yr(7:0)
    
    // Multiplexores
    assign x_mux_out = (xsel) ? xin : x_minus_y;
    assign y_mux_out = (ysel) ? yin : y_minus_x;
    
    // Lógica secuencial (Registros)
    always_ff @(posedge clk or posedge clr) begin
        if (clr) begin
            x_reg   <= 8'd0;
            y_reg   <= 8'd0;
            gcd_reg <= 8'd0;
        end else begin
            if (xld) begin
                x_reg <= x_mux_out;
            end
            if (yld) begin
                y_reg <= y_mux_out;
            end
            if (gld) begin
                gcd_reg <= x_reg; // El resultado es el valor en x cuando x=y
            end
        end
    end
    
    // Salida final
    assign gcd_out = gcd_reg;

endmodule
