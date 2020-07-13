library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ALU_ExtendBit is

	generic
	(
		DATA_WIDTH : natural := 32
	);

	port 
	(
		inBit	: in std_logic;
		outBus : out std_logic_vector ((DATA_WIDTH-1) downto 0)
	);
end entity;

architecture behave of ALU_ExtendBit is
begin
		outBus <= (0 => inBit, others => '0');
end behave;
