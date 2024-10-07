module tb_async_fifo();

    localparam DATA_WIDTH = 8;
    localparam ADDR_WIDTH = 4;

    // Signals
    logic                   s_clk, m_clk, s_rst_n, m_rst_n;
    logic                   wr_en, rd_en;
    logic [DATA_WIDTH-1:0]  s_tdata, m_tdata;
    logic                   s_tlast, m_tlast;
    logic                   full, empty;

    async_fifo #(
        .DATA_WIDTH(DATA_WIDTH),
        .ADDR_WIDTH(ADDR_WIDTH)
    ) dut (
        .s_clk(s_clk),
        .s_rst_n(s_rst_n),
        .wr_en(wr_en),
        .s_tdata(s_tdata),
        .s_tlast(s_tlast),
        .m_clk(m_clk),
        .m_rst_n(m_rst_n),
        .rd_en(rd_en),
        .m_tdata(m_tdata),
        .m_tlast(m_tlast),
        .full(full),
        .empty(empty)
    );

    // generate clocks
    always #5  s_clk = ~s_clk;  // 100 MHz
    always #7  m_clk = ~m_clk;  // 71.4 MHz

    initial begin
        // initialize signals
        s_clk    = 0;
        m_clk    = 0;
        s_rst_n  = 0;
        m_rst_n  = 0;
        wr_en    = 0;
        rd_en    = 0;
        s_tdata  = 0;
        s_tlast  = 0;

        // reset
        #20;
        s_rst_n  = 1;
        m_rst_n  = 1;

        // Write data to the FIFO
        write_fifo(8'h00, 0);
        write_fifo(8'h01, 0);
        write_fifo(8'h02, 0);
        write_fifo(8'h03, 0);
        write_fifo(8'h04, 0);
        write_fifo(8'h05, 0);
        write_fifo(8'h06, 0);
        write_fifo(8'h07, 0);
        write_fifo(8'h08, 0);
        write_fifo(8'h09, 0);
        write_fifo(8'h0A, 0);
        write_fifo(8'h0B, 0);
        write_fifo(8'h0C, 0);
        write_fifo(8'h0D, 0);
        write_fifo(8'h0E, 0);
        write_fifo(8'h0F, 1); // Last flag set
        #50;

        // Read data from the FIFO
        read_fifo();
        read_fifo();
        read_fifo();
        read_fifo();
        read_fifo();
        read_fifo();
        read_fifo();
        read_fifo();
        read_fifo();
        read_fifo();
        read_fifo();
        read_fifo();
        read_fifo();
        read_fifo();
        read_fifo();
        read_fifo();
        read_fifo();
        read_fifo();

        #100;
        $finish;
    end

    // Task to write data to the FIFO
    task write_fifo(input [DATA_WIDTH-1:0] data, input bit last);
        begin
            if (!full) begin
                @(posedge s_clk);
                s_tdata = data;
                s_tlast = last;
                wr_en = 1;
                @(posedge s_clk);
                wr_en = 0;
                s_tlast = 0;
            end
        end
    endtask

    // Task to read data from the FIFO
    task read_fifo();
        begin
            if (!empty) begin
                @(posedge m_clk);
                rd_en = 1;
                @(posedge m_clk);
                rd_en = 0;
            end 
        end
    endtask

endmodule
