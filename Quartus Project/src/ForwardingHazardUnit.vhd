library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use IEEE.math_real.all;
use WORK.EV19_Types.all;
use WORK.EV19_Constants.all;

entity ForwardingHazardUnit is
    port (
            -- Salidas
            ForwardA              : out   std_logic_vector(1 downto 0); -- 
            ForwardB              : out   std_logic_vector(1 downto 0); --
			StallFE               : out   std_logic;                    --
            StallDE               : out   std_logic;                    --
            StallEX               : out   std_logic;                    --
            StallME               : out   std_logic;                    --
            FlushF                : out   std_logic;                    --
            FlushD                : out   std_logic;                    --
			FlushE                : out   std_logic;                    --
            FlushM                : out   std_logic;                    --
				loadHazard				: out std_logic;

         -- Entradas
			
         Rs1_EX                : in    std_logic_vector(4 downto 0); -- 
         Rs2_EX                : in    std_logic_vector(4 downto 0); -- 
         Rs1_DE                : in    std_logic_vector(4 downto 0); -- 
         Rs2_DE                : in    std_logic_vector(4 downto 0); -- 
         EX_Rd                 : in    std_logic_vector(4 downto 0); -- 
         Rd_ME                 : in    std_logic_vector(4 downto 0); -- 
         Rd_WB                 : in    std_logic_vector(4 downto 0); -- 
         RegWrite_ME           : in    std_logic;                    --
         RegWrite_WB           : in    std_logic;                    --
         MemOp_EX              : in    MemOp_t;                      --
			MemOp_ME              : in    MemOp_t;                      --
			dMemAck				    : in    std_logic;                     --
			updatePC					 : in    std_logic;                     --
			AluSrcA           	 : in    std_logic;                    --
         AluSrcB           	 : in    std_logic;                    --
			dMemReadReq           : in    std_logic;                    --
			dMemWriteReq          : in    std_logic;                    --
			branchType_EX		  	 :	in		BranchType_t;						--
			longInstruction		 : in		std_logic
        );
end entity ForwardingHazardUnit;

architecture behaviour of ForwardingHazardUnit is

	signal StallFE_int     : std_logic;                    --
    signal StallDE_int     : std_logic;                    --
    signal StallEX_int     : std_logic;                    --
    signal StallME_int     : std_logic;                    --
    signal loadHazard_int  : std_logic;

    signal FlushF_int      : std_logic;                     --
    signal FlushD_int      : std_logic;                     --
    signal FlushE_int      : std_logic;                     --
    signal FlushM_int      : std_logic;                     --
begin

    loadHazard_int  <=  '1' when ((MemOp_ME=MEMOP_LOAD or MemOp_ME=MEMOP_LOAD_U) and ((Rd_ME=Rs1_EX and Rs1_EX/="00000" and (AluSrcA='1' or branchType_EX/=BRANCH_NONE)) or (Rd_ME=Rs2_EX and Rs2_EX/="00000" and (AluSrcB='1' or MemOp_EX=MEMOP_STORE or branchType_EX/=BRANCH_NONE)))) else '0'; --))) else '0';

    StallFE_int <= StallDE_int;
    StallDE_int <=  loadHazard_int or StallEX_int;
    StallEX_int <= '1' when ((MemOp_ME/=MEMOP_NONE and dMemAck='0') or longInstruction='1') else '0';
	 --StallEX_int <= '1' when (dMemReadReq='1' or dMemWriteReq='1') and dMemAck='0' else '0';
    StallME_int <= '0';
 
    FlushF_int  <= updatePC   	 and not StallFE_int;
    FlushD_int  <= updatePC   	 and not StallDE_int;
    FlushE_int  <= loadHazard_int and not StallEX_int;--'0';
    FlushM_int  <= '0';--oadHazard and not StallEX_int;

    process(StallFE_int,StallDE_int,StallEX_int,StallME_int,FlushF_int,FlushD_int,FlushE_int,FlushM_int,loadHazard_int)
    begin
        StallFE <= StallFE_int;
        StallDE <= StallDE_int;
        StallEX <= StallEX_int;
        StallME <= StallME_int;
        FlushF  <= FlushF_int;
        FlushD  <= FlushD_int;
        FlushE  <= FlushE_int;
        FlushM  <= FlushM_int;
		  loadHazard <= loadHazard_int;
    end process;

	ForwardPrcA : process(Rs1_EX,Rd_ME,Rd_WB,RegWrite_ME,RegWrite_WB,FlushE_int,loadHazard_int)
    begin
        if Rs1_EX=Rd_ME and Rd_ME/="00000" and RegWrite_ME='1' and loadHazard_int='0' then
            ForwardA <= "01";
        elsif Rs1_EX=Rd_WB and Rd_WB/="00000" and RegWrite_WB='1' then
            ForwardA <= "00";
        else
            ForwardA <= "10";
        end if;
    end process ForwardPrcA;

    ForwardPrcB : process(Rs2_EX,Rd_ME,Rd_WB,RegWrite_ME,RegWrite_WB,FlushE_int,loadHazard_int)
    begin
        if Rs2_EX=Rd_ME and Rd_ME/="00000" and RegWrite_ME='1' and loadHazard_int='0' then
            ForwardB <= "01";
        elsif Rs2_EX=Rd_WB and Rd_WB/="00000" and RegWrite_WB='1' then
            ForwardB <= "00";
        else
            ForwardB <= "10";
        end if;
    end process ForwardPrcB;

end architecture behaviour;