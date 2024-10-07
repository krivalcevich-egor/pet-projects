library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity MAC_tb is
end MAC_tb;

architecture Behavioral of MAC_tb is
    
    constant N : integer := 16;  -- Bit width for inputs 

    signal clk         : STD_LOGIC := '0';
    signal rst         : STD_LOGIC := '0';
    signal start       : STD_LOGIC := '0';
    signal A           : STD_LOGIC_VECTOR(N-1 downto 0);
    signal B           : STD_LOGIC_VECTOR(N-1 downto 0);
    signal mac_result  : STD_LOGIC_VECTOR(2*N-1 downto 0);
    signal mac_done    : STD_LOGIC;

    constant clk_period : time := 10 ns;
begin

    DUT: entity work.MAC
        generic map (
            N => N  
        )
        port map (
            clk        => clk,
            rst        => rst,
            start      => start,
            A          => A,
            B          => B,
            mac_result => mac_result,
            mac_done   => mac_done
        );

    clk_process : process
    begin
        clk <= '0';
        wait for clk_period / 2;
        clk <= '1';
        wait for clk_period / 2;
    end process clk_process;

    stimulus_process : process
    begin
        rst <= '1';       -- Assert reset
        wait for clk_period * 2;
        rst <= '0';       -- Deassert reset
        wait for clk_period * 2;

        A <= x"0003";     -- A = 3
        B <= x"0002";     -- B = 2
        start <= '1';     
        wait for clk_period;
        start <= '0';     
        wait until mac_done = '1';
        wait for clk_period;

        A <= x"0004";     -- A = 4
        B <= x"0003";     -- B = 3
        start <= '1';     
        wait for clk_period;
        start <= '0';     
        wait until mac_done = '1';
        wait for clk_period;

        A <= x"0005";     -- A = 5
        B <= x"0004";     -- B = 4
        start <= '1';     
        wait for clk_period;
        start <= '0';     
        wait until mac_done = '1';
        wait for clk_period;

        rst <= '1';       
        wait for clk_period * 2;
        rst <= '0';       
        wait for clk_period * 2;

        A <= x"FF73";     -- A = -141
        B <= x"0002";     -- B = 2
        start <= '1';     
        wait for clk_period;
        start <= '0';    
        wait until mac_done = '1';
        wait for clk_period;

        A <= x"0012";     -- A = 18
        B <= x"FFFB";     -- B = -5
        start <= '1';     
        wait for clk_period;
        start <= '0';    
        wait until mac_done = '1';
        wait for clk_period;

        A <= x"FFFF";     -- A = -1
        B <= x"FFFD";     -- B = -3
        start <= '1';    
        wait for clk_period;
        start <= '0';     
        wait until mac_done = '1';
        wait for clk_period;

        wait;
    end process;

end Behavioral;
