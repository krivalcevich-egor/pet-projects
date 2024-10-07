/////////////////////////////////////////////////////////////
// This code describes a asynchronous fifo
// that reading and writing transactions to be performed in 
// different time domains .
/////////////////////////////////////////////////////////////

module async_fifo #(
    parameter DATA_WIDTH = 8,
    parameter ADDR_WIDTH = 4
)(
    input  logic                   s_clk,      // Write clock
    input  logic                   s_rst_n,    // Write reset (active-low)
    input  logic                   wr_en,      // Write enable
    input  logic [DATA_WIDTH-1:0]  s_tdata,    // Data to write
    input  logic                   s_tlast,    // Write last flag

    input  logic                   m_clk,      // Read clock
    input  logic                   m_rst_n,    // Read reset (active-low)
    output logic [DATA_WIDTH-1:0]  m_tdata,    // Data to read
    output logic                   m_tlast,    // Read last flag
    input  logic                   rd_en,      // Read enable

    output logic                   full,       // FIFO full flag
    output logic                   empty       // FIFO empty flag
);
    
    logic [DATA_WIDTH-1:0]      mem [(2**ADDR_WIDTH)-1:0]; // Memory for data
    logic [(2**ADDR_WIDTH)-1:0] last_mem;                  // Memory for tlast signals
    logic [ADDR_WIDTH-1:0]      wr_addr, rd_addr;          // Write and read pointers
    logic [ADDR_WIDTH:0]        s_cnt, m_cnt;              // Write and read counters
    logic [ADDR_WIDTH:0]        s_cnt_sync, m_cnt_sync;    // Synchronized counters

    // Synchronizers for counters
    always_ff @(posedge m_clk or negedge m_rst_n) begin
        if (!m_rst_n) begin
            s_cnt_sync <= '0;
        end else begin
            s_cnt_sync <= {s_cnt_sync[ADDR_WIDTH-1:0], s_cnt};
        end
    end

    always_ff @(posedge s_clk or negedge s_rst_n) begin
        if (!s_rst_n) begin
            m_cnt_sync <= '0;
        end else begin
            m_cnt_sync <= {m_cnt_sync[ADDR_WIDTH-1:0], m_cnt};
        end
    end

    // Write operation
    always_ff @(posedge s_clk or negedge s_rst_n) begin
        if (!s_rst_n) begin
            s_cnt <= '0;
            wr_addr <= '0;
        end else if (wr_en && !full) begin
            mem[wr_addr] <= s_tdata;
            last_mem[wr_addr] <= s_tlast;
            wr_addr <= wr_addr + 1;
            s_cnt <= s_cnt + 1;
        end
    end

    // Read operation
    always_ff @(posedge m_clk or negedge m_rst_n) begin
        if (!m_rst_n) begin
            m_cnt <= '0;
            rd_addr <= '0;
            m_tdata <= '0;
            m_tlast <= '0;
        end else if (rd_en && !empty) begin
            m_tdata <= mem[rd_addr];
            m_tlast <= last_mem[rd_addr];
            rd_addr <= rd_addr + 1;
            m_cnt <= m_cnt + 1;
        end
    end

    // Full and Empty logic
    assign full  = (s_cnt[ADDR_WIDTH] != m_cnt_sync[ADDR_WIDTH]) &&
                  (s_cnt[ADDR_WIDTH-1:0] == m_cnt_sync[ADDR_WIDTH-1:0]);

    assign empty = (s_cnt_sync[ADDR_WIDTH:0] == m_cnt[ADDR_WIDTH:0]);
    
endmodule
