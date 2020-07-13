library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity BHT is
	generic(
		SIZE	: natural := 128 ; --! Number of PCs for which the previous actions are stored
		NBITS		: natural := 2 ;--NO CAMBIA ESTO 
		ROWS	: natural :=	64	;--!
		COLS	: natural := 4	--!  
		);
	port(
		clock			: in std_logic;
		reset			: in std_logic;
		update   	: in std_logic;
		taken 		: in std_logic;
		execState 	: 	in  std_logic_vector(7 downto 0);
		execPC   	: 	in  std_logic_vector(31 downto 0);
		fetchPC  	: 	in  std_logic_vector(31 downto 0);
		-- taken output
		take     : out std_logic;
		nextStateOut : out std_logic_vector(NBITS*COLS-1 downto 0)
	);
end entity BHT;


architecture behaviour of BHT is

	---------------
	function log2(arg : positive) return natural is
   variable tmp : positive     := 1;
   variable log : natural      := 0;
	begin
		if arg = 1 then return 0; end if;
		while arg > tmp loop
			tmp := tmp * 2;
         log := log + 1;
		end loop;
		return log;
	end function;
	----------------
	
	--Memory Type
	type MemArray_t is array(0 to ROWS-1) of std_logic_vector(NBITS*COLS-1 downto 0);
	
	-----------SIGNALS------------------
	signal memory : MemArray_t := (others=>(others=>'0'));
	
	signal nextState : std_logic_vector(NBITS*COLS-1 downto 0);
	signal readState : std_logic_vector(NBITS*COLS-1 downto 0);
	signal currPCState : std_logic_vector(1 downto 0);
	signal nextPCState : std_logic_vector(NBITS-1 downto 0);
	signal colFetch : std_logic_vector(1 downto 0);
	signal colExec : std_logic_vector(1 downto 0);
	
	
begin
	colFetch<=fetchPC(3 downto 2);
	readState <= memory(to_integer(unsigned(fetchPC(11 downto 4)))) when reset = '0' else "00000000";	--READ
	
	
	take <= readState(1) when colFetch="00" and reset = '0' else
	readState(3) when colFetch="01" and reset = '0' else
	readState(5) when colFetch="10" and reset = '0' else
	readState(7) when colFetch="11" and reset = '0' else
	'0';
	
	colExec<=execPC(3 downto 2);
	nextStateOut<=readState;
	
	----------------Prediction gathering (Memory READ)-------------------------------
--	predict:process(fetchPC)--SAQUE COLFETCH DE LA SENSIBILIDAD
--	begin
--		case colFetch is 
--			when "00" => take<= readState(1);
--			when "01" => take<= readState(3);
--			when "10" => take<= readState(5);
--			when "11" => take<= readState(7);
			--when others => take<='0';--ver despues 
		--end case;
		
	--end process predict;
	
	----------------Prediction generation (Memory WRITE)-------------------------------
	inputMUX: process(colExec,execState)
	begin
		--if(reset='0') then
			case colExec is 
				when "00" => currPCState<= execState(1 downto 0);
				when "01" => currPCState<= execState(3 downto 2);
				when "10" => currPCState<= execState(5 downto 4);
				when "11" => currPCState<= execState(7 downto 6);
				when others => currPCState<= "00";--ver despues 
			end case;
		--else 	
			--memory <=(others => (others => '0'));
		--end if;
	end process inputMUX;
	
	PCFSM: process(currPCState,taken)
	begin
	case currPCState is
		when "00" => 
			if(taken= '1') then nextPCState<= "01";
			else nextPCState<= "00";
			end if;
		when "01" => 
		if(taken= '1') then  nextPCState<= "11" ;
			else nextPCState<= "00";
			end if;
		when "10" =>
		if(taken= '1') then  nextPCState<= "11" ;
			else nextPCState<= "00";
			end if;
		when "11" =>
		if(taken= '1') then  nextPCState<="11";
			else nextPCState<="10" ;
			end if;
		when others => nextPCState<= "00";--ver despues 	
	end case;	
	
	end process PCFSM;
	
	
	getNextState: process(nextPCState,colExec,execState)
	begin
	case colExec is 
			when "00" => nextState<= execState(7 downto 2) & nextPCState  ;
			when "01" => nextState<= execState(7 downto 4) & nextPCState & execState( 1 downto 0) ;
			when "10" => nextState<= execState(7 downto 6) & nextPCState & execState( 3 downto 0) ;
			when "11" => nextState<= nextPCState & execState(5 downto 0)   ;
			when others => nextState<="00000000";
		end case;
	
	end process getNextState;
	
	
	--VER BIEN COMO VAN A HACER EL UPDATE
	memoryManage: process(clock, reset)
	begin
		if(reset='0') then
			if(rising_edge(clock)) then
				if(update='1') then
					memory(to_integer(unsigned(execPC(11 downto 4))))<=nextState;--WRITE
				end if;
			--readState <= memory(to_integer(unsigned(fetchPC(11 downto 4))));	--READ
			end if;
		end if;	
	end process memoryManage;
	

end architecture behaviour;
