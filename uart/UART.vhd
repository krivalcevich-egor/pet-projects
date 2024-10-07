--------------------------------------------------------------------------------
-- This code creates UART module.
-- This module connect 2 modules: UART Receiverand UART Transmitter.
--------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.numeric_std.all;


entity UART is
  generic ( CLKS_PER_BIT : integer := 1);
  port ( Clk       : in  std_logic;
         RX_Serial : in  std_logic;
         Reset     : in  std_logic;
         RX_Done   : out std_logic;
         RX_Byte   : out std_logic_vector(7 downto 0);
         Start     : in  std_logic;
         TX_Byte   : in  std_logic_vector(7 downto 0);         
         TX_Serial : out std_logic;
         TX_Done   : out std_logic);
end UART;

architecture Behavioral of UART is

begin

RX : entity work.UART_RX
    generic map (CLKS_PER_BIT)
    port map ( Clk => Clk,
               RX_Serial => RX_Serial,
               Reset => reset,
               RX_Done => RX_Done,
               RX_Byte => RX_Byte);
               
TX : entity work.UART_TX 
    generic map ( CLKS_PER_BIT)
    port map ( Clk => Clk,
               Start => Start,
               TX_Byte => TX_Byte,
               Reset => reset,
               TX_Serial => TX_Serial,
               TX_Done => TX_Done);
               

end Behavioral;
