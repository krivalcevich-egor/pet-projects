`timescale 1ns / 1ps

/////////////////////////////////////////////////////////////
// This code describe mac module, that
// take a string and colomn. After that 
// mac core calculate partial sum.
///////////////////////////////////////////////////////////

module mac_string #(
    parameter int BITS = 24, // bit depth
    parameter WIDTH = 3
)(
    input logic clk, // clock
    input logic reset, // reset
    input logic [BITS-1:0] element_i [WIDTH-1:0], // string 1 matrix
    input logic [BITS-1:0] element_j [WIDTH-1:0], // colomn 2 matrix
    output logic [2*BITS-1:0] res // result of mux
);

logic [2*BITS-1:0] prev_acc; // previus accumulater
logic [BITS-1:0] element_1; // element of string
logic [BITS-1:0] element_2; // element of colomn
logic [3:0] i; // index
logic [2*BITS-1:0] partial_sum; // mac result

mac_core #(.BITS(BITS)) mac (
    .clk(clk),
    .reset(reset),
    .element_i(element_1),
    .element_j(element_2),
    .prev_acc(prev_acc),
    .acc(partial_sum)
);

always_ff @(posedge clk or negedge reset) begin
    if (!reset) begin
        element_1 <= 0;
        element_2 <= 0;
        prev_acc <= 0;
        res <= 0;
        i <= 0;
    end else begin
        if (i < WIDTH) begin
            element_1 <= element_i[i];
            element_2 <= element_j[i];
            prev_acc <= (i == 0) ? 0 : partial_sum;
            res <= partial_sum;
            i <= i + 1;
        end else begin
            res <= partial_sum;
        end
    end
end

endmodule
