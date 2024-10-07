`timescale 1ns / 1ps

////////////////////////////////////////////////////////
// This code describe N bit adder. 
// It's calculate sum of 2 N bit numbers
////////////////////////////////////////////////////////

module N_bit_adder#( parameter N = 5
        )( 
          input logic [N - 1 : 0] num1,
          input logic [N - 1 : 0] num2,
          output logic [N - 1 : 0] sum
        );
        
logic [N - 1 : 0] s = '{default : 0};
logic [N : 1] cin = '{default : 0};        
        
        half_adder adder (
                    .a(num1[0]),
                    .b(num2[0]),
                    .s(s[0]),
                    .cout(cin[1])
                    );

genvar i;
generate
    for(i = 1; i < N; i ++) begin
        full_adder adder (
                .a(num1[i]),
                .b(num2[i]),
                .cin(cin[i]),
                .s(s[i]),
                .cout(cin[i + 1])
                );   
    end
endgenerate                    

assign sum = s;
                            
endmodule
