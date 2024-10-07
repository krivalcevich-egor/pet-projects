`timescale 1ns / 1ps

////////////////////////////////////////////////////////
// This code describe half adder. 
// It's calculate sum of 2 bits.
////////////////////////////////////////////////////////

module half_adder(
        input logic a,
        input logic b,
        output logic cout,
        output logic s
        );
    
    
    assign s = a ^ b;
    assign cout = a & b;
    
endmodule
