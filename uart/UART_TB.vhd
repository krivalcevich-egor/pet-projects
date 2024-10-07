library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.numeric_std.all;
use std.textio.all;

entity UART_TB is
end UART_TB;
 
architecture behavioral of UART_TB is

-----------------constant---------------------
  constant CLKS_PER_BIT : integer := 10;
  constant BIT_PERIOD : time := 1000 ns;
-------------------both-----------------------   
  signal Clock : std_logic := '0';
  signal reset : std_logic := '0';
--------------------RX------------------------     
  signal RX_Serial : std_logic := '1';
  signal RX_Done : std_logic := '0';
  signal RX_Byte : std_logic_vector(7 downto 0);
--------------------TX------------------------    
  signal TX_Start : std_logic := '0';
  signal TX_Serial : std_logic := '0';
  signal TX_Done : std_logic := '0';
  signal TX_Byte : std_logic_vector(7 downto 0) := (others => '0');
  
  file output_file : text;  
  
begin
--------------------------------------------
---- PROCESS: Clock                     ----
---- purpose: Generate Clock            ----
--------------------------------------------
clk: process is
    begin
    Clock <= '1'; 
        wait for 50 ns;
    Clock <= '0'; 
        wait for 50 ns;
end process clk;
               
 UART : entity work.UART 
     generic map ( CLKS_PER_BIT)
     port map ( Clk => Clock,
                Start => TX_Start,
                TX_Byte => TX_Byte,
                Reset => reset,
                TX_Serial => TX_Serial,
                TX_Done => TX_Done,
                RX_Serial => RX_Serial,
                RX_Done => RX_Done,
                RX_Byte => RX_Byte);              

--------------------------------------------
---- PROCESS: UART                      ----
---- purpose: Send and receive message  ----
--------------------------------------------
file_open(output_file, "output_VHDL.txt", WRITE_MODE);
Test: process is
        variable RX_line : line;
        variable current_byte : std_logic_vector(7 downto 0) := (others => '0');
        begin
        for i in 0 to 255 loop 
        current_byte := std_logic_vector(to_unsigned(i, current_byte'length));
-----------------------------------------------------  
        reset <= '1';
            wait for 50 ns;
        reset <= '0';
            wait for 50 ns;
-----------------------------------------------------  
        TX_Start <= '1';
        TX_Byte <= current_byte;
            wait for 50 ns;
        TX_Start <= '0';
            wait for 50 ns;
-----------------------------------------------------    
             wait for 50 ns;
        RX_Serial <= '0'; -- Send Start Bit
            wait for BIT_PERIOD;
-----------------------------------------------------     
        for byte_index in 0 to 7 loop
          RX_Serial <= TX_Byte(byte_index); -- Send Data Byte
            wait for BIT_PERIOD;
        end loop;  
        RX_Serial <= '1'; -- Send Stop Bit
            wait for BIT_PERIOD;
             wait for 50 ns;
-----------------------------------------------------            
        write(RX_line, to_integer(unsigned(RX_Byte)));
        writeline(output_file, RX_line);
        end loop;
  end process Test;
file_close(output_file);
end behavioral;

