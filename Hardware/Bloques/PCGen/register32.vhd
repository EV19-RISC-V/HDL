
LIBRARY ieee;
USE ieee.std_logic_1164.all ;
ENTITY register32 IS PORT(
    d   : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    stall : IN STD_LOGIC; 
    clr : IN STD_LOGIC; -- sync. clear.
    clk : IN STD_LOGIC; -- clock.
    q   : OUT STD_LOGIC_VECTOR(31 DOWNTO 0) -- output
);
END register32;

ARCHITECTURE description OF register32 IS

BEGIN
    process(clk, clr)
    begin
        if rising_edge(clk) then
				if clr = '1' then
					q <= x"00000000";
            elsif stall = '0' then
                q <= d;
            end if;
        end if;
    end process;
END description;