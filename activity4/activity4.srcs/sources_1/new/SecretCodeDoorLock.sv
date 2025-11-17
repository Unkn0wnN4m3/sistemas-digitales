`timescale 1ns / 1ps

module SecretCodeDoorLock (
    input logic clk,
    input logic rst,
    input logic [2:0] buttons,
    input logic [7:0] switches,
    output logic [1:0] led
);

    // Definición de los estados de la FSM
    typedef enum logic [2:0] {
        IDLE,
        INPUT_DIGIT_1,
        INPUT_DIGIT_2,
        INPUT_DIGIT_3,
        INPUT_DIGIT_4,
        CHECK_CODE,
        CORRECT_CODE,
        INCORRECT_CODE
    } state_t;

    state_t current_state, next_state;

    // Registros para almacenar el código secreto y el introducido
    logic [1:0] secret_code [3:0];
    logic [1:0] entered_code [3:0];
    logic [1:0] digit_input;
    logic [2:0] button_pressed;
    logic button_released;

    // Asignación del código secreto desde los switches
    always_comb begin
        secret_code[0] = switches[7:6];
        secret_code[1] = switches[5:4];
        secret_code[2] = switches[3:2];
        secret_code[3] = switches[1:0];
    end

    // Lógica de la FSM y almacenamiento de datos
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            current_state <= IDLE;
            entered_code[0] <= 2'b00;
            entered_code[1] <= 2'b00;
            entered_code[2] <= 2'b00;
            entered_code[3] <= 2'b00;
        end else begin
            current_state <= next_state;
            case (current_state)
                INPUT_DIGIT_1: if (button_released) entered_code[0] <= digit_input;
                INPUT_DIGIT_2: if (button_released) entered_code[1] <= digit_input;
                INPUT_DIGIT_3: if (button_released) entered_code[2] <= digit_input;
                INPUT_DIGIT_4: if (button_released) entered_code[3] <= digit_input;
                default: ;
            endcase
        end
    end

    // Lógica de transición de estados
    always_comb begin
        next_state = current_state;
        button_pressed = 3'b000;
        button_released = 1'b0;

        // Detección de pulsación de botón
        if (|buttons) begin
            button_pressed = buttons;
        end

        // Lógica de entrada de dígitos
        if (buttons == 3'b001) digit_input = 2'b00; // Botón 0 para '0'
        else if (buttons == 3'b010) digit_input = 2'b01; // Botón 1 para '1'
        else if (buttons == 3'b100) digit_input = 2'b10; // Botón 2 para '2'
        else digit_input = 2'bxx;

        case (current_state)
            IDLE: if (button_pressed != 3'b000) next_state = INPUT_DIGIT_1;
            INPUT_DIGIT_1: if (buttons == 3'b000) begin button_released = 1'b1; next_state = INPUT_DIGIT_2; end
            INPUT_DIGIT_2: if (buttons == 3'b000) begin button_released = 1'b1; next_state = INPUT_DIGIT_3; end
            INPUT_DIGIT_3: if (buttons == 3'b000) begin button_released = 1'b1; next_state = INPUT_DIGIT_4; end
            INPUT_DIGIT_4: if (buttons == 3'b000) begin button_released = 1'b1; next_state = CHECK_CODE; end
            CHECK_CODE: begin
                if (entered_code[0] == secret_code[0] &&
                    entered_code[1] == secret_code[1] &&
                    entered_code[2] == secret_code[2] &&
                    entered_code[3] == secret_code[3]) begin
                    next_state = CORRECT_CODE;
                end else begin
                    next_state = INCORRECT_CODE;
                end
            end
            CORRECT_CODE: next_state = CORRECT_CODE;
            INCORRECT_CODE: next_state = INCORRECT_CODE;
            default: next_state = IDLE;
        endcase
    end

    // Lógica de salida para los LEDs
    always_comb begin
        led = 2'b00;
        if (current_state == CORRECT_CODE) begin
            led = 2'b01; // LED[0] encendido
        end else if (current_state == INCORRECT_CODE) begin
            led = 2'b10; // LED[1] encendido
        end
    end

endmodule
