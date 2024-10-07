--------------------------------------------------------------------------------
-- This code creates an UART Receiver.
-- Input serial data from transmitter and output a byte of data.
-- Also in this device uses state machine for discribe data packet.
--------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.numeric_std.all;
 
entity UART_RX is
  generic ( CLKS_PER_BIT : integer := 1);
  port ( Clk       : in  std_logic;
         RX_Serial : in  std_logic;
         Reset     : in  std_logic;
         RX_Done   : out std_logic;
         RX_Byte   : out std_logic_vector(7 downto 0));
end UART_RX;
 
architecture behavioral of UART_RX is
 
  type Sate_Machine is (Delay, Start_Bit, Send_Data, Stop_Bit, Clean);
  signal State : Sate_Machine := Delay;
 
  signal Data_Serial : std_logic := '0';
  signal Data_Bit : std_logic := '0';
   
  signal Clk_Count : integer range  CLKS_PER_BIT-1 downto 0 := 0;
  signal Bit_Index : integer range 7 downto 0 := 0;  
  signal Byte : std_logic_vector(7 downto 0) := (others => '0');
  signal Done : std_logic := '0';
   
begin
----------------------------------------------------
---------- PROCESS: Data                  ----------
---------- Purpouse: Send data to signal  ----------
----------------------------------------------------
Data : process (Clk)
begin
  if rising_edge(Clk) then
    Data_Serial <= RX_Serial;
    Data_Bit <= Data_Serial; 
  end if; 
end process Data;

----------------------------------------------------
------- PROCESS: UART_RX                     -------
------- Purpouse:  Control RX state machine  -------
----------------------------------------------------
UART_RX : process (Clk, Reset)
  begin
  
  if Reset = '1' then
      Done <= '0';
      Byte <= "00000000";
  elsif rising_edge(Clk) then 
      case State is
-----------------------------------------------------
        when Delay =>   -- Delay
          if Data_Bit = '0' then -- Start bit detected
            State <= Start_Bit;
          else
            State <= Delay;
          end if;
------------------------------------------------------
         when Start_Bit =>  -- Logic for Start bit reaction
          if Clk_Count = (CLKS_PER_BIT-1)/2 then
            if Data_Bit = '0' then 
              State <= Send_Data; -- go to data part
              Clk_Count <= 0; 
            else
              State <= Delay; -- back to delay
            end if;
          else
            State <= Start_Bit; --reapet this part
            Clk_Count <= Clk_Count + 1;
          end if;
          Byte <= "00000000";
-------------------------------------------------------     
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
            Byte(Bit_Index) <= Data_Bit;
          end if;
-------------------------------------------------------          
        when Stop_Bit => -- Logic for stop bit
          if Clk_Count < CLKS_PER_BIT-1 then
            State <= Stop_Bit;
            Clk_Count <= Clk_Count + 1;            
          else
            State <= Clean; -- go to Clean part
            Done <= '1';
            Clk_Count <= 0;            
          end if;
-------------------------------------------------------           
        when Clean => -- Clean parametrs
          State <= Delay;
          Clk_Count <= 0;
          Bit_Index <= 0;          
-------------------------------------------------------          
        when others =>
          State <= Delay;
      end case;    
    end if;
end process UART_RX;
 
with State select
    RX_Done <= '0' when Delay,
               '0' when Start_Bit,
               '0' when Send_Data,
               Done when Stop_Bit,
               '0' when Clean,
               '0' when others;
             
with State select
     RX_Byte <= Byte when Delay,
                Byte when Start_Bit,
                Byte when Send_Data,
                Byte when Stop_Bit,
                Byte when Clean,
                "00000000" when others;             
   
end behavioral;
 