LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all; 
USE WORK.EV19_Types.all;

ENTITY ExPipelineReg IS 
	PORT
	(
		RegWrite_EX :  IN  STD_LOGIC;
		WbSource_EX :  IN  STD_LOGIC;
		MemSize_EX  :  IN  MemSize_t;
		MemOp_EX    :  IN  MemOp_t;

		RegWrite_ME :  OUT  STD_LOGIC;
		WbSource_ME :  OUT  STD_LOGIC;
		MemSize_ME  :  OUT  MemSize_t;
		MemOp_ME    :  OUT  MemOp_t;


		AluRes_EX    :  IN  Word_t;
		Rs1_EX 	    :  IN  RegIndex_t;
		Rs2_EX 	    :  IN  RegIndex_t;
		Rd_EX 	    :  IN  RegIndex_t;
  
		-- Outputs  
		AluRes_ME    :  OUT  Word_t;
		Rd_ME 	    :  OUT  RegIndex_t;
		Rs1_ME 	    :  OUT  RegIndex_t;
		Rs2_ME 	    :  OUT  RegIndex_t;
		
		dMemAddress_EX 	:  IN  STD_LOGIC_VECTOR(31 downto 0);
		dMemByteEnable_EX :  IN  STD_LOGIC_VECTOR(3 downto 0);
		dMemReadReq_EX 	:  IN  STD_LOGIC;
		dMemWriteReq_EX 	:  IN  STD_LOGIC;
		dMemWriteData_EX 	:  IN  STD_LOGIC_VECTOR(31 downto 0);
		
		dMemAddress_ME 		:  OUT  STD_LOGIC_VECTOR(31 downto 0);
		dMemByteEnable_ME 	:  OUT  STD_LOGIC_VECTOR(3 downto 0);
		dMemReadReq_ME 		:  OUT  STD_LOGIC;
		dMemWriteReq_ME 	:  OUT  STD_LOGIC;
		dMemWriteData_ME	:  OUT  STD_LOGIC_VECTOR(31 downto 0);
		PC_EX 		:  IN  STD_LOGIC_VECTOR(31 downto 0);
		PC_ME 	   :  OUT  STD_LOGIC_VECTOR(31 downto 0);
		clk 	    	:  IN  STD_LOGIC;
		reset 	    :  IN  STD_LOGIC;
		flush 	    :  IN  STD_LOGIC;
		stall 	    :  IN  STD_LOGIC

	);
END ExPipelineReg;

ARCHITECTURE behaviour OF ExPipelineReg IS 

begin
    process(clk)
	begin
		if rising_edge(clk) then
			if reset = '1' or flush = '1' then
				RegWrite_ME <= '0';
				WbSource_ME <= '0';
				MemSize_ME  <= (others=>'0');
				MemOp_ME    <= (others=>'0');
				AluRes_ME   <=  (others=>'0');
				Rd_ME 	    <=  (others=>'0');
				Rs1_ME 	    <=  (others=>'0');
				Rs2_ME 	    <=  (others=>'0');
				PC_ME <=  (others=>'0');
			elsif stall = '1' then

			elsif stall = '0' then
				RegWrite_ME <= RegWrite_EX;
				WbSource_ME <= WbSource_EX;
				MemSize_ME  <= MemSize_EX;
				MemOp_ME    <= MemOp_EX;
 
				AluRes_ME   <=  AluRes_EX;
				Rd_ME 	    <=  Rd_EX; 	 
				Rs1_ME 	    <=  Rs1_EX;	 
				Rs2_ME 	    <=  Rs2_EX; 	
				PC_ME <= PC_EX;
				dMemAddress_ME 		<= dMemAddress_EX; 
				dMemByteEnable_ME 	<= dMemByteEnable_EX;
				dMemReadReq_ME 	   	<= dMemReadReq_EX; 
				dMemWriteReq_ME 	<= dMemWriteReq_EX; 
				dMemWriteData_ME	<= dMemWriteData_EX; 
			end if;
		end if;
	end process;

END behaviour;