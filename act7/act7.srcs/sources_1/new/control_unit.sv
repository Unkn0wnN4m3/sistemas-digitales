`timescale 1ns / 1ps

module control_unit(
    input clk,
    input rst,
    input oper,
    input comp_pad,
    input comp_mos,
    output reg sel_mux_pad,
    output reg sel_mux_mos,
    output reg sel_cnt,
    output reg en_r1_pad,
    output reg en_r2_pad,
    output reg en_r3_pad,
    output reg en_acc_mos,
    output reg en_cnt_mos,
    output reg en_cnt_main,
    output reg finish
);

// Estados de la FSM
parameter IDLE    = 3'b000;
parameter INIT    = 3'b001;
parameter PADOVAN = 3'b010;
parameter MOSER   = 3'b011;
parameter DONE    = 3'b100;

reg [2:0] estado_actual, estado_siguiente;

// Registro de estado
always @(posedge clk or posedge rst) begin
    if (rst)
        estado_actual <= IDLE;
    else
        estado_actual <= estado_siguiente;
end

// Lógica de transición de estados
always @(*) begin
    case (estado_actual)
        IDLE: begin
            estado_siguiente = INIT;
        end
        
        INIT: begin
            if (oper == 0)
                estado_siguiente = PADOVAN;
            else
                estado_siguiente = MOSER;
        end
        
        PADOVAN: begin
            if (comp_pad == 1)
                estado_siguiente = DONE;
            else
                estado_siguiente = PADOVAN;
        end
        
        MOSER: begin
            if (comp_mos == 1)
                estado_siguiente = DONE;
            else
                estado_siguiente = MOSER;
        end
        
        DONE: begin
            estado_siguiente = DONE;
        end
        
        default: estado_siguiente = IDLE;
    endcase
end

// Lógica de salida (señales de control)
always @(*) begin
    // Valores por defecto
    sel_mux_pad = 0;
    sel_mux_mos = 0;
    sel_cnt = 0;
    en_r1_pad = 0;
    en_r2_pad = 0;
    en_r3_pad = 0;
    en_acc_mos = 0;
    en_cnt_mos = 0;
    en_cnt_main = 0;
    finish = 0;
    
    case (estado_actual)
        IDLE: begin
            finish = 0;
        end
        
        INIT: begin
            sel_cnt = 0;
            en_cnt_main = 1;
            if (oper == 0) begin
                en_r1_pad = 1;
                en_r2_pad = 1;
                en_r3_pad = 1;
            end else begin
                en_acc_mos = 1;
                en_cnt_mos = 1;
            end
        end
        
        PADOVAN: begin
            sel_cnt = 1;
            en_cnt_main = 1;
            en_r1_pad = 1;
            en_r2_pad = 1;
            en_r3_pad = 1;
        end
        
        MOSER: begin
            sel_cnt = 1;
            en_cnt_main = 1;
            en_acc_mos = 1;
            en_cnt_mos = 1;
        end
        
        DONE: begin
            finish = 1;
        end
    endcase
end

endmodule
