`timescale 1ns / 1ps

module tb_full_adder( );

logic a, b, cin, s, cout;

full_adder adder (
            .a(a),
            .b(b),
            .cin(cin),
            .s(s),
            .cout(cout)
            );

initial begin
    a = 0;
    b = 0;
    cin = 0;
    #50;
    
    a = 1;
    b = 0;
    cin = 0;
    #50; 

    a = 0;
    b = 1;
    cin = 0;
    #50; 
    
    a = 0;
    b = 0;
    cin = 1;
    #50; 
    
    a = 1;
    b = 1;
    cin = 0;
    #50; 
    
    a = 1;
    b = 0;
    cin = 1;
    #50; 
    
    a = 0;
    b = 1;
    cin = 1;
    #50;
    
    a = 1;
    b = 1;
    cin = 1;
    #50;                          
end
endmodule
