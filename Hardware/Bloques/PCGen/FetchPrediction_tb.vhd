library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use IEEE.math_real.all;


entity FetchPrediction_tb is
end entity FetchPrediction_tb;

architecture testbench of FetchPrediction_tb is

	type branch_t is record
		source : STD_LOGIC_VECTOR(31 DOWNTO 0);
		target : STD_LOGIC_VECTOR(31 DOWNTO 0);
		count  : integer;
		n      : integer;
	end record branch_t;
	constant NBRANCH : integer := 2;

	type branchList_t is array (0 to NBRANCH-1) of branch_t;

	constant clk_period : time := 10 ns;

	signal targetPC			:	 STD_LOGIC_VECTOR(31 DOWNTO 0):= (others =>'0');
	signal UpdateBTB		:	 STD_LOGIC := '0';


	signal Clock			:	 STD_LOGIC := '0';
	signal execTaken		:	 STD_LOGIC := '0';
	signal execUpdate		:	 STD_LOGIC := '0';
	signal execState		:	 STD_LOGIC_VECTOR(7 DOWNTO 0):= (others =>'0');
	signal execPC			:	 STD_LOGIC_VECTOR(31 DOWNTO 0):= (others =>'0');

	signal reset			:	STD_LOGIC :='0';
	signal stall			:	STD_LOGIC :='0';
	
	signal nextState		:	 STD_LOGIC_VECTOR(7 DOWNTO 0);
	signal nextPC			:	 STD_LOGIC_VECTOR(31 DOWNTO 0);
	signal prediction 		:	 STD_LOGIC;
	signal decodeState      : std_logic_vector(7 downto 0) := (others => '0');
	
	signal decodePC 		: std_logic_vector(31 downto 0) := (others => '0');

	signal decodePred		: std_logic := '0';
	signal execPred 		: std_logic := '0';
	signal simulationEnded : boolean := false;


	--type array_t is array (0 TO 19) OF integer;
	--type array7_t is array (0 TO 19) OF std_logic_vector(7 downto 0);
	--type array32_t is array (0 TO 19) OF std_logic_vector(31 downto 0);
	--type arrayL_t is array (0 TO 19) OF std_logic;

	
	--constant PC_ARRAY : array_t := 		(						0,4,8,12,				0,4,8,12,				0,4,8,12,16,20,24,28,12,36,40,44);
	--constant takenArray		: arrayL_t  := (	'0','0','0','1',		'0','0','0','1',		'0','0','0','0','0','0','0','0','0');
	--constant updateArray 	: arrayL_t  := (	'0','0','0','1',		'0','0','0','1',		'0','0','0','1','0','0','0','0','0');
	--constant targetPCArray	: array32_t	:= ( (others=>(others=>'0'))	);

	COMPONENT FetchPrediction
		PORT
		(
			targetPC		:	 IN STD_LOGIC_VECTOR(31 DOWNTO 0);
			UpdateBTB		:	 IN STD_LOGIC;
			Clock			:	 IN STD_LOGIC;
			execTaken		:	 IN STD_LOGIC;
			execUpdate		:	 IN STD_LOGIC;
			execState		:	 IN STD_LOGIC_VECTOR(7 DOWNTO 0);
			execPC			:	 IN STD_LOGIC_VECTOR(31 DOWNTO 0);
			reset			:	 IN STD_LOGIC;
			stall			:	 IN STD_LOGIC;
			nextState		:	 OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
			nextPC			:	 OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
			prediction		:	 OUT STD_LOGIC
		);
	END COMPONENT;

	BEGIN
	uut : FetchPrediction
	PORT MAP
	(
		targetPC	=> targetPC		,
		updateBTB	=> UpdateBTB	,
		Clock		=> Clock		,
		execTaken	=> execTaken	,
		execUpdate	=> execUpdate	,
		execState	=> execState	,
		execPC		=> execPC		,
		reset		=> reset		,
		stall		=> stall		,
		nextState	=> nextState	,
		nextPC		=> nextPC		,
		prediction	=> prediction	
	);	
	
	clkPrc: process
		begin
			Clock <= '0';
			wait for clk_period / 2;
			Clock <= '1';
			wait for clk_period / 2;
			if simulationEnded=true then
				wait;
			end if;
	end process clkPrc;


	resetPrc: process
	begin
		reset<= '1';
		wait for clk_period*4;
		wait until rising_edge(Clock);
		reset<= '0';
		wait;
	end process resetPrc;

	pipeline: process
		begin
		wait until reset='0';
		while simulationEnded=false loop
			wait until rising_edge(Clock);	
			execState <= decodeState;
			decodeState<= nextState;
	
			execPC <= decodePC;
			decodePC  <= nextPC;
	
			execPred <= decodePred;
			decodePred <= prediction;
		end loop;
		wait;
	end process pipeline;





	main: process
		variable count : integer := 0;
		variable branch : branch_t;
		variable isBranch : boolean;

	variable branchList : branchList_t := ((x"0000000C",x"00000000",0,2),
										   (x"0000001F",x"0000000F",0,2));

		begin
			wait until reset='0';
			wait until rising_edge(Clock) ;--and reset = '0';
			for i in 0 to 20 loop
				wait until rising_edge(Clock);
				isBranch:= false;
				for j in 0 to NBRANCH-1 loop
					branch := branchList(j);

					if decodePC=branch.source then

						targetPC <= branch.target;

						branchList(j).count:= branchList(j).count+1;

					
						if(branch.count<branch.n) then
						--if(i<3)	then
							execTaken <= '1';
							execUpdate <= '1';
							if(nextPC /= branch.target) then
								UpdateBTB <= '1';
							else 
								UpdateBTB <= '0';
							end if;
						else 
							execTaken <= '0';
							execUpdate <= '1';	
						end if;

						isBranch := true;
						exit;

					end if;
				end loop;

				if isBranch=false then
					execTaken <= '0';
					execUpdate <= '0';			
					UpdateBTB <= '0';
				end if;
			end loop;
			wait for clk_period*10;
			simulationEnded<=true;
			wait;

		end process main;




end architecture testbench;