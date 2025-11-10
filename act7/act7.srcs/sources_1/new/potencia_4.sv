`timescale 1ns / 1ps

module potencia_4(

    input [3:0] exp,
    output reg [15:0] result
);

always @(*) begin
    case (exp)
        4'd0: result = 16'd1;
        4'd1: result = 16'd4;
        4'd2: result = 16'd16;
        4'd3: result = 16'd64;
        4'd4: result = 16'd256;
        4'd5: result = 16'd1024;
        4'd6: result = 16'd4096;
        4'd7: result = 16'd16384;
        default: result = 16'd0;
    endcase
end

endmodule
