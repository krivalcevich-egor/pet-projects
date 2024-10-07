`timescale 1ns / 1ps

////////////////////////////////////////////////////////
// This code describe full adder. 
// It's calculate sum of 2 bits with cin.
////////////////////////////////////////////////////////

module full_adder(
    input logic a,
    input logic b,
    input logic cin,
    output logic cout,
    output logic s);
    
    
    logic p, g;
    
    assign p = a ^ b;
    assign g = a & b;
    
    assign s = p ^ cin;
    assign cout = g | (p & cin);

endmodule