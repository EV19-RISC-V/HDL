LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all; 

ENTITY GenPipelineReg IS 
	GENERIC(
		RESET_ADDRESS	: STD_LOGIC_VECTOR(31 downto 0) := x"00000000");
	PORT
	(
		PC_GEN      :  IN  STD_LOGIC_VECTOR(31 downto 0);
		Predict_GEN :  IN  STD_LOGIC;
		State_GEN  :  IN  STD_LOGIC_VECTOR(7 downto 0);
		
		PC_FE       :  OUT  STD_LOGIC_VECTOR(31 downto 0);
		Predict_FE  :  OUT  STD_LOGIC;
		State_FE   :  OUT  STD_LOGIC_VECTOR(7 downto 0);
		
		
		clk 	      :  IN  STD_LOGIC;
		reset 	   :  IN  STD_LOGIC;
		flush 	   :  IN  STD_LOGIC;
		stall 	   :  IN  STD_LOGIC
	);
END GenPipelineReg;

ARCHITECTURE behaviour OF GenPipelineReg IS 

begin


    process(clk)
	begin
		if rising_edge(clk) then
			if reset = '1' or flush = '1' then
				PC_FE      <= RESET_ADDRESS;
				predict_FE <= '0';
				State_FE  <= (others=>'0');
				
			elsif stall = '1' then
				
			elsif stall = '0' then
				PC_FE      <= PC_GEN;
				Predict_FE <= Predict_GEN;
				State_FE  <= State_GEN;		
			end if;
		end if;
	end process;

END behaviour;