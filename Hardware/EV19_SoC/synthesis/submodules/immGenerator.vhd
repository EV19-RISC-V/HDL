library ieee;
use ieee.std_logic_1164.all;

entity immGenerator is
	port (
		instruction : in std_logic_vector(31 downto 0);
		immediate : out std_logic_vector(31 downto 0)
		);
end immGenerator;


architecture behaviour of immGenerator is
begin
with instruction(6 downto 2) select
				-- I type
immediate <=	((31 downto 11 => instruction(31)) & instruction(30 downto 20)) 
				when "11001" | "00000" | "00100" | "11100", 	 	
				-- S TYPE	
				((31 downto 11 => instruction(31)) & instruction(30 downto 25) & instruction(11 downto 7))
				when "01000",	
				-- B TYPE
				((31 downto 12 => instruction(31)) & instruction(7) & instruction(30 downto 25) & instruction(11 downto 8) & '0')
				when "11000",			   
				-- U TYPE
				(instruction(31 downto 12) & (11 downto 0 => '0'))
				when "01101" | "00101",		 
				-- J TYPE
				((31 downto 20 => instruction(31)) & instruction(19 downto 12) & instruction(20) & instruction(30 downto 21) & '0')
				when "11011",	
				(others => '0') when others;
	
end behaviour;