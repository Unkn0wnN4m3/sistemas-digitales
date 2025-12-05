`timescale 1ns / 1ps

// control_unit.sv
module control_unit(
    input  logic clk,
    input  logic clr,
    input  logic go,
    // --- Entradas desde el Datapath ---
    input  logic eqflg, ltflg,
    // --- Salidas hacia el Datapath ---
    output logic xsel, ysel,
    output logic xld, yld, gld,
    output logic done_flag // Indicador para saber cuándo termina
);

    // Definición de los estados de la FSM
    typedef enum logic [2:0] {
        S_START,
        S_INPUT,
        S_TEST1,
        S_TEST2,
        S_SUB_X, // Estado para x = x - y
        S_SUB_Y, // Estado para y = y - x
        S_DONE
    } state_t;

    state_t current_state, next_state;

    // Lógica secuencial para la transición de estados
    always_ff @(posedge clk or posedge clr) begin
        if (clr) begin
            current_state <= S_START;
        end else begin
            current_state <= next_state;
        end
    end

    // Lógica combinacional para la transición de estados
    always_comb begin
        next_state = current_state; // Por defecto, permanecer en el mismo estado
        case (current_state)
            S_START: if (go) next_state = S_INPUT;
            S_INPUT: next_state = S_TEST1;
            S_TEST1: if (eqflg) next_state = S_DONE;
                     else       next_state = S_TEST2;
            S_TEST2: if (ltflg) next_state = S_SUB_Y; // x < y  => y = y - x
                     else       next_state = S_SUB_X; // x > y  => x = x - y
            S_SUB_X: next_state = S_TEST1;
            S_SUB_Y: next_state = S_TEST1;
            S_DONE: if (~go) next_state = S_START;    // Regresar al inicio para otro cálculo
        endcase
    end
    
    // Lógica combinacional para las señales de salida
    always_comb begin
        // Valores por defecto
        xsel = 1'b0; ysel = 1'b0;
        xld  = 1'b0; yld  = 1'b0;
        gld  = 1'b0;
        done_flag = 1'b0;
        
        case (current_state)
            S_INPUT: begin
                xsel = 1'b1; ysel = 1'b1; // Seleccionar xin, yin
                xld  = 1'b1; yld  = 1'b1; // Cargar registros x e y
            end
            S_SUB_X: begin // x = x - y
                xsel = 1'b0; // Seleccionar salida del restador
                xld  = 1'b1; // Cargar nuevo valor en x
            end
            S_SUB_Y: begin // y = y - x
                ysel = 1'b0; // Seleccionar salida del restador
                yld  = 1'b1; // Cargar nuevo valor en y
            end
            S_DONE: begin
                gld = 1'b1; // Cargar el resultado en el registro de salida
                done_flag = 1'b1;
            end
            // Para S_START, S_TEST1, S_TEST2, las salidas permanecen en 0
        endcase
    end

endmodule
