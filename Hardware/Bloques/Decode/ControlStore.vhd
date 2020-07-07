library ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;

USE WORK.EV19_Types.all;
USE WORK.EV19_Constants.all;

entity ControlStore is
    port (
        intAddr      : IN STD_LOGIC_VECTOR(5 downto 0);
        bubble       : IN STD_LOGIC;
          
        RegWrite     : OUT STD_LOGIC;      
        WbSource     : OUT WbSource_t;
        MemSize      : OUT MemSize_t;
        MemOp        : OUT MemOp_t;
        AluOp        : OUT AluOp_t;
        AluSourceA   : OUT AluSourceA_t;      
        AluSourceB   : OUT AluSourceB_t;
        BranchType   : OUT BranchType_t;
        CompareType  : OUT CompareType_t       
    );
end ControlStore;
 
architecture behavioral of ControlStore is

    type ControlWord_t is record
    CompareType  :  CompareType_t;       
    BranchType   :  BranchType_t;
    AluSourceA   :  AluSourceA_t;      
    AluSourceB   :  AluSourceB_t;
    AluOp        :  AluOp_t;
    MemOp        :  MemOp_t;
    MemSize      :  MemSize_t;
    RegWrite     :  STD_LOGIC;      
    WbSource     :  WbSource_t;
    end record ControlWord_t;  

    type ControlStore_t is array (0 to N_INST-1) of ControlWord_t;

    signal controlWord  : ControlWord_t;   
    signal store : ControlStore_t := (
       (CMP_NONE,   BRANCH_NONE,     ALUSRC_REG, ALUSRC_IMM, ALU_B,       MEMOP_NONE,   MEM_SIZE_WORD, '1', ALU_RES ), -- 0 LUI
       (CMP_NONE,   BRANCH_NONE,     ALUSRC_PC,  ALUSRC_IMM, ALU_ADD,     MEMOP_NONE,   MEM_SIZE_WORD, '1', ALU_RES ), -- 1 AUIPC
       (CMP_NONE,   BRANCH_JUMP,     ALUSRC_PC,  ALUSRC_REG, ALU_A_PLUS4, MEMOP_NONE,   MEM_SIZE_WORD, '1', ALU_RES ), -- 2 JAL
       (CMP_NONE,   BRANCH_JUMP_IND, ALUSRC_PC,  ALUSRC_REG, ALU_A_PLUS4, MEMOP_NONE,   MEM_SIZE_WORD, '1', ALU_RES ), -- 3 JALR
       (CMP_EQ,     BRANCH_COND,     ALUSRC_PC,  ALUSRC_IMM, ALU_A_PLUS4, MEMOP_NONE,   MEM_SIZE_WORD, '0', ALU_RES ), -- 4 BEQ
       (CMP_NEQ,    BRANCH_COND,     ALUSRC_PC,  ALUSRC_IMM, ALU_A_PLUS4, MEMOP_NONE,   MEM_SIZE_WORD, '0', ALU_RES ), -- 5 BNE
       (CMP_LESS,   BRANCH_COND,     ALUSRC_PC,  ALUSRC_IMM, ALU_A_PLUS4, MEMOP_NONE,   MEM_SIZE_WORD, '0', ALU_RES ), -- 6 BLT
       (CMP_GRT,    BRANCH_COND,     ALUSRC_PC,  ALUSRC_IMM, ALU_A_PLUS4, MEMOP_NONE,   MEM_SIZE_WORD, '0', ALU_RES ), -- 7 BGE
       (CMP_LESSU,  BRANCH_COND,     ALUSRC_PC,  ALUSRC_IMM, ALU_A_PLUS4, MEMOP_NONE,   MEM_SIZE_WORD, '0', ALU_RES ), -- 8 BLTU
       (CMP_GRTU,   BRANCH_COND,     ALUSRC_PC,  ALUSRC_IMM, ALU_A_PLUS4, MEMOP_NONE,   MEM_SIZE_WORD, '0', ALU_RES ), -- 9 BGEU
       (CMP_NONE,   BRANCH_NONE,     ALUSRC_REG, ALUSRC_IMM, ALU_ADD,     MEMOP_LOAD,   MEM_SIZE_BYTE, '1', MEM_DATA), -- 10 LB
       (CMP_NONE,   BRANCH_NONE,     ALUSRC_REG, ALUSRC_IMM, ALU_ADD,     MEMOP_LOAD,   MEM_SIZE_HALF, '1', MEM_DATA), -- 11 LH 
       (CMP_NONE,   BRANCH_NONE,     ALUSRC_REG, ALUSRC_IMM, ALU_ADD,     MEMOP_LOAD,   MEM_SIZE_WORD, '1', MEM_DATA), -- 12 LW 
       (CMP_NONE,   BRANCH_NONE,     ALUSRC_REG, ALUSRC_IMM, ALU_ADD,     MEMOP_LOAD_U, MEM_SIZE_BYTE, '1', MEM_DATA), -- 13 LBU
       (CMP_NONE,   BRANCH_NONE,     ALUSRC_REG, ALUSRC_IMM, ALU_ADD,     MEMOP_LOAD_U, MEM_SIZE_WORD, '1', MEM_DATA), -- 14 LHU
       (CMP_NONE,   BRANCH_NONE,     ALUSRC_REG, ALUSRC_IMM, ALU_ADD,     MEMOP_STORE,  MEM_SIZE_BYTE, '0', ALU_RES ), -- 15 SB
       (CMP_NONE,   BRANCH_NONE,     ALUSRC_REG, ALUSRC_IMM, ALU_ADD,     MEMOP_STORE,  MEM_SIZE_HALF, '0', ALU_RES ), -- 16 SH
       (CMP_NONE,   BRANCH_NONE,     ALUSRC_REG, ALUSRC_IMM, ALU_ADD,     MEMOP_STORE,  MEM_SIZE_WORD, '0', ALU_RES ), -- 17 SW
       (CMP_NONE,   BRANCH_NONE,     ALUSRC_REG, ALUSRC_IMM, ALU_ADD,     MEMOP_NONE,   MEM_SIZE_WORD, '1', ALU_RES ), -- 18 ADDI
       (CMP_NONE,   BRANCH_NONE,     ALUSRC_REG, ALUSRC_IMM, ALU_SLL,     MEMOP_NONE,   MEM_SIZE_WORD, '1', ALU_RES ), -- 19 SLLI
       (CMP_NONE,   BRANCH_NONE,     ALUSRC_REG, ALUSRC_IMM, ALU_SLT,     MEMOP_NONE,   MEM_SIZE_WORD, '1', ALU_RES ), -- 20 SLTI
       (CMP_NONE,   BRANCH_NONE,     ALUSRC_REG, ALUSRC_IMM, ALU_SLTU,    MEMOP_NONE,   MEM_SIZE_WORD, '1', ALU_RES ), -- 21 SLTIU
       (CMP_NONE,   BRANCH_NONE,     ALUSRC_REG, ALUSRC_IMM, ALU_XOR,     MEMOP_NONE,   MEM_SIZE_WORD, '1', ALU_RES ), -- 22 XORI
       (CMP_NONE,   BRANCH_NONE,     ALUSRC_REG, ALUSRC_IMM, ALU_SRL,     MEMOP_NONE,   MEM_SIZE_WORD, '1', ALU_RES ), -- 23 SRLI
       (CMP_NONE,   BRANCH_NONE,     ALUSRC_REG, ALUSRC_IMM, ALU_OR,      MEMOP_NONE,   MEM_SIZE_WORD, '1', ALU_RES ), -- 24 ORI
       (CMP_NONE,   BRANCH_NONE,     ALUSRC_REG, ALUSRC_IMM, ALU_AND,     MEMOP_NONE,   MEM_SIZE_WORD, '1', ALU_RES ), -- 25 ANDI
       (CMP_NONE,   BRANCH_NONE,     ALUSRC_REG, ALUSRC_IMM, ALU_SRA,     MEMOP_NONE,   MEM_SIZE_WORD, '1', ALU_RES ), -- 26 SRAI
       (CMP_NONE,   BRANCH_NONE,     ALUSRC_REG, ALUSRC_REG, ALU_ADD,     MEMOP_NONE,   MEM_SIZE_WORD, '1', ALU_RES ), -- 27 ADD
       (CMP_NONE,   BRANCH_NONE,     ALUSRC_REG, ALUSRC_REG, ALU_SLL,     MEMOP_NONE,   MEM_SIZE_WORD, '1', ALU_RES ), -- 28 SLL
       (CMP_NONE,   BRANCH_NONE,     ALUSRC_REG, ALUSRC_REG, ALU_SLT,     MEMOP_NONE,   MEM_SIZE_WORD, '1', ALU_RES ), -- 29 SLT
       (CMP_NONE,   BRANCH_NONE,     ALUSRC_REG, ALUSRC_REG, ALU_SLTU,    MEMOP_NONE,   MEM_SIZE_WORD, '1', ALU_RES ), -- 30 SLTU
       (CMP_NONE,   BRANCH_NONE,     ALUSRC_REG, ALUSRC_REG, ALU_XOR,     MEMOP_NONE,   MEM_SIZE_WORD, '1', ALU_RES ), -- 31 XOR
       (CMP_NONE,   BRANCH_NONE,     ALUSRC_REG, ALUSRC_REG, ALU_SRL,     MEMOP_NONE,   MEM_SIZE_WORD, '1', ALU_RES ), -- 32 SRL
       (CMP_NONE,   BRANCH_NONE,     ALUSRC_REG, ALUSRC_REG, ALU_OR,      MEMOP_NONE,   MEM_SIZE_WORD, '1', ALU_RES ), -- 33 OR
       (CMP_NONE,   BRANCH_NONE,     ALUSRC_REG, ALUSRC_REG, ALU_AND,     MEMOP_NONE,   MEM_SIZE_WORD, '1', ALU_RES ), -- 34 AND
       (CMP_NONE,   BRANCH_NONE,     ALUSRC_REG, ALUSRC_REG, ALU_SUB,     MEMOP_NONE,   MEM_SIZE_WORD, '1', ALU_RES ), -- 35 SUB
       (CMP_NONE,   BRANCH_NONE,     ALUSRC_REG, ALUSRC_REG, ALU_SRA,     MEMOP_NONE,   MEM_SIZE_WORD, '1', ALU_RES ), --36 SRA
		 -------------------------------------------Multiplication and division functions-----------------------------------------
		 (CMP_NONE,   BRANCH_NONE,     ALUSRC_REG, ALUSRC_REG, ALU_MUL,     MEMOP_NONE,   MEM_SIZE_WORD, '1', ALU_RES ), --37 MUL
		 (CMP_NONE,   BRANCH_NONE,     ALUSRC_REG, ALUSRC_REG, ALU_MULH,    MEMOP_NONE,   MEM_SIZE_WORD, '1', ALU_RES  ),--38 MULH
		 (CMP_NONE,   BRANCH_NONE,     ALUSRC_REG, ALUSRC_REG, ALU_MULH,    MEMOP_NONE,   MEM_SIZE_WORD, '1', ALU_RES ), --39 MULHSU
		 (CMP_NONE,   BRANCH_NONE,     ALUSRC_REG, ALUSRC_REG, ALU_MULHU,   MEMOP_NONE,   MEM_SIZE_WORD, '1', ALU_RES ), --40 MULHU
		 (CMP_NONE,   BRANCH_NONE,     ALUSRC_REG, ALUSRC_REG, ALU_DIV,     MEMOP_NONE,   MEM_SIZE_WORD, '1', ALU_RES ), --41 DIV
		 (CMP_NONE,   BRANCH_NONE,     ALUSRC_REG, ALUSRC_REG, ALU_DIVU,    MEMOP_NONE,   MEM_SIZE_WORD, '1', ALU_RES  ),--42 DIVU
		 (CMP_NONE,   BRANCH_NONE,     ALUSRC_REG, ALUSRC_REG, ALU_REM,     MEMOP_NONE,   MEM_SIZE_WORD, '1', ALU_RES ), --43 REM
		 (CMP_NONE,   BRANCH_NONE,     ALUSRC_REG, ALUSRC_REG, ALU_REMU,    MEMOP_NONE,   MEM_SIZE_WORD, '1', ALU_RES ));--44 REMU
begin

    CompareType <= controlWord.CompareType when bubble='0' else CMP_NONE;            
    BranchType  <= controlWord.BranchType  when bubble='0' else BRANCH_NONE;            
    AluSourceA  <= controlWord.AluSourceA;            
    AluSourceB  <= controlWord.AluSourceB;
    AluOp       <= controlWord.AluOp     when bubble='0' else ALU_NOP;            
    MemOp       <= controlWord.MemOp     when bubble='0' else MEMOP_NONE;    
    MemSize     <= controlWord.MemSize;        
    RegWrite    <= controlWord.RegWrite    when bubble='0' else '0';            
    WbSource    <= controlWord.WbSource;  

    process (intAddr) begin
          controlWord <= store(conv_integer(intAddr));
    end process;
end behavioral;