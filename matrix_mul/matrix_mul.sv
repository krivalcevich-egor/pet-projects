`timescale 1ns / 1ps

/////////////////////////////////////////////////////////////
// This code create N mac core elements
// and send a string 1 matrix and colomn from 2 matrix.
/////////////////////////////////////////////////////////////

module matrix_mul #(
    parameter BITS = 4, // bit depth
    parameter WIDTH = 3, // width of matrix 1 and height of matrix 2
    parameter HEIGHT_A = 2, // height of matrix 1
    parameter WIDTH_B = 3 // width of matrix 2
)(
    input logic clk, // clock
    input logic reset, // reset
    input logic [BITS-1:0] i_array_a [HEIGHT_A-1:0][WIDTH-1:0], // 1 matrix
    input logic [BITS-1:0] i_array_b [WIDTH-1:0][WIDTH_B-1:0], // 2 matrix
    output logic [2*BITS-1:0] o_array_res [HEIGHT_A-1:0][WIDTH_B-1:0] // result matrix
);

genvar i, j, k;
generate
    for (i = 0; i < HEIGHT_A; i++) begin : row
        for (j = 0; j < WIDTH_B; j++) begin : col
            logic [BITS-1:0] column_b [WIDTH-1:0];
            
            for (k = 0; k < WIDTH; k++) begin : col_extract
                assign column_b[k] = i_array_b[k][j];
            end

            mac_string #(.BITS(BITS), .WIDTH(WIDTH)) mac_str (
                .clk(clk),
                .reset(reset),
                .element_i(i_array_a[i]),
                .element_j(column_b),
                .res(o_array_res[i][j])
            );
        end
    end
endgenerate

endmodule
