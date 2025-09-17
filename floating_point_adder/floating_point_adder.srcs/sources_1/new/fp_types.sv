`timescale 1ns / 1ps

package FloatingPointPkg;

// 13 bit floating point number
// sign: indicates the sign of the number
// exp: exponent to handle fp numbers
// frac: represents the significant (f) or the fraction
typedef struct packed {
    logic sign;
    logic [3:0] exp;
    logic [7:0] frac;
} fp_t;

endpackage:FloatingPointPkg