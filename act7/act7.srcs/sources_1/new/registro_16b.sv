`timescale 1ns / 1ps

module registro_16b(
    input [15:0] data_in,
    input enable,
    input clk,
    input rst,
    output reg [15:0] data_out
);

always @(posedge clk or posedge rst) begin
    if (rst)
        data_out <= 16'd0;
    else if (enable)
        data_out <= data_in;
end

endmodule
