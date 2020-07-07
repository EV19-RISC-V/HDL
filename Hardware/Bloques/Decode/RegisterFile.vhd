LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;


ENTITY RegisterFile IS
	PORT
	(
	A1  : IN STD_LOGIC_VECTOR(4 downto 0);
	A2  : IN STD_LOGIC_VECTOR(4 downto 0);
	WE  : IN STD_LOGIC;
	WD3 : IN STD_LOGIC_VECTOR(31 downto 0);
	A3  : IN STD_LOGIC_VECTOR(4 downto 0);
	CLK : IN STD_LOGIC;
	RD1 : OUT STD_LOGIC_VECTOR(31 downto 0);
	RD2 : OUT STD_LOGIC_VECTOR(31 downto 0)
	);
END RegisterFile;


ARCHITECTURE behaviour OF RegisterFile IS

type RegisterFile_t is array (0 to 31) of std_logic_vector(31 downto 0);
BEGIN


		PROCESS(CLK)
		variable registers: RegisterFile_t :=  ((others=> (others=>'0')));

		BEGIN
			if rising_edge(clk) then
				if WE='1' and A3 /= b"00000" then
					registers(to_integer(unsigned(A3))) := WD3;
				end if;
					RD1 <= registers(to_integer(unsigned(A1)));
					RD2 <= registers(to_integer(unsigned(A2)));	
			end if;
		END PROCESS;


END behaviour;
