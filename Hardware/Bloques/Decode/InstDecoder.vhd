library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

entity instDecoder is
	port (
		instruction : in std_logic_vector(31 downto 0);
		index : out std_logic_vector(5 downto 0);	-- 37 control words in total
		invalidInstruction : out std_logic
		);
end instDecoder;


architecture behaviour of instDecoder is
		signal opCode : std_logic_vector(6 downto 0);
		signal func3 : std_logic_vector(2 downto 0);
		signal func7 : std_logic_vector(6 downto 0);
begin
	
	opCode <= instruction(6 downto 0);
	func3 <= instruction(14 downto 12);
	func7 <= instruction(31 downto 25);
	
	process(opCode, func3, func7)
		variable csIndex : integer range 0 to 44;
		variable errorFlag : std_logic;
	begin
		errorFlag := '0';
		case opCode is
			when b"0110111" =>
				csIndex := 	0;
			when b"0010111" =>
				csIndex := 	1;
			when b"1101111" =>
				csIndex := 	2;
			when b"1100111" =>
				csIndex := 	3;
			when b"1100011" =>
				csIndex := 	4;
 			when b"0000011" =>
 				csIndex := 	10;
 			when b"0100011" =>
 				csIndex := 	15;
 			when b"0010011" =>
 				csIndex := 	18;
 			when b"0110011" =>
 				csIndex := 	27;
 			when others =>
 				errorFlag := '1';
		end case;
							
		if(errorFlag = '0') then		
			if(csIndex = 4) then	-- Must determine index using func3
				case func3 is		 	  
					when b"000" =>
						csIndex := csIndex;
					when b"001" =>
						csIndex := csIndex+1;
					when b"100" =>
						csIndex := csIndex+2;
					when b"101" =>
						csIndex := csIndex+3;
					when b"110" =>
						csIndex := csIndex+4; 
					when b"111" =>
						csIndex := csIndex+5;
					when others =>
						errorFlag := '1';
				end case;
			elsif (csIndex = 10) then
				case func3 is	   
					when b"000" =>
						csIndex := csIndex;
					when b"001" =>
						csIndex := csIndex+1;
					when b"010" =>
						csIndex := csIndex+2;
					when b"100" =>
						csIndex := csIndex+3;
					when b"101" =>
						csIndex := csIndex+4;
					when others =>
						errorFlag := '1';
				end case;
			elsif (csIndex = 15) then
				csIndex := csIndex + conv_integer(unsigned(func3));
			elsif (csIndex = 18) then
				csIndex := csIndex + conv_integer(unsigned(func3));
				if(func3 = b"101" and func7 = "0100000") then
					csIndex := csIndex + 3;
				end if;

				if(func3 = b"001" and func7 /= "0000000") then
					errorFlag := '1';
				elsif(func3 = b"101" and func7 /= "0000000" and func7 /= "0100000") then
					errorFlag := '1';
				end if;
			elsif (csIndex = 27) then
				csIndex := csIndex + conv_integer(unsigned(func3));
				if(func3 = b"000" and func7 = "0100000") then
					csIndex := csIndex + 8;
				elsif(func3 = b"101" and func7 = "0100000") then
					csIndex := csIndex + 4;
				end if;
				--Multiplication and division functions
				if(func7 = "0000001") then
					csIndex := csIndex + 10;
				end if;
				---------------------------------------
				if(func3 = b"000" or func3 = b"101") then
					if(func7 /= "0000000" and func7 /= "0100000" and func7 /= "0000001") then
						errorFlag := '1';
					end if;
				else
					if(func7 /= "0000000" and func7 /= "0000001") then
						errorFlag := '1';
					end if;
				end if;
			end if;
		end if;
		index <= conv_std_logic_vector(csIndex, 6);  
		invalidInstruction <= errorFlag;
	end process;

end behaviour;