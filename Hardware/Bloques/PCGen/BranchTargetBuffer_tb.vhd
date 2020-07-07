library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use IEEE.math_real.all;

entity BranchTargetBuffer_tb is
end entity BranchTargetBuffer_tb;

architecture testbench of BranchTargetBuffer_tb is

	constant clk_period : time := 10 ns;
	constant N : integer := 20;

	signal clk			:	 STD_LOGIC := '0';
	signal reset		:	 STD_LOGIC := '0';
	signal updateTarget	:	 STD_LOGIC := '0';
	signal sourcePC		:	 STD_LOGIC_VECTOR(31 DOWNTO 0) := (others => '0');
	signal targetPC		:	 STD_LOGIC_VECTOR(31 DOWNTO 0) := (others => '0');
	signal nextPC		:	 STD_LOGIC_VECTOR(31 DOWNTO 0) := (others => '0');
	signal bufferedPC	:	 STD_LOGIC_VECTOR(31 DOWNTO 0);
	signal predictedPC	:	 STD_LOGIC_VECTOR(31 DOWNTO 0);
	signal hit			:	 STD_LOGIC;
	signal prediction   :    STD_LOGIC := '0';
	signal simulationEnded : boolEAN := false;
	signal rand_num : integer := 0;

	--type array_t is array (0 TO N) OF integer;

	-- Try assigning values in one big block
	--constant PC_ARRAY : array_t := (0,1,2,0,1,2,0,1,2,3,4,5,6,4,5,6);

	COMPONENT BTB
		GENERIC ( SIZE : INTEGER := 128 );
		PORT
		(
			clk				:	 IN STD_LOGIC;
			reset			:	 IN STD_LOGIC;
			updateTarget 	:	 IN STD_LOGIC;
			sourcePC		:	 IN STD_LOGIC_VECTOR(31 DOWNTO 0);
			targetPC		:	 IN STD_LOGIC_VECTOR(31 DOWNTO 0);
			nextPC			:	 IN STD_LOGIC_VECTOR(31 DOWNTO 0);
			predictedPC		:	 OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
			hit				:	 OUT STD_LOGIC
		);
	END COMPONENT;


begin
	uut: BTB
		port map
		(
			clk				=> clk			,	
			reset			=> reset		,	
			updateTarget 	=> updateTarget ,	
			sourcePC		=> sourcePC		,		
			targetPC		=> targetPC		,		
			nextPC			=> nextPC		,	
			predictedPC		=> bufferedPC	,	
			hit				=> hit		
		);

	clkPrc: process
	begin
		clk <= '0';
		wait for clk_period / 2;
		clk <= '1';
		wait for clk_period / 2;

		if simulationEnded then
			wait;
		end if;

	end process clkPrc;

	resetPrc: process
	begin
		reset <= '1';
		wait for clk_period * 4;
		wait until rising_edge(Clk);
		reset <= '0';
		wait;
	end process resetPrc;


	randPrc: process
	    variable seed1: positive := 2;               -- seed values for random generator
	    variable seed2: positive := 15;               -- seed values for random generator
	    variable rand: real;   -- random real-number value in range 0 to 1.0  
	    variable range_of_rand : real := 1.0;    -- the range of random values created will be 0 to +1000.
	begin
	    uniform(seed1, seed2, rand);   -- generate random number
	    rand_num <= integer(rand*range_of_rand);  -- rescale to 0..1000, convert integer part 
	   wait until rising_edge(Clk);
	end process randPrc;


	predict: process(clk)
	begin
		if rising_edge(clk) then
			if rand_num = 1 then
				prediction <= '1';
			else
				prediction <= '0';
			end if;
		end if;
	end process predict;

	predictedPC <= bufferedPC when ((hit='1') and (prediction='1')) else std_logic_vector(unsigned(nextPC)+4);


	main: process
	begin
		wait until rising_edge(Clk) and reset = '0';
		
		for i in 0 to 100 loop
			if updateTarget='1' then
				updateTarget <= '0';
			end if;

			if nextPC= std_logic_vector(to_unsigned(16,32)) and hit='0' then
				nextPC <= std_logic_vector(to_unsigned(0,32));
				updateTarget <= '1';
				sourcePC <= nextPC;
				targetPC <= std_logic_vector(to_unsigned(0,32));
			elsif nextPC= std_logic_vector(to_unsigned(48,32)) and hit='0' then
				nextPC <= std_logic_vector(to_unsigned(12,32));
				updateTarget <= '1';
				sourcePC <= nextPC;
				targetPC <= std_logic_vector(to_unsigned(12,32));
			else
				nextPC <= predictedPC;
			end if;

			wait until rising_edge(Clk);
		end loop;
		

		simulationEnded <= true;
		wait;
	end process main;

end architecture testbench;
