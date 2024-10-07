library ieee;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
 
entity test_VGA_modul is
end test_VGA_modul;
 
architecture behavior of test_VGA_modul is 
 
    component VGA_modul
    port(
         clk   : in   std_logic;
         vsync : out  std_logic;
         hsync : out  std_logic;
         R     : out  std_logic_vector(7 downto 0);
         G     : out  std_logic_vector(7 downto 0);
         B     : out  std_logic_vector(7 downto 0)
        );
    end component;
    
   --Inputs
   signal clk : std_logic := '0';

 	--Outputs
   signal vsync : std_logic;
   signal hsync : std_logic;
   signal R : std_logic_vector(7 downto 0);
   signal G : std_logic_vector(7 downto 0);
   signal B : std_logic_vector(7 downto 0);
 
BEGIN
 
   uut: VGA_modul port map (
          clk => clk,
          vsync => vsync,
          hsync => hsync,
          R => R,
          G => G,
          B => B
        );

---------------------------------------------------
---- PROCESS: CLK_PROCESS                      ----
---- PURPOSE: generate clk                     ----
---------------------------------------------------
CLK_PROCESS :process
begin
	clk <= '0';
	wait for 1 ns;
	clk <= '1';
	wait for 1 ns;
end process CLK_PROCESS;

end;
