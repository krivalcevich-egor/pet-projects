`timescale 1ns / 1ps

/////////////////////////////////////////////////////////////
// This code describes a SPI master module
// that supports configurable clock polarity (CPOL)
// and clock phase (CPHA) for data transmission.
/////////////////////////////////////////////////////////////

module spi_master (
    input logic clk,        // System clock 
    input logic rst_n,      // Reset 
    input logic [7:0] data_in,  // Data to be transmitted
    input logic start,      // Start transmission
    input logic cpol,       // Clock polarity selection
    input logic cpha,       // Clock phase selection
    output logic sclk,      // SPI clock 
    output logic mosi,      // Master Out Slave In
    input logic miso,       // Master In Slave Out
    output logic ss,        // Slave select
    output logic done,      // Transmission complete flag
    output logic [7:0] data_out  // Received data
);

    logic [7:0] shift_reg;  // Shift register for data transmission
    logic [3:0] bit_cnt;    // Bit counter
    logic busy;             // Busy flag

    // Generate SPI clock signal based on CPOL
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sclk <= cpol;  // Set initial clock state based on CPOL
        end else if (busy) begin
            sclk <= ~sclk;  // Toggle SPI clock signal
        end
    end

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            ss <= 1;           // Deactivate slave 
            busy <= 0;
            done <= 0;
            bit_cnt <= 0;
            mosi <= 0;
            data_out <= 0;
            shift_reg <= data_in;  // Load data for transmission
        end else if (start && !busy) begin
            ss <= 0;              // Activate slave
            shift_reg <= data_in; // Load data for transmission
            bit_cnt <= 0;
            busy <= 1;
            done <= 0;
            data_out <= 0;
        end else if (busy) begin
            if (!cpha) begin
                // CPHA = 0: transmit data on the rising edge
                if (sclk == cpol) begin
                    mosi <= shift_reg[7];  // Transmit bit on MOSI
                end else begin
                    // Receive bit from MISO 
                    shift_reg <= {shift_reg[6:0], miso};
                    if (bit_cnt == 8 & cpol == 1) begin
                        busy <= 0;
                        done <= 1;
                        ss <= 1;             
                        data_out <= {shift_reg[6:0], miso};  // Save received data
                    end else if (bit_cnt == 7 & cpol == 0) begin
                        busy <= 0;
                        done <= 1;
                        ss <= 1;              
                        data_out <= {shift_reg[6:0], miso};  // Save received data
                    end else begin
                        bit_cnt <= bit_cnt + 1;
                    end
                end
            end else begin
                // CPHA = 1: transmit data on the falling edge
                if (sclk != cpol) begin
                    mosi <= shift_reg[7];  // Transmit bit on MOSI
                end else begin
                    // Receive bit from MISO 
                    shift_reg <= {shift_reg[6:0], miso};
                    if (bit_cnt == 8 & cpol == 0) begin
                        busy <= 0;
                        done <= 1;
                        ss <= 1;               
                        data_out <= {shift_reg[6:0], miso};  // Save received data
                    end else if (bit_cnt == 7 & cpol == 1) begin
                        busy <= 0;
                        done <= 1;
                        ss <= 1;               
                        data_out <= {shift_reg[6:0], miso};  // Save received data
                    end else begin
                        bit_cnt <= bit_cnt + 1;
                    end
                end
            end
        end
    end
endmodule
