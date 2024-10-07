`timescale 1ns / 1ps

module tb_N_bit_adder( );

parameter N = 5;

logic [N - 1 : 0] num1;
logic [N - 1 : 0] num2;
logic [N - 1 : 0] sum;

N_bit_adder #(N)
        add (.num1(num1),
             .num2(num2),
             .sum(sum));
             
initial begin
    num1 = 9;
    num2 = 7;
    #50;  
    
    num1 = -9;
    num2 = 7;
    #50; 
    
    num1 = 3;
    num2 = 12;
    #50;  
    $finish; 
end            
endmodule
