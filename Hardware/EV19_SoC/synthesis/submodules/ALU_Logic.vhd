library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ALU_Logic is

	generic
	(
		DATA_WIDTH : natural := 32
	);

	port 
	(
		a	   : in std_logic_vector	((DATA_WIDTH-1) downto 0);
		b	   : in std_logic_vector	((DATA_WIDTH-1) downto 0);
		andOut : out std_logic_vector ((DATA_WIDTH-1) downto 0);
		orOut : out std_logic_vector ((DATA_WIDTH-1) downto 0);
		xorOut : out std_logic_vector ((DATA_WIDTH-1) downto 0)
	);

end entity;

architecture behave of ALU_Logic is
begin
	andOut <= a and b;
	orOut <= a or b;
	xorOut <= a xor b;
end behave;
