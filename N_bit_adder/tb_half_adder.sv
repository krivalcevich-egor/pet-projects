`timescale 1ns / 1ps

module tb_half_adder( );

logic a, b, s, cout;

half_adder adder (
            .a(a),
            .b(b),
            .s(s),
            .cout(cout)
            );

initial begin
    a = 0;
    b = 0;
    #50;
    
    a = 1;
    b = 0;
    #50; 

    a = 0;
    b = 1;
    #50; 
    
    a = 1;
    b = 1;
    #50; 
end                
endmodule
