LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;

ENTITY FePipelineReg IS 
    PORT
    (
        -- Señales de control
        PC_FE     		:  IN  STD_LOGIC_VECTOR(31 downto 0);
        instruction_FE	:  IN  STD_LOGIC_VECTOR(31 downto 0);
        predict_FE		:  IN  STD_LOGIC;
        State_FE    	:  IN  STD_LOGIC_VECTOR(7 downto 0);
        ---------------------------------------------------------------         
                -- Señales de control
        PC_DE     		:  OUT  STD_LOGIC_VECTOR(31 downto 0);
        instruction_DE	:  OUT  STD_LOGIC_VECTOR(31 downto 0);
        predict_DE		:  OUT  STD_LOGIC;
        State_DE    	:  OUT  STD_LOGIC_VECTOR(7 downto 0);
		 -- Control del registro de pipeline
        clk             :  IN  STD_LOGIC;
        reset           :  IN  STD_LOGIC;
        flush           :  IN  STD_LOGIC;
        stall           :  IN  STD_LOGIC
    );
END FePipelineReg;

ARCHITECTURE behaviour OF FePipelineReg IS 
begin
    process(clk)
    begin
        if rising_edge(clk) then
            if reset = '1' or flush = '1' then
            	predict_DE	  <= '0';
				State_DE      <= (others=>'0');
				PC_DE     	  <= (others=>'0');
				instruction_DE<= (others=>'0');		
            elsif stall = '1' then
                
            elsif stall = '0' then
				predict_DE	  <=  predict_FE;         	
				State_DE      <=  State_FE;
				PC_DE     	  <=  PC_FE;
				instruction_DE<=  instruction_FE;
            end if;
        end if;
    end process;

END behaviour;