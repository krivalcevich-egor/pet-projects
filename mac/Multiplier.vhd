--------------------------------------------------------------------------------
-- This code creates an N bit Multiplier.
-- Input 2 element for multiplier and 1 for product.
-- Also 4 input signals for controlling this module.
--------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity Multiplier is
    generic (
        N : integer := 16  -- Parameter for data width
    );
    Port (
        clk       : in  STD_LOGIC;  -- Clock 
        rst       : in  STD_LOGIC;  -- Reset 
        start_mpy : in  STD_LOGIC;  -- Start 
        A         : in  STD_LOGIC_VECTOR(N-1 downto 0); -- Multiplicand
        B         : in  STD_LOGIC_VECTOR(N-1 downto 0); -- Multiplier
        product   : out STD_LOGIC_VECTOR(2*N-1 downto 0); -- Product
        ready      : out STD_LOGIC  -- Done 
    );
end Multiplier;


architecture Behavioral of Multiplier is
    signal multiplicand    : STD_LOGIC_VECTOR(N-1 downto 0); -- Multiplicand reg
    signal multiplier      : STD_LOGIC_VECTOR(N-1 downto 0); -- Multiplier reg
    signal partial_product : STD_LOGIC_VECTOR(2*N-1 downto 0);-- Partial product
    signal extended_multiplicand : STD_LOGIC_VECTOR(N-1 downto 0) 
                                             := (others => '0'); -- Multiplicand
    signal count            : integer range 0 to N; -- Counter
    signal state            : STD_LOGIC; -- State signal
begin
    process (clk, rst)
    begin
        if rst = '1' then
            partial_product <= (others => '0');  
            multiplicand <= (others => '0');     
            multiplier <= (others => '0');       
            count <= 0;                          
            state <= '0';                        
            ready <= '0';                         
        elsif rising_edge(clk) then
            if start_mpy = '1' then
                multiplicand <= A;                  
                multiplier <= B;                    
                partial_product <= (others => '0'); 
                count <= 0;                         
                state <= '1';                      
                ready <= '0';                     
            elsif state = '1' then
                if count < N then
                    if multiplier(0) = '1' then
                        partial_product <=  multiplicand(N-1) & 
                        (partial_product(2*N-1 downto N) + multiplicand) &
                          partial_product(N-1 downto 1);
                    elsif count = 0 then
                        partial_product <='0' & partial_product(2*N-1 downto 1); 
                    else
                        partial_product <= multiplicand(N-1) & 
                                partial_product(2*N-1 downto 1); 
                    end if;
                    
                    multiplier <= '0' & multiplier(N-1 downto 1); 
                    count <= count + 1;                          

                else
                    -- Correction step if B is negative
                    if B(N-1) = '1' then
                        partial_product <= partial_product - 
                                        (multiplicand & extended_multiplicand); 
                    end if;
                    state <= '0'; 
                    ready <= '1';   
                end if;
            end if;
        end if;
    end process;

    product <= partial_product; 
end Behavioral;