--------------------------------------------------------------------------------
-- This code creates an UART Transmitter.
-- Input byte of data from receiver and output a serial bit of data.
-- Also in this device uses state machine for discribe data packet.
--------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.numeric_std.all;
 
entity UART_TX is
  generic ( CLKS_PER_BIT : integer := 1);
  port ( Clk         : in  std_logic;
         Start       : in  std_logic;
         Reset       : in  std_logic;
         TX_Byte     : in  std_logic_vector(7 downto 0);         
         TX_Serial   : out std_logic;
         TX_Done     : out std_logic);
end UART_TX;
 
architecture behavioral of UART_TX is
 
  type Sate_Machine is (Delay, Start_Bit, Send_Data, Stop_Bit, Clean);
  signal State : Sate_Machine := Delay;
 
  signal Clk_Count : integer range  CLKS_PER_BIT-1 downto 0 := 0;
  signal Bit_Index : integer range 7 downto 0 := 0; 
  signal Done : std_logic := '0';
  signal Byte : std_logic_vector(7 downto 0) := (others => '0');
   
begin
----------------------------------------------------
------- PROCESS: UART_TX                     -------
------- Purpouse:  Control TX state machine  -------
----------------------------------------------------   
UART_TX : process (Clk, Reset)
  begin
  
    if Reset = '1' then
        Done <= '0';
    elsif rising_edge(Clk) then     
      case State is
-----------------------------------------------------
        when Delay =>  -- Delay
          if Start = '1' then
            State <= Start_Bit; -- Start bit detected
            Byte <= TX_Byte;
          else
            State <= Delay;
          end if;         
          TX_Serial <= '1';        
-----------------------------------------------------
        when Start_Bit =>  -- Logic for Start bit reaction
          if Clk_Count < CLKS_PER_BIT-1 then
            State <= Start_Bit; --reapet this part
            Clk_Count <= Clk_Count + 1;            
          else
            State <= Send_Data; -- go to data part
            Clk_Count <= 0;            
          end if;
          TX_Serial <= '0';          
-----------------------------------------------------
        when Send_Data => -- Logic for save data 
          if Clk_Count < CLKS_PER_BIT-1 then
            State <= Send_Data; --reapet this part
            Clk_Count <= Clk_Count + 1;
          else
            if Bit_Index < 7 then
              State <= Send_Data; --reapet this part
              Bit_Index <= Bit_Index + 1; -- inc index
            else
              State <= Stop_Bit; -- go to stop bit
              Bit_Index <= 0;
            end if;
            Clk_Count <= 0;
          end if;
          TX_Serial <= Byte(Bit_Index);
-----------------------------------------------------
        when Stop_Bit => -- Logic for stop bit
          if Clk_Count < CLKS_PER_BIT-1 then
            State <= Stop_Bit;
            Clk_Count <= Clk_Count + 1;            
          else
            State <= Clean; -- go to Clean part
            Done <= '1';
            Clk_Count <= 0;            
          end if;   
          TX_Serial <= '1';  
-----------------------------------------------------
        when Clean => -- Clean parametrs
          State   <= Delay;   
          Bit_Index <= 0;   
          Clk_Count <= 0;  
----------------------------------------------------- 
        when others =>
          State <= Delay;
      end case;
    end if;
end process UART_TX;

with State select
    TX_Done <= '0' when Delay,
               '0' when Start_Bit,
               '0' when Send_Data,
               Done when Stop_Bit,
               '1' when Clean,
               '0' when others;
 
end behavioral;