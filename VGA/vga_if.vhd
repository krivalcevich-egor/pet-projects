--------------------------------------------------------------------------------
-- This module acts as an interface to the VGA module.
-- It maps the VGA module's signals to output pins, scaling down the color 
-- data widths (8-bit for each color) to the required 5-bit red, 6-bit green, 
-- and 5-bit blue output formats.
--------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity vga_if is
	port(clk	: 	in	STD_LOGIC;		-- Input clock
		vga_vs	:	out	STD_LOGIC;		-- Vertical synchronization
		vga_hs	:	out	STD_LOGIC;		-- Horizontal synchronization
		vga_r	:	out	STD_LOGIC_VECTOR(4 downto 0); -- red data
		vga_g	:	out	STD_LOGIC_VECTOR(5 downto 0); -- green data
		vga_b	:	out	STD_LOGIC_VECTOR(4 downto 0)); -- blue data
end vga_if;

architecture Behavioral of vga_if is
begin	 
	module : entity work.VGA_modul(Behavioral)
		 	port map(
			clk => clk,
			vsync => vga_vs, 
			hsync => vga_hs, 
			R(7 downto 3) => vga_r,
			R(2 downto 0) => "000",
			G(7 downto 2) => vga_g,
			G(1 downto 0) => "00",
			B(7 downto 3) => vga_b,
			B(2 downto 0) => "000"
		);
end Behavioral;
