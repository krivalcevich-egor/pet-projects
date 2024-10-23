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
    signal pp : STD_LOGIC_VECTOR(2*N-1 downto 0);-- Partial product
    signal count            : integer range 0 to N; -- Counter
    signal state            : STD_LOGIC; -- State signal
begin

--------------------------------------------------------------------------------
-- Partial product and state
-------------------------------------------------------------------------------- 
    process (clk, rst)
    begin                     
        if rising_edge(clk) then
             if rst = '1' then
                pp <= (others => '0');                                    
                state <= '0';                        
            elsif start_mpy = '1' then
                    state <= '1';                   
                    if B(0) = '1' then
                        pp <=  A(N-1) & (pp(2*N-1 downto N) + A) 
                                              & pp(N-1 downto 1);
                    elsif count = 0 then
                        pp <='0' & pp(2*N-1 downto 1); 
                    else
                        pp <= A(N-1) & pp(2*N-1 downto 1); 
                    end if;
            elsif state = '1' then                         
                if count < N - 1 then
                    if multiplier(0) = '1' then
                        pp <=  multiplicand(N-1) & (pp(2*N-1 downto N) + 
                                            multiplicand) & pp(N-1 downto 1);
                    elsif count = 0 then
                        pp <='0' & pp(2*N-1 downto 1); 
                    elsif B = 0 then
                        pp <= (others => '0');        
                    else
                        pp <= multiplicand(N-1) &  pp(2*N-1 downto 1); 
                    end if;
                end if;
                if (count = N - 1) then
                    if multiplier(0) = '1' then
                        if B(N-1) = '1' then
                           pp <=  (B(N-1) xor A(N-1)) & (pp(2*N-1 downto N) - 
                                            multiplicand) & pp(N-1 downto 1);                       
                        else 
                            pp <=  multiplicand(N-1) & (pp(2*N-1 downto N) + 
                                            multiplicand) & pp(N-1 downto 1);
                         end if;
                     elsif B = 0 then
                         pp <= (others => '0');     
                     else
                         pp <= multiplicand(N-1) &  pp(2*N-1 downto 1); 
                     end if;                     
                    state <= '0';   
                end if;
            end if;
        end if;
    end process;

--------------------------------------------------------------------------------
-- Output
-------------------------------------------------------------------------------- 
    process (clk, rst)
    begin                     
        if rising_edge(clk) then
             if rst = '1' then
                product <= (others => '0');
             else
                product <= pp;  
             end if;
        end if;  
     end process;
     
--------------------------------------------------------------------------------
-- READY flag
--------------------------------------------------------------------------------    
    process (clk, rst)
     begin                     
         if rising_edge(clk) then
            if rst = '1' then
                ready <= '0'; 
            elsif (count = N - 1) then
                ready <= '1';
            else
                ready <= '0';
            end if;
         end if;  
      end process; 

--------------------------------------------------------------------------------
-- COUNTER
--------------------------------------------------------------------------------    
    process (clk, rst)
     begin                     
         if rising_edge(clk) then
            if rst = '1' then
                count <= 0; 
            elsif (count = N - 1) then
                count <= 0; 
            elsif (start_mpy = '1' and state = '0') then
                count <= count + 1;
            elsif (state = '1') then
                count <= count + 1;
            else      
                count <= 0;
            end if;
         end if;  
      end process; 

--------------------------------------------------------------------------------
-- Multiplier
-------------------------------------------------------------------------------- 
    process (clk, rst)
    begin                     
        if rising_edge(clk) then
             if rst = '1' then
                multiplier <= (others => '0');
             elsif (start_mpy = '1') then
                multiplier <= B(N-1) & B(N-1 downto 1); 
             else 
                multiplier <= B(N-1) & multiplier(N-1 downto 1);
             end if;
        end if;  
     end process;
     
--------------------------------------------------------------------------------
-- Multiplicand
-------------------------------------------------------------------------------- 
    process (clk, rst)
    begin                     
        if rising_edge(clk) then
             if rst = '1' then
                multiplicand <= (others => '0'); 
             else
                multiplicand <= A;   
             end if;
        end if;  
     end process;      
                           
end Behavioral;