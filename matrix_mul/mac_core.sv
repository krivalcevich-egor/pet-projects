`timescale 1ns / 1ps

/////////////////////////////////////////////////////////////
// This code describe mac core with
// input 2 elements for multiplication and 1 for sum.
/////////////////////////////////////////////////////////////

(* use_dsp = "yes" *)
module mac_core #(
    parameter int BITS = 24 // bit depth
)(
    input logic clk, // clock
    input logic reset, // reset
    input logic [BITS-1:0] element_i, // first element
    input logic [BITS-1:0] element_j, // second element
    input logic [2*BITS-1:0] prev_acc, // previus accumulator
    output logic [2*BITS-1:0] acc // accumulator
);


always_ff @(posedge clk or negedge reset) begin
    if (!reset) begin
        acc <= 0;
    end else begin
        acc = signed'(prev_acc) + signed'(element_i) * signed'(element_j); // MAC operation
    end
end

endmodule
