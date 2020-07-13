library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.EV19_Types.all;		
use work.EV19_Constants.all;

entity ByteEnableBlock is
	port(

		-- Data input:
		dMemAddress		: in std_logic_vector(1 downto 0);

		-- Control signals:
		memOp    		: in  MemOp_t;
		memSize  		: in  MemSize_t;
		byteEnable	   : out std_logic_vector(3 downto 0)
		

	);
end ByteEnableBlock;

architecture behaviour of ByteEnableBlock is
		
		
	signal mem_op   			: MemOp_t;
	signal mem_size 			: MemSize_t;
	signal addressOffset 		: std_logic_vector(1 downto 0);


begin

	mem_op 			<= memOp;
	mem_size 		<= memSize;
	addressOffset 	<= dMemAddress;

	byte_enable_mux: process(addressOffset, mem_op, mem_size)
	begin
		
		case mem_size is
			when MEM_SIZE_BYTE =>
				if addressOffset = b"00" then
					byteEnable <= "0001";
					
				elsif addressOffset = b"01" then
					byteEnable <= "0010";
					
				elsif addressOffset = b"10" then
					byteEnable <= "0100";
					
				elsif addressOffset = b"11" then
					byteEnable <= "1000";
					
				end if;
			when MEM_SIZE_HALF =>
				if addressOffset = b"00" then
					byteEnable <= "0011";
					
				elsif addressOffset = b"10" then
					byteEnable <= "1100";
					
				elsif addressOffset = b"11" OR addressOffset = b"01" then
					byteEnable <= "0000";
					
				end if;
				
			when MEM_SIZE_WORD =>
				if addressOffset = b"00" then
					byteEnable <= "1111";
					
				else
					byteEnable <= "0000";
					
				end if;
			when others =>		
				
		end case;

	end process byte_enable_mux;

end architecture behaviour;