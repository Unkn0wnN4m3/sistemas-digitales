`timescale 1ns / 1ps

import FloatingPointPkg::fp_t;

module fp_normalize(
        input logic carry_out,
        input fp_t unnormalized,
        output fp_t normalized
    );
    
    logic [2:0] lead_zeros;
    fp_leading_zeros lead_zeros_unit(.number(unnormalized.frac), .lead0s(lead_zeros));
    
    always_comb
    begin
        if (carry_out)
            begin
                normalized.exp = unnormalized.exp + 1;
                normalized.frac = {1'b1, unnormalized.frac[7:1]};
            end
        else if (lead_zeros > unnormalized.exp)
            begin
                normalized.exp = 0;
                normalized.frac = 0;
            end
        else
            begin
                normalized.exp = unnormalized.exp - lead_zeros;
                normalized.frac = unnormalized.frac << lead_zeros;   
            end
        
        normalized.sign = unnormalized.sign;
    end
endmodule
