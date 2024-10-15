////////////////////////////////////////////////////////////////////////////////
// This module describes an LFSR (Linear Feedback Shift Register) generator 
// for an M-sequence (deg(\phi(x)) = N) based on the Fibonacci scheme.
// The chosen polynomial is: 80000923h.
////////////////////////////////////////////////////////////////////////////////


module lfsr32 #(
    parameter int N = 32       // Register bit-width
) (
    input  logic CLK,          // Clock 
    input  logic INIT,         // Synchronous initialization 
    input  logic GO,           // Enable for generation
    input  logic [N-1:0] SEED, // Initial state 
    output logic [N-1:0] Q     // Output bus
);

    logic [0:N-1] sreg;        // Register bus
    logic [N-1:0] sdat;        // Input data for the next state
    logic feedback;            // Feedback signal for LFSR


////////////////////////////////////////////////////////////////////////////////
// Initialization, generation and store modes
////////////////////////////////////////////////////////////////////////////////    
    always_ff @(posedge CLK) begin
        automatic logic t = 0;  // Temporary variable for internal state

        // Initialization: INIT = '1'
        if (INIT == 1) begin
            if (t == 0) begin
                sreg <= SEED;
                t = 1;  
            end
        end
        // Generation: INIT = '0', GO = '1'
        else if (GO == 1) begin
            if (t == 0) begin
                sreg <= sdat;  // Load next state data 
                t = 1;  
            end
        end
        // Store: INIT = '0', GO = '0'
        else begin
            t = 0;  
        end
    end


////////////////////////////////////////////////////////////////////////////////
// Generate the next LFSR state and feedback signal
////////////////////////////////////////////////////////////////////////////////
    always_comb begin
        feedback = sreg[31] ^ sreg[11] ^ sreg[8] ^ sreg[5] ^ sreg[1] ^ sreg[0];
        sdat = {feedback, sreg[0:N-2]};  
        Q = sreg; 
    end

endmodule