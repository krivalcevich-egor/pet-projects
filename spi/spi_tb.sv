module spi_tb;

    // Inputs for the master
    logic clk;
    logic rst_n;
    logic [7:0] data_in_master;
    logic start;
    logic cpol;  // Clock polarity (0 or 1)
    logic cpha;  // Clock phase (0 or 1)

    // Outputs from the master
    logic sclk;
    logic mosi;
    logic ss;
    logic done;
    logic [7:0] data_out_master;

    // Inputs for the slave
    logic [7:0] data_in_slave;

    // Outputs from the slave
    logic [7:0] data_out_slave;

    // Internal signals
    logic miso_slave;

    spi_master master_inst (
        .clk(clk),
        .rst_n(rst_n),
        .data_in(data_in_master),
        .start(start),
        .sclk(sclk),
        .mosi(mosi),        // Data to the slave
        .miso(miso_slave),  // Data from the slave
        .ss(ss),
        .done(done),
        .data_out(data_out_master),
        .cpol(cpol),  // SCLK polarity
        .cpha(cpha)   // SCLK phase
    );

    spi_slave slave_inst (
        .sclk(sclk),
        .ss(ss),
        .mosi(mosi),         // Data from the master
        .miso(miso_slave),   // Data to the master
        .data_in(data_in_slave),
        .data_out(data_out_slave),
        .cpol(cpol),         // SCLK polarity
        .cpha(cpha)          // SCLK phase
    );

    always #10 clk = ~clk;

    initial begin
        clk = 0;
        rst_n = 0;
        start = 0;
        data_in_master = 8'b11101010;  // 0xEA
        data_in_slave = 8'b11001100;   // 0xCC
        cpol = 0;  
        cpha = 0;  
        #50;

        rst_n = 1;
        #50;

        start = 1;
        #20;
        start = 0;
        wait(done);

        data_in_master = 8'b10001000;  // 0x88
        data_in_slave = 8'b11000110;   // 0xC6
        cpol = 1;  
        cpha = 1;  
        #50;

        start = 1;
        #20;
        start = 0;
        wait(done);

        data_in_master = 8'b00001000;  // 0x08
        data_in_slave = 8'b01111110;   // 0x7E
        cpol = 1; 
        cpha = 0; 
        #50;
        
        start = 1;
        #20;
        start = 0;
        wait(done);

        data_in_master = 8'b11111011;  // 0xFB
        data_in_slave = 8'b01000000;   // 0x40
        cpol = 0;  
        cpha = 1;  
        #50;

        start = 1;
        #20;
        start = 0;
        wait(done);

        #100;
        $finish;
    end
endmodule
