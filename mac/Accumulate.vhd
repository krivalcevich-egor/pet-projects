--------------------------------------------------------------------------------
-- This code creates an N bit adder with an accumulation register.
-- Input 1 element for adding and 1 for accumulated sum.
-- Also 3 input signals for controlling this module.
--------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity Accumulate is
    generic (
        N : integer := 16  -- Parameter for data width
    );
    Port (
        clk       : in  STD_LOGIC;  -- Clock 
        rst       : in  STD_LOGIC;  -- Reset 
        write_acc : in  STD_LOGIC;  -- Enable for accumulation
        addend    : in  STD_LOGIC_VECTOR(N-1 downto 0); -- Input addend
        result    : out STD_LOGIC_VECTOR(N-1 downto 0)  -- Accum result
    );
end Accumulate;


architecture Behavioral of Accumulate is
    signal accumulator : STD_LOGIC_VECTOR(N-1 downto 0) := 
                            (others => '0'); -- Accumulator register
    signal acc : STD_LOGIC_VECTOR(N-1 downto 0) := 
                            (others => '0'); -- input reg
    attribute dont_touch : string;
    attribute dont_touch of accumulator : signal is "true";
    attribute dont_touch of acc : signal is "true";
begin
    process (clk, rst)
    begin
        if rst = '1' then
            accumulator <= (others => '0');
        elsif rising_edge(clk) then
            if write_acc = '1' then
                accumulator <= accumulator + acc; 
            end if;
        end if;
    end process;
    
    acc <= addend;
    result <= accumulator; 
end Behavioral;