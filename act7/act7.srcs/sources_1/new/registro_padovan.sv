`timescale 1ns / 1ps

module registro_padovan(
    input [15:0] data_in,
    input enable,
    input clk,
    input rst,
    input [15:0] init_value,
    output reg [15:0] data_out
);

always @(posedge clk or posedge rst) begin
    if (rst)
        data_out <= init_value;  // Inicialización configurable
    else if (enable)
        data_out <= data_in;
end

endmodule
