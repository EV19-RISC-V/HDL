LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all; 
USE WORK.EV19_Types.all;

ENTITY MePipelineReg IS 
	PORT
	(
		RegWrite_ME :  IN  STD_LOGIC;
		WbSource_ME :  IN  STD_LOGIC;
		AluRes_ME   :  IN  Word_t;
		MemData_ME  :  IN  Word_t;
		Rd_ME 	    :  IN  RegIndex_t;

		RegWrite_WB :  OUT  STD_LOGIC;
		WbSource_WB :  OUT  STD_LOGIC;
		AluRes_WB   :  OUT  Word_t;
		MemData_WB  :  OUT  Word_t;
		Rd_WB 	   :  OUT  RegIndex_t;		
		PC_ME 	    :  IN  STD_LOGIC_VECTOR(31 downto 0);
		PC_WB 	    :  OUT  STD_LOGIC_VECTOR(31 downto 0);
		clk 	    :  IN  STD_LOGIC;
		reset 	    :  IN  STD_LOGIC;
		flush 	    :  IN  STD_LOGIC;
		stall 	    :  IN  STD_LOGIC
	);
END MePipelineReg;

ARCHITECTURE behaviour OF MePipelineReg IS 

begin


    process(clk)
	begin
		if rising_edge(clk) then
			if reset = '1' or flush = '1' then
				RegWrite_WB <= '0';
				WbSource_WB <= '0';
				AluRes_WB   <= (others=>'0');
				MemData_WB  <= (others=>'0');
				Rd_WB 	   <=  (others=>'0');
				PC_WB  		<= (others=>'0');
			elsif stall = '1' then
				
			elsif stall = '0' then
				RegWrite_WB <= RegWrite_ME;
				WbSource_WB <= WbSource_ME;	
				AluRes_WB   <= AluRes_ME;  	
				MemData_WB  <= MemData_ME; 	
				Rd_WB 	   <= Rd_ME; 	 
				PC_WB <= PC_ME;				
			end if;
		end if;
	end process;

END behaviour;