--------------------------------------------------------------------------------
-- This code creates MAC module.
-- This module connect 3 modules: MAC controller, multiplier, accumulate.
--------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity MAC is
    generic (
        N : integer := 16  -- Parameter for data width
    );
    Port (
        clk         : in  STD_LOGIC; -- Clock 
        rst         : in  STD_LOGIC; -- Reset 
        start       : in  STD_LOGIC; -- Start 
        A           : in  STD_LOGIC_VECTOR(N-1 downto 0);-- Input A 
        B           : in  STD_LOGIC_VECTOR(N-1 downto 0);-- Input B 
        mac_result  : out STD_LOGIC_VECTOR(2*N-1 downto 0); -- MAC result
        mac_done    : out STD_LOGIC  -- MAC operation done 
    );
end MAC;


architecture Behavioral of MAC is
    signal product_AB : STD_LOGIC_VECTOR(2*N-1 downto 0); -- Product of A and B
    signal done_mpy   : STD_LOGIC; -- Multiplier done 
    signal start_mpy_o : STD_LOGIC; -- Start multiplier
    signal write_accum : STD_LOGIC; -- Accumulator write enable
    signal ready_mac_o : STD_LOGIC; -- MAC operation done
    signal acc_result : STD_LOGIC_VECTOR(2*N-1 downto 0); -- Accumulated result

begin
    mac_controller_inst: entity work.MAC_Controller
        port map (
            clk       => clk,
            rst       => rst,
            start     => start,
            ready     => done_mpy,
            start_mpy => start_mpy_o, 
            write_acc => write_accum,
            ready_mac => ready_mac_o
        );

    multiplier_inst: entity work.Multiplier
        generic map (
            N => N
        )
        port map (
            clk         => clk,
            rst         => rst,
            start_mpy   => start_mpy_o,
            A           => A,
            B           => B,
            product     => product_AB,
            ready       => done_mpy
        );

    accumulator_inst: entity work.Accumulate
        generic map (
            N => 2 * N  -- Accumulation is 2N wide
        )
        port map (
            clk         => clk,
            rst         => rst,
            write_acc   => write_accum,
            addend      => product_AB,    
            result      => acc_result 
        );

    mac_result <= acc_result;
    mac_done   <= ready_mac_o;
end Behavioral;
