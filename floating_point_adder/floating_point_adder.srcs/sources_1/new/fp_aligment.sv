`timescale 1ns / 1ps

import FloatingPointPkg::fp_t;

module fp_aligment(
        input fp_t bign,
        input fp_t smalln,
        output fp_t aligned
    );
    
    logic [3:0] exp_diff;
    
    always_comb
    begin
        exp_diff = bign.exp - smalln.exp;
        aligned.frac = smalln.frac >> exp_diff;
        aligned.exp = bign.exp;
        aligned.sign = smalln.sign;
    end
endmodule
