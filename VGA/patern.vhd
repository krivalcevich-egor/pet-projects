--------------------------------------------------------------------------------
-- This module generates a pattern for video output based on pixel coordinates
-- and active signal. It switches between white and black colors depending
-- on the position of the pixel and synchronization signals.
--------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity patern is
 port( clk              : in  STD_LOGIC;
       H_PIXEL_COUNT    : in  STD_LOGIC_VECTOR(11 downto 0);  -- Horizontal sync
       V_PIXEL_COUNT    : in  STD_LOGIC_VECTOR(10 downto 0);  -- Vertical sync
       H_PIXEL_P        : in  STD_LOGIC_VECTOR(11 downto 0);  -- Horizontal sync
       V_PIXEL_P        : in  STD_LOGIC_VECTOR(10 downto 0);  -- Vertical sync
       Active           : in STD_LOGIC:='0';                  -- Active signal
       Red              : out STD_LOGIC_VECTOR(7 downto 0);   -- red data
       Green            : out STD_LOGIC_VECTOR(7 downto 0);   -- green data
       Blue             : out STD_LOGIC_VECTOR(7 downto 0)    -- blue data
 );
end patern;

architecture Behavioral of patern is

    constant SCREEN_WIDTH  : INTEGER := 1680;
    constant SCREEN_HEIGHT : INTEGER := 1050;
    constant Block_size_h  : INTEGER := SCREEN_WIDTH / 8;
    constant Block_size_v  : INTEGER := SCREEN_HEIGHT / 7;
    constant H_WholeLine   : INTEGER	:=	2256;	-- whole number of pixels
    constant V_WholeLine   : INTEGER	:=	1087;	-- whole number of lines
    	
    signal h_block_begin   : STD_LOGIC_VECTOR(10 downto 0) := (others=>'0');
    signal h_block_end     : STD_LOGIC_VECTOR(10 downto 0) := "00011010001";
    signal v_block_begin   : STD_LOGIC_VECTOR(10 downto 0) := (others=>'0');
    signal v_block_end     : STD_LOGIC_VECTOR(10 downto 0) := "00010010110";
        
    signal is_white        : Boolean := true;
    
begin
----------------------------------
---- PROCESS: patern_gen      ----
---- PURPOSR: Generate patern ----
----------------------------------
patern_gen: process(clk)
        begin
            -- Chouse color (black or white)
            if (H_PIXEL_COUNT = 0) and (V_PIXEL_COUNT < SCREEN_HEIGHT) then
                if (is_white) then 
                    Red <= (others => '0');
                    Green <= (others => '0');
                    Blue <= (others => '0');
                else
                    Red <= (others => '1');
                    Green <= (others => '1');
                    Blue <= (others => '1');
                end if;   
            end if;
            -- Swap color for a checkerboard effect
            if rising_edge(clk) then
                if (V_PIXEL_COUNT = v_block_end - 1) and (H_PIXEL_COUNT = H_WholeLine - 1) then
                    is_white <= not is_white;
                end if;  
                if (V_PIXEL_COUNT = V_WholeLine) and (H_PIXEL_COUNT = H_WholeLine - 1) then
                    is_white <= not is_white;
                end if; 
                if Active = '1' then
                 if (is_white) then 
                    Red <= (others => '0');
                    Green <= (others => '0');
                    Blue <= (others => '0');
                else
                    Red <= (others => '1');
                    Green <= (others => '1');
                    Blue <= (others => '1');
                end if;    
                -- Update blocks cooedinates and add color to pixel           
                if (H_PIXEL_P >= h_block_begin and H_PIXEL_P < h_block_end) then
                    if (V_PIXEL_P >= v_block_begin and V_PIXEL_P < v_block_end) then
                        is_white <= is_white;
                    else
                        v_block_begin <= v_block_end;
                        v_block_end <= v_block_end + Block_size_v;
                        if(v_block_end = SCREEN_HEIGHT) then
                            v_block_begin <= (others=>'0');
                            v_block_end <=  (others=>'0');
                        end if;
                    end if;
                    if (H_PIXEL_P = h_block_end - 1) then
                        is_white <= not is_white;
                    end if;
                    else
                        h_block_begin <= h_block_begin + Block_size_h;
                        h_block_end <= h_block_end + Block_size_h;
                        if(h_block_end = SCREEN_WIDTH-1) then
                            h_block_begin <= (others=>'0');
                            h_block_end <=  (others=>'0');
                            Red <= (others => 'Z');
                            Green <= (others => 'Z');
                            Blue <= (others => 'Z');
                        end if;
                end if;           
                else
                    -- Update blocks cooedinates
                    if(h_block_end = h_block_begin) then
                        h_block_end <= h_block_end + Block_size_h - 1;
                    end if;     
                    if(v_block_end = v_block_begin) then
                        v_block_end <= v_block_end + Block_size_v;
                    end if;    
                        Red <= (others => 'Z');
                        Green <= (others => 'Z');
                        Blue <= (others => 'Z');
                end if;
            end if; 
    end process patern_gen;
end Behavioral;
