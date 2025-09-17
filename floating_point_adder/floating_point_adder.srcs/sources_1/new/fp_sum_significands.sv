`timescale 1ns / 1ps

import FloatingPointPkg::fp_t;

module fp_sum_significands(
        input fp_t bign,
        input fp_t smalln,
        output logic [8:0] sum
    );
    
    assign sum = (bign.sign == smalln.sign) ?
                 {1'b0, bign.frac} + {1'b0, smalln.frac} :
                 {1'b0, bign.frac} - {1'b0, smalln.frac};
endmodule
