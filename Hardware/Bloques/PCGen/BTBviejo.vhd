library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity BTB is
	generic(
		SIZE    : natural := 128  --! Number of lines in the cache
	);
	port(
		clk   : in std_logic;
		reset : in std_logic;
		-- Udate an entry in the BTB
		updateTarget   : in std_logic;
		sourcePC   : in  std_logic_vector(31 downto 0);
		targetPC   : in  std_logic_vector(31 downto 0);
		-- Next pc
		nextPC   : in  std_logic_vector(31 downto 0);
		-- PredictedPc
		predictedPC     : out std_logic_vector(31 downto 0);
		hit     : out std_logic
	);
end entity BTB;

architecture behaviour of BTB is


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


	-- Counter types:
	subtype lineCounter_t is natural range 0 to SIZE;

	-- Cache line types:
	type targetArray_t is array(0 to SIZE - 1) of std_logic_vector(31 downto 0);

	-- Cache tag type:
	subtype tag_t is std_logic_vector(31-log2(SIZE) downto 0);
	type tagArray_t is array(0 to SIZE - 1) of tag_t;

	-- Cache memories:
	signal targetMemory : targetArray_t;
	signal tagMemory   : tagArray_t;
	signal valid        : std_logic_vector(SIZE - 1 downto 0) := (others => '0');

	-- Input address components:
	signal nextPC_line, sourcePC_line : std_logic_vector(log2(SIZE) - 1 downto 0);
	signal nextPC_tag,  sourcePC_tag  : tag_t;

begin

	
	nextPC_tag  <= nextPC(31 downto log2(SIZE));
	nextPC_line <= nextPC(log2(SIZE) - 1 downto 0);

	sourcePC_tag  <= sourcePC(31 downto log2(SIZE));
	sourcePC_line <= sourcePC(log2(SIZE) - 1 downto 0);
	
	-- Output predicted PC
	predictedPC <= targetMemory(to_integer(unsigned(nextPC_line)));

	-- Output hit
	hit <= '1' when tagMemory(to_integer(unsigned(nextPC_line))) = nextPC_tag and valid(to_integer(unsigned(nextPC_line)))='1' else '0';

			
	cacheUpdate: process(clk)
	begin
		if rising_edge(clk) then
			if reset = '1' then
				valid <= (others => '0');
			elsif updateTarget  = '1' then
				targetMemory(to_integer(unsigned(sourcePC_line))) <= targetPC;
				valid(to_integer(unsigned(sourcePC_line))) <= '1';
				tagMemory(to_integer(unsigned(sourcePC_line))) <= sourcePC_tag;
			end if;
		end if;
	end process cacheUpdate;

end architecture behaviour;
