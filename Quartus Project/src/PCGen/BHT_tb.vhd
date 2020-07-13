library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use IEEE.math_real.all;


entity BHT_tb is
end entity BHT_tb;

architecture testbench of BHT_tb is

		constant clk_period : time := 10 ns;
		
		signal update  :  std_logic := '0';
		signal clock	: 	std_logic := '0';
		signal taken 	:  std_logic := '0';
		signal reset 	: std_logic := '0';
		signal execState	: std_logic_vector(7 downto 0)  := (others => '0');
		signal execPC		: std_logic_vector(31 downto 0) := (others => '0');
		signal fetchPC		: std_logic_vector(31 downto 0) := (others => '0');
		signal take     : std_logic;
		signal nextStateOut : std_logic_vector(7 downto 0);
		shared variable simulationEnded : boolean := false;
		
		signal fetchState : std_logic_vector(7 downto 0) := (others => '0');
		signal decodeState : std_logic_vector(7 downto 0) := (others => '0');
		signal A : std_logic_vector(7 downto 0) := (others => '0');
		
		type array_t is array (0 TO 19) OF integer;
		type array7_t is array (0 TO 19) OF std_logic_vector(7 downto 0);
		type arrayL_t is array (0 TO 19) OF std_logic;

		
		constant PC_ARRAY : array_t := 		(						0,4,8,12,				0,4,8,12,				0,4,8,12,16,20,24,28,12,36,40,44);
		constant takenArray : arrayL_t :=	('0','0','0',		'0','0','0','1',		'0','0','0','1',		'0','0','0','0','0','0','0','0','0');
		constant updateArray : arrayL_t := ('0','0','0',		'0','0','0','1',		'0','0','0','1',		'0','0','0','1','0','0','0','0','0');
		
		component BHT
			port
			(
				update   : in std_logic;
				clock		: in std_logic;
				taken 	: in std_logic;
				reset		: in std_logic;
				execState 	: in std_logic_vector(7 downto 0);
				execPC 	 	: in  std_logic_vector(31 downto 0);
				fetchPC  	: in  std_logic_vector(31 downto 0);
				
				-- taken output
				take     : out std_logic;
				nextStateOut : out std_logic_vector(7 downto 0)
			
			);
		end component;
		
		
		
		begin
		uut: BHT
			port map
			(
				update   => update,
				clock		=> clock,
				taken 	=> taken,
				reset		=> reset,
				execState => execState,
				execPC   => execPC,
				fetchPC  => fetchPC,
				
				take => take,
				nextStateOut => nextStateOut
			);
		
		
		
		clkPrc: process
		begin
			clock <= '0';
			wait for clk_period / 2;
			clock <= '1';
			wait for clk_period / 2;
			if simulationEnded = true then
				wait;
			end if;
		end process clkPrc;
	
	
		resetPrc: process
		begin
			reset <= '1';
			wait for clk_period;
			wait until rising_edge(clock);
			reset <= '0';
			wait;
		end process resetPrc;

	
		pipeline: process(clock)
		begin
			if(rising_edge(clock)) then
				execState <= decodeState;
				decodeState<=nextStateOut;
				--decodeState <= fetchState;
				--fetchState <= nextStateOut;
			end if;
		end process pipeline;
	
		main: process
		--variable NXT_STATEA : array7_t := (others => "00000000");
		begin
			wait until rising_edge(clock) and reset = '0';
			for i in 0 to 19 loop
				fetchPC<= std_logic_vector(to_unsigned(PC_ARRAY(i),32));
				if(i>2) then
					execPC<= std_logic_vector(to_unsigned(PC_ARRAY(i-3),32));
				end if;
				taken <= takenArray(i);
				update <= updateArray(i);
			
			
	
				
			
				wait until rising_edge(clock);
			
				taken <= '0';
				update <= '0';
			
			end loop;
			simulationEnded:=true;
			wait;
		end process main;

		end architecture testbench;
		
		