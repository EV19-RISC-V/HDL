library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.EV19_Types.all;
use work.EV19_Constants.all;



entity ShiftBlock is
	port(

		
		dMemAddress		: in std_logic_vector(1 downto 0);
		memOp		: in  MemOp_t;
		memSize		: in  MemSize_t;
		storeDataIn		: in std_logic_vector(31 downto 0);



		missalignFlag : out std_logic;
		storeDataOut	: out std_logic_vector(31 downto 0)

	);
end ShiftBlock;

architecture behaviour of ShiftBlock is
		
		
	signal mem_op   			: MemOp_t;
	signal mem_size 			: MemSize_t;
	signal byte    			: std_logic_vector(7 downto 0);
	signal half 		     	: std_logic_vector(15 downto 0);
	signal word			      : std_logic_vector(31 downto 0);
	signal adress_offset 	: std_logic_vector(1 downto 0);


begin

	mem_op 			<= memOp;
	mem_size 		<= memSize;
	adress_offset 	<= dMemAddress;
	byte			<= storeDataIn(7 downto 0);
	half			<= storeDataIn(15 downto 0);
	word			<= storeDataIn;

	datashift: process(mem_size,adress_offset,byte,half,word)
	begin
		case mem_size is
			when MEM_SIZE_BYTE =>
				if adress_offset = b"00" then
					storeDataOut <= (31 downto 8 =>'0')&byte;	
				elsif adress_offset = b"01" then
					storeDataOut <= (31 downto 16 =>'0')&byte&(7 downto 0 =>'0');		
				elsif adress_offset = b"10" then
					storeDataOut <= (31 downto 24 =>'0')&byte&(15 downto 0 =>'0');	
				elsif adress_offset = b"11" then
					storeDataOut <= byte&(23 downto 0 =>'0');	
				end if;
			when MEM_SIZE_HALF =>
				if adress_offset = b"00" then
					storeDataOut <= (31 downto 16 =>'0')&half;	
				elsif adress_offset = b"10" then
					storeDataOut <= half&(15 downto 0 =>'0');
				end if;
				
			when MEM_SIZE_WORD =>
					storeDataOut <= word;			
			when others	=>
					storeDataOut <= (others =>'0');
		end case;
	end process dataShift;
	
	missalign: process(mem_size, adress_offset)
	begin
		if (mem_size=MEM_SIZE_WORD and adress_offset/="00") or (mem_size=MEM_SIZE_WORD and (adress_offset="01" or adress_offset="11")) then
			missalignFlag <= '1';
		else
			missalignFlag <= '0';
		end if;
	end process missalign;

	--res_data_mux: process(res_data, mem_op, mem_size)
	--begin
	--	if mem_op = MEMOP_TYPE_STORE  then
	--		case mem_size is
	--			when MEMSIZE_BYTE =>
	--				storeDataOut <= std_logic_vector(resize(signed(dmem_data_in(7 downto 0)), rd_data_out'length));
	--			when MEMSIZE_HALF =>
	--				storeDataOut <= std_logic_vector(resize(signed(dmem_data_in(7 downto 0)), rd_data_out'length));
	--			when MEMSIZE_WORD =>
	--				rd_data_out <= dmem_data_in;
	--		end case;
	--	else
	--		rd_data_out <= rd_data;
	--	end if;
	--end process res_data_mux;

end architecture behaviour;