-- constant constant_name : type := value;
library ieee;
use ieee.std_logic_1164.all; 
use work.EV19_Types.All;

package EV19_Constants is

-- Largo de los registros
constant XLEN : natural := 32;
-- Cantidad de instrucciones implementadas
constant N_INST : natural := 45;--37;

-- Cantidad de instrucciones en la ROM simulada
constant SIMULATED_ROM_SIZE : natural := 64;

	--         opcode_tS
    constant LOAD        : opcode_t := "0000011";
	constant LOAD_FP 	 : opcode_t := "0000111";
	constant CUSTOM0 	 : opcode_t := "0001011";
	constant MISC_MEM    : opcode_t := "0001111";
	constant OP_IMM 	 : opcode_t := "0010011";
	constant AUIPC 	     : opcode_t := "0010111";
	constant OP_IMM_32   : opcode_t := "0011011";
	constant STORE 	     : opcode_t := "0100011";
	constant STORE_FP    : opcode_t := "0100111";
	constant CUSTOM1 	 : opcode_t := "0101011";
	constant AMO 		 : opcode_t := "0101111";
	constant OP 		 : opcode_t := "0110011";
	constant LUI 		 : opcode_t := "0110111";
	constant OP_32 	     : opcode_t := "0111011";
	constant MADD 		 : opcode_t := "1000011";
	constant MSUB 		 : opcode_t := "1000111";
	constant NMSUB 	     : opcode_t := "1001011";
	constant NMADD 	     : opcode_t := "1001111";
	constant OP_FP 	     : opcode_t := "1010011";
	constant CUSTOM2 	 : opcode_t := "1011011";
	constant BRANCH 	 : opcode_t := "1100011";
	constant JALR 		 : opcode_t := "1100111";
	constant JAL 		 : opcode_t := "1101111";
	constant SYSTEM 	 : opcode_t := "1110011";
	constant CUSTOM3	 : opcode_t := "1111011";
---------------------------------------------------------------------------
	-- Señales de control
    -- BranchType_t
    constant BRANCH_NONE     : STD_LOGIC_VECTOR(1 downto 0) := "00";  
    constant BRANCH_COND     : STD_LOGIC_VECTOR(1 downto 0) := "01";  
    constant BRANCH_JUMP     : STD_LOGIC_VECTOR(1 downto 0) := "10";  
    constant BRANCH_JUMP_IND : STD_LOGIC_VECTOR(1 downto 0) := "11";  
    -- CompateType_t
    constant CMP_NONE        : STD_LOGIC_VECTOR(2 downto 0) := "000";
    constant CMP_EQ          : STD_LOGIC_VECTOR(2 downto 0) := "001";
    constant CMP_NEQ         : STD_LOGIC_VECTOR(2 downto 0) := "010";
    constant CMP_GRT         : STD_LOGIC_VECTOR(2 downto 0) := "011";
    constant CMP_LESS        : STD_LOGIC_VECTOR(2 downto 0) := "100";
    constant CMP_GRTU        : STD_LOGIC_VECTOR(2 downto 0) := "101";
    constant CMP_LESSU       : STD_LOGIC_VECTOR(2 downto 0) := "110";
    -- AluOp_t
    constant ALU_NOP         : STD_LOGIC_VECTOR(4 downto 0) := "00000";      
    constant ALU_A_PLUS4     : STD_LOGIC_VECTOR(4 downto 0) := "00010";   
    constant ALU_SRA         : STD_LOGIC_VECTOR(4 downto 0) := "00011";
    constant ALU_SLL         : STD_LOGIC_VECTOR(4 downto 0) := "00100";   
    constant ALU_SRL         : STD_LOGIC_VECTOR(4 downto 0) := "00101";   
    constant ALU_SLTU        : STD_LOGIC_VECTOR(4 downto 0) := "00110";
    constant ALU_SLT         : STD_LOGIC_VECTOR(4 downto 0) := "00111";
    constant ALU_SUB         : STD_LOGIC_VECTOR(4 downto 0) := "01000";
    constant ALU_ADD         : STD_LOGIC_VECTOR(4 downto 0) := "01001";   
    constant ALU_XOR         : STD_LOGIC_VECTOR(4 downto 0) := "01010";
    constant ALU_OR          : STD_LOGIC_VECTOR(4 downto 0) := "01011";
    constant ALU_AND         : STD_LOGIC_VECTOR(4 downto 0) := "01100";
    constant ALU_B           : STD_LOGIC_VECTOR(4 downto 0) := "01101";
    constant ALU_A           : STD_LOGIC_VECTOR(4 downto 0) := "01110";
	 constant ALU_MUL         : STD_LOGIC_VECTOR(4 downto 0) := "01111";
	 constant ALU_MULH        : STD_LOGIC_VECTOR(4 downto 0) := "10000";
	 constant ALU_MULHU       : STD_LOGIC_VECTOR(4 downto 0) := "10001";
	 constant ALU_DIV         : STD_LOGIC_VECTOR(4 downto 0) := "10010";
	 constant ALU_REM         : STD_LOGIC_VECTOR(4 downto 0) := "10011";
	 constant ALU_DIVU        : STD_LOGIC_VECTOR(4 downto 0) := "10100";
	 constant ALU_REMU        : STD_LOGIC_VECTOR(4 downto 0) := "10101";
    -- AluSourceA_t
    constant ALUSRC_PC       : STD_LOGIC := '0';
    constant ALUSRC_REG      : STD_LOGIC := '1';
    -- AluSourceB_t    
    constant ALUSRC_IMM      : STD_LOGIC := '0';
    --constant ALUSRC_REG    : INTEGER := 1;
    -- MemOp_t
    constant MEMOP_NONE      : MemOp_t := "00";
    constant MEMOP_LOAD      : MemOp_t := "01";
    constant MEMOP_LOAD_U    : MemOp_t := "10";
    constant MEMOP_STORE     : MemOp_t := "11";
    -- MemSize_t
    constant MEM_SIZE_WORD   : STD_LOGIC_VECTOR(1 downto 0) := "00";
    constant MEM_SIZE_BYTE   : STD_LOGIC_VECTOR(1 downto 0) := "01";
    constant MEM_SIZE_HALF   : STD_LOGIC_VECTOR(1 downto 0) := "10";
	 -- WbSource_t
	 constant ALU_RES 		  : STD_LOGIC := '0';
	 constant MEM_DATA 		  : STD_LOGIC := '1';
end package EV19_Constants;