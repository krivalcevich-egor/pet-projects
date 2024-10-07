--------------------------------------------------------------------------------
-- This module generates horizontal and vertical synchronization signals for 
-- VGA output. It also tracks pixel positions on the screen and coordinates 
-- the color output for each pixel by communicating with the 'patern' entity.
--------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

entity VGA_modul is
	port(	clk	    : 	in	STD_LOGIC;		-- Input clock
			vsync	:	out	STD_LOGIC;		-- Vertical synchronization
			hsync	:	out	STD_LOGIC;		-- Horizontal synchronization
			R		:	out	STD_LOGIC_VECTOR(7downto 0); -- red data
			G		:	out	STD_LOGIC_VECTOR(7downto 0); -- green data
			B		:	out	STD_LOGIC_VECTOR(7downto 0)); -- blue data
end VGA_modul;

architecture Behavioral of VGA_modul is

-- Horizontal
	constant H_Resolutin	:	integer	:=	1680; -- H resolution
	constant H_FrontPorch	:	integer	:=	104;	-- porch befor image
	constant H_SyncPulse    :	integer	:=	184;	-- sinhronization signal
	constant H_BackPorch	:	integer	:=	288;	-- porch after image
	constant H_WholeLine	:	integer	:=	2256;	-- whole number of pixels
	constant H_polarity    	:	STD_LOGIC	:=	'0';	-- sync pulse polsrity
-- Vertical
	constant V_Resolutin	:	integer	:=	1050;	-- V resolution
	constant V_FrontPorch	:	integer	:=	1;		-- porch befor image
	constant V_SyncPulse	:	integer	:=	3;		-- sinhronization signal
	constant V_BackPorch	:	integer	:=	33;	-- porch after image
	constant V_WholeLine	:	integer	:=	1087;	-- whole number of lines
	constant V_polarity    	:	STD_LOGIC	:=	'1';	-- sync pulse polsrity
	
-- counters
	signal h_count	:	STD_LOGIC_VECTOR(11 downto 0)	:= (others=>'0');
	signal v_count	:	STD_LOGIC_VECTOR(10 downto 0)	:= (others=>'0');
	
-- informative about active window
	signal	active_window	:	STD_LOGIC:='0';
	
-- pixel 
	signal h_pixel	:	STD_LOGIC_VECTOR(11 downto 0)	:= (others=>'0');
	signal v_pixel	:	STD_LOGIC_VECTOR(10 downto 0)	:= (others=>'0');
	
begin
	module : entity work.patern(Behavioral)
         port map(
        clk => clk,
        H_PIXEL_COUNT => h_count,   
        V_PIXEL_COUNT => v_count,  
        H_PIXEL_P => h_pixel, 
        V_PIXEL_P => v_pixel,  
        Active => active_window,
        Red => R,
        Green => G,
        Blue => B
    );
    
---------------------------------------------------
-- PROCESS: COUNT_PR                           ----
-- PURPOSE: count h and v position             ----
---------------------------------------------------
COUNT_PR: process(clk)
begin
	if (clk'event and clk = '1') then
		if h_count < H_WholeLine - 1 then
			h_count <= h_count + 1;
		else
			h_count <= (others=>'0');
			if	v_count<= V_WholeLine - 1 then
				v_count <= v_count + 1;
			else
				v_count <= (others=>'0');
			end if;
		end if;
	end if;
end process COUNT_PR;

hsync	<= H_polarity when (h_count >= (H_FrontPorch + H_Resolutin) and 
    h_count < (H_FrontPorch + H_Resolutin + H_SyncPulse)) else not H_polarity;
vsync	<= V_polarity when (v_count >= (V_FrontPorch + V_Resolutin) and 
    v_count < (V_FrontPorch + V_Resolutin + V_SyncPulse)) else not V_polarity;

-- check active window
active_window <= '1' when(h_count<H_Resolutin and v_count<V_Resolutin) else '0';

---------------------------------------------------
---- PROCESS: OUTPUT_COLORS                    ----
---- PURPOSE: output image colors              ----
---------------------------------------------------
OUTPUT_COLORS: process(clk)
begin
	if (rising_edge(clk)) then
		if active_window = '1' then
			if h_pixel = H_Resolutin - 1  then
				h_pixel <= (others=>'0');
				if	v_pixel = V_Resolutin - 1  then
					v_pixel <= (others=>'0');
				else
					v_pixel <= v_pixel + 1;
				end if;
			else
				h_pixel <= h_pixel + 1;
			end if;
		end if;
	end if;
end process OUTPUT_COLORS;

end Behavioral;
