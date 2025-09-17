`timescale 1ns / 1ps

import FloatingPointPkg::fp_t;

module fp_sorter(
       input fp_t a,
       input fp_t b,
       output fp_t big_number,
       output fp_t small_number       
    );
    
    assign big_number = ({a.exp, a.frac} >= {b.exp, b.frac}) ? a : b;
    assign small_number = ({a.exp, a.frac} < {b.exp, b.frac}) ? a : b;
endmodule
