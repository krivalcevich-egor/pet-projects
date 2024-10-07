`timescale 1ns / 1ps

/////////////////////////////////////////////////////////////
// This code describes a SPI slave module
// that receives data from the master and sends data back.
/////////////////////////////////////////////////////////////

module spi_slave (
    input logic sclk,        // SPI clock 
    input logic ss,          // Slave select
    input logic mosi,        // Master Out Slave In
    output logic miso,       // Master In Slave Out
    input logic [7:0] data_in,  // Data to be transmitted
    output logic [7:0] data_out, // Received data
    input logic cpol,        // Clock polarity selection
    input logic cpha         // Clock phase selection
);

    logic [7:0] shift_reg;  // Shift register for data
    logic [3:0] bit_cnt;    // Bit counter

    always_ff @(posedge sclk or posedge ss) begin
        if (ss) begin
            bit_cnt <= 0; 
            shift_reg <= data_in;   // Load data for transmission  
        end else begin
            data_out <= 0;
            shift_reg <= {shift_reg[6:0], mosi}; // Receive bit on MOSI
            miso <= shift_reg[7];  // Transmit bit on MISO
            bit_cnt <= bit_cnt + 1;
            if (bit_cnt == 8 & cpol == 0 & cpha == 1) begin
                data_out <= {shift_reg[6:0], mosi};  
            end else if (bit_cnt == 8 & cpol == 1 & cpha == 0) begin
                data_out <= {shift_reg[6:0], mosi};  
            end else if (bit_cnt == 7) begin
                data_out <= {shift_reg[6:0], mosi};  
            end    
        end
    end
endmodule
