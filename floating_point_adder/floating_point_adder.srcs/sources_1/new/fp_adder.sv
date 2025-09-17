`timescale 1ns / 10ps

import FloatingPointPkg::fp_t;

module fp_adder(
        input fp_t a,
        input fp_t b,
        output fp_t result
    );
    
    fp_t bign;
    fp_t smalln;
    fp_t small_aligned;
    logic [8:0] sum;
    fp_t unnormalized;
    
    fp_sorter sort (.a(a), .b(b), .big_number(bign), .small_number(smalln));
    fp_aligment align(.aligned(small_aligned), .bign(bign), .smalln(smalln));
    fp_sum_significands sum_significands(.sum(sum), .bign(bign), .smalln(small_aligned));
    fp_normalize normalize(.carry_out(sum[8]), .unnormalized(unnormalized), .normalized(result));
    
    assign unnormalized = '{bign.sign, bign.exp, sum[7:0]};
endmodule
