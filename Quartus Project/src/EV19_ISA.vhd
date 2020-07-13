library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.EV19_Constants.all;
use work.EV19_Types.all;

-- Functions implementing 
package EV19_ISA is
----------------------------------------------------------------------
--                              Register Instructions                             --
----------------------------------------------------------------------

	function EV19_NOP return std_logic_vector;
	 
    function EV19_ADD(  rd    : in regNum_t ;
                        rs1   : in regNum_t ;
                        rs2   : in regNum_t )    return std_logic_vector;
    function EV19_SUB(  rd    : in regNum_t ;
                        rs1   : in regNum_t ;
                        rs2   : in regNum_t )    return std_logic_vector;                
    function EV19_SLL(  rd    : in regNum_t ;
                        rs1   : in regNum_t ;
                        rs2   : in regNum_t )    return std_logic_vector;
    function EV19_SLT(	rd    : in regNum_t ;
                        rs1   : in regNum_t ;
                        rs2   : in regNum_t )    return std_logic_vector;
    function EV19_SLTU(rd     : in regNum_t ;
                        rs1   : in regNum_t ;
                        rs2   : in regNum_t )    return std_logic_vector;
    function EV19_XOR(  rd    : in regNum_t ;
                        rs1   : in regNum_t ;
                        rs2   : in regNum_t )    return std_logic_vector;    
    function EV19_SRL(  rd    : in regNum_t ;
                        rs1   : in regNum_t ;
                        rs2   : in regNum_t )    return std_logic_vector;    
    function EV19_SRA(  rd    : in regNum_t ;
                        rs1   : in regNum_t ;
                        rs2   : in regNum_t )    return std_logic_vector;     
    function EV19_OR(   rd    : in regNum_t ;
                        rs1   : in regNum_t ;
                        rs2   : in regNum_t )    return std_logic_vector;
    function EV19_AND(  rd    : in regNum_t ;
                        rs1   : in regNum_t ;
                        rs2   : in regNum_t )    return std_logic_vector;        
----------------------------------------------------------------------
--                              Inmediate Instructions                            --
----------------------------------------------------------------------
    function EV19_ADDI(rd     : in regNum_t ;
                        rs1   : in regNum_t ;
                        imm   : in immNum_t) return std_logic_vector;
    function EV19_SLTI(rd     : in regNum_t ;
                        rs1   : in regNum_t ;
                        imm   : in immNum_t) return std_logic_vector;
    function EV19_SLTIU(rd    : in regNum_t ;
                        rs1   : in regNum_t ;
                        imm   : in immNum_t) return std_logic_vector;
    function EV19_XORI(rd     : in regNum_t ;
                        rs1   : in regNum_t ;
                        imm   : in immNum_t) return std_logic_vector;
    function EV19_ORI(  rd    : in regNum_t ;
                        rs1   : in regNum_t ;
                        imm   : in immNum_t) return std_logic_vector;
    function EV19_ANDI(rd     : in regNum_t ;
                        rs1   : in regNum_t ;
                        imm   : in immNum_t) return std_logic_vector;
    function EV19_SLLI(rd     : in regNum_t ;
                        rs1   : in regNum_t ;
                        shamt : in regNum_t )return std_logic_vector;
    function EV19_SRLI(rd     : in regNum_t ;
                        rs1   : in regNum_t ;
                        shamt : in regNum_t )return std_logic_vector;
    function EV19_SRAI( rd    : in regNum_t ;
                        rs1   : in regNum_t ;
                        shamt : in regNum_t )return std_logic_vector;

----------------------------------------------------------------------
--                              Load imm                            --
----------------------------------------------------------------------
    function EV19_LUI(  rd    : in regNum_t;
								imm   : in immNum_t) return std_logic_vector;
    function EV19_AUIPC(rd    : in regNum_t;
								imm   : in immNum_t) return std_logic_vector;

----------------------------------------------------------------------
--                              Jump Instructions                            --
----------------------------------------------------------------------
     function EV19_JAL(  rd    : in regNum_t;
								 imm   : in immNum_t) return std_logic_vector;
     function EV19_JALR( rd    : in regNum_t ;
                         rs1   : in regNum_t ;
                         offset: in immNum_t )return std_logic_vector;

----------------------------------------------------------------------
--                              Branch Intructions                            --
----------------------------------------------------------------------
     function EV19_BEQ(  rs1    : in regNum_t ;
                         rs2    : in regNum_t ;
                         offset : in immNum_t ) return std_logic_vector;
     function EV19_BNE(  rs1    : in regNum_t ;
                         rs2    : in regNum_t ;
                         offset : in immNum_t ) return std_logic_vector;
     function EV19_BLT(  rs1    : in regNum_t ;
                         rs2    : in regNum_t ;
                         offset : in immNum_t ) return std_logic_vector;
     function EV19_BGE(  rs1    : in regNum_t ;
                         rs2    : in regNum_t ;
                         offset : in immNum_t ) return std_logic_vector;
     function EV19_BLTU( rs1    : in regNum_t ;
                         rs2    : in regNum_t ;
                         offset : in immNum_t ) return std_logic_vector;
     function EV19_BGEU( rs1    : in regNum_t ;
                         rs2    : in regNum_t ;
                         offset : in immNum_t ) return std_logic_vector;
----------------------------------------------------------------------
--                              Load Instructions                            --
----------------------------------------------------------------------
    function EV19_LB(   rd    : in regNum_t ;
                        rs1   : in regNum_t ;
                        imm   : in immNum_t) return std_logic_vector;
    function EV19_LH(   rd    : in regNum_t ;
                        rs1   : in regNum_t ;
                        imm   : in immNum_t) return std_logic_vector;   
    function EV19_LW(   rd    : in regNum_t ;
                        rs1   : in regNum_t ;
                        imm   : in immNum_t) return std_logic_vector;
    function EV19_LBU(   rd   : in regNum_t ;
                        rs1   : in regNum_t ;
                        imm   : in immNum_t) return std_logic_vector;  
    function EV19_LHU(   rd   : in regNum_t ;
                        rs1   : in regNum_t ;
                        imm   : in immNum_t) return std_logic_vector;  
----------------------------------------------------------------------
--                              Store Instructions                            --
----------------------------------------------------------------------    
    function EV19_SB(   rs2    : in regNum_t ;
                        rs1    : in regNum_t ;
                        imm    : in immNum_t) return std_logic_vector;
    function EV19_SH(   rs2    : in regNum_t ;
                        rs1    : in regNum_t ;
                        imm    : in immNum_t) return std_logic_vector;  
    function EV19_SW(   rs2    : in regNum_t ;
                        rs1    : in regNum_t ;
                        imm    : in immNum_t) return std_logic_vector;
----------------------------------------------------------------------
--                Multiply and Divide Instructions                            --
----------------------------------------------------------------------    
    function EV19_MUL(  rd    : in regNum_t ;
                        rs1   : in regNum_t ;
                        rs2   : in regNum_t )    return std_logic_vector;
    function EV19_MULH(  rd    : in regNum_t ;
                        rs1   : in regNum_t ;
                        rs2   : in regNum_t )    return std_logic_vector; 
    function EV19_MULHU(  rd    : in regNum_t ;
                        rs1   : in regNum_t ;
                        rs2   : in regNum_t )    return std_logic_vector;
	 function EV19_MULHSU(  rd    : in regNum_t ;
                        rs1   : in regNum_t ;
                        rs2   : in regNum_t )    return std_logic_vector;
    function EV19_DIV(  rd    : in regNum_t ;
                        rs1   : in regNum_t ;
                        rs2   : in regNum_t )    return std_logic_vector; 
    function EV19_DIVU(  rd    : in regNum_t ;
                        rs1   : in regNum_t ;
                        rs2   : in regNum_t )    return std_logic_vector;
	 function EV19_REM(  rd    : in regNum_t ;
                        rs1   : in regNum_t ;
                        rs2   : in regNum_t )    return std_logic_vector;
    function EV19_REMU(  rd    : in regNum_t ;
                        rs1   : in regNum_t ;
                        rs2   : in regNum_t )    return std_logic_vector; 								
                        
                        
----------------------------------------------------------------------
--                              INSTRUCTION GROUPS                            --
----------------------------------------------------------------------                      
                        
----------------------------------------------------------------------
--                                      R-TYPE                                        --
----------------------------------------------------------------------
    function R_TYPE(    func7  : in Func7_t;
                        rs2    : in regNum_t ;
                        rs1    : in regNum_t ;
                        func3  : in Func3_t;
                        rd     : in regNum_t ;
                        opcode : in opcode_t) return std_logic_vector;
----------------------------------------------------------------------
--                                      I-TYPE                                        --
----------------------------------------------------------------------
    function I_TYPE(    imm    : in immNum_t ;
                        rs1    : in regNum_t ;                           
                        func3  : in std_logic_vector (2 downto 0);
                        rd     : in regNum_t ;
                        opcode : in opcode_t) return std_logic_vector;
----------------------------------------------------------------------
--                                      S-TYPE                                        --
----------------------------------------------------------------------
	 function S_TYPE(   imm    : in immNum_t ;
						rs2    : in regNum_t ;    
						rs1    : in regNum_t ;    
						func3  : in std_logic_vector (2 downto 0);
						opcode : in opcode_t) return std_logic_vector;
----------------------------------------------------------------------
--                                      B-TYPE                                        --
----------------------------------------------------------------------  
    function B_TYPE(    imm    : in immNum_t ;
						rs2    : in regNum_t ;
                        rs1    : in regNum_t;
                        func3  : in std_logic_vector (2 downto 0);
                        opcode : in opcode_t) return std_logic_vector;
----------------------------------------------------------------------
--                                      U-TYPE                                        --
---------------------------------------------------------------------- 
	 function U_TYPE(   imm    : in immNum_t;
						rd     : in regNum_t;
						opcode : in opcode_t) return std_logic_vector;
----------------------------------------------------------------------
--                                      J-TYPE                                        --
----------------------------------------------------------------------	  
	 function J_TYPE(   imm    : in immNum_t;
						rd     : in regNum_t;
						opcode : in opcode_t) return std_logic_vector;

end package EV19_ISA;

-----------------------BODY--------------------------------------------------------------

package body EV19_ISA is

----------------------------------------------------------------------
--                                      R-TYPE                                        --
----------------------------------------------------------------------
    function R_TYPE(func7  : in Func7_t;
                    rs2    : in regNum_t ;
                    rs1    : in regNum_t ;
                    func3  : in std_logic_vector (2 downto 0);
                    rd     : in regNum_t ;
                    opcode : in opcode_t)
    return std_logic_vector is
    variable instruction : std_logic_vector (31 downto 0);
    begin
        instruction :=  func7                               &
                        std_logic_vector(to_unsigned(rs2,5))&
                        std_logic_vector(to_unsigned(rs1,5))&
                        func3                               & 
                        std_logic_vector(to_unsigned(rd,5)) &
                        opcode;
        return instruction;
    end function;
----------------------------------------------------------------------
--                                      I-TYPE                                        --
----------------------------------------------------------------------
    function I_TYPE(imm    : in immNum_t;
                    rs1    : in regNum_t ;                           
                    func3  : in std_logic_vector (2 downto 0);
                    rd     : in regNum_t ;
                    opcode : in opcode_t)
    return std_logic_vector is
    variable instruction : std_logic_vector (31 downto 0);
    begin
        instruction :=  imm(11 downto 0)	&
                        std_logic_vector(to_unsigned(rs1,5)) 					&
                        func3                                					& 
                        std_logic_vector(to_unsigned(rd,5))  					&
                        opcode;
        return instruction;
    end function;
----------------------------------------------------------------------
--                                      S-TYPE                                        --
----------------------------------------------------------------------
    function S_TYPE(    imm    : in immNum_t ;
								rs2    : in regNum_t ;    
							   rs1    : in regNum_t ;    
							   func3  : in std_logic_vector (2 downto 0);
							   opcode : in opcode_t)
    return std_logic_vector is
    variable instruction : std_logic_vector (31 downto 0);
    begin
        instruction :=  imm(11 downto 5)&
                        std_logic_vector(to_unsigned(rs2,5)) &
                        std_logic_vector(to_unsigned(rs1,5)) &
						func3                        &
						imm(4 downto 0)&
                        opcode;
        return instruction;
    end function;
----------------------------------------------------------------------
--                                      B-TYPE                                        --
----------------------------------------------------------------------
    function B_TYPE(    imm    : in immNum_t ;
								rs2    : in regNum_t ;    
							   rs1    : in regNum_t ;    
							   func3  : in std_logic_vector (2 downto 0);
							   opcode : in opcode_t)
    return std_logic_vector is
    variable instruction : std_logic_vector (31 downto 0);
    begin
        instruction :=  imm(12)&
						imm(10 downto 5)&
                        std_logic_vector(to_unsigned(rs2,5)) &
                        std_logic_vector(to_unsigned(rs1,5)) &
						func3                                &
						imm(4 downto 1)&
						imm(11)&
                        opcode;
        return instruction;
    end function;
----------------------------------------------------------------------
--                                      U-TYPE                                        --
----------------------------------------------------------------------
    function U_TYPE(    imm    : in immNum_t ;
								rd     : in regNum_t ;
							   opcode : in opcode_t)
    return std_logic_vector is
    variable instruction : std_logic_vector (31 downto 0);
    begin
        instruction :=  imm(31 downto 12)&
                        std_logic_vector(to_unsigned(rd,5)) 					&
                        opcode;
        return instruction;
    end function;
----------------------------------------------------------------------
--                                      J-TYPE                                        --
----------------------------------------------------------------------
    function J_TYPE(    imm    : in immNum_t ;
								rd     : in regNum_t ;
							   opcode : in opcode_t)
    return std_logic_vector is
    variable instruction : std_logic_vector (31 downto 0);
    begin
        instruction :=  imm(20)&
						imm(10 downto 1)&
						imm(11)&
						imm(19 downto 12)&
                        std_logic_vector(to_unsigned(rd,5)) 					&
                        opcode;
        return instruction;
    end function;

----------------------------------------------------------------------
--                              Register Instructions                             --
----------------------------------------------------------------------
function EV19_NOP
    return std_logic_vector is
    begin
        return R_TYPE(b"0000000",0,0,b"000",0,OP);
    end function;
------------------------------------------------------
    function EV19_ADD(  rd    : in regNum_t ;
                        rs1   : in regNum_t ;
                        rs2   : in regNum_t )
    return std_logic_vector is
    begin
        return R_TYPE(b"0000000",rs2,rs1,b"000",rd,OP);
    end function;
------------------------------------------------------
    function EV19_SUB(  rd    : in regNum_t ;
                        rs1    : in regNum_t ;
                        rs2    : in regNum_t )
    return std_logic_vector is
    begin
        return R_TYPE(b"0100000",rs2,rs1,b"000",rd,OP);
    end function;
------------------------------------------------------
    function EV19_SLL(  rd    : in regNum_t ;
                        rs1    : in regNum_t ;
                        rs2    : in regNum_t )
    return std_logic_vector is
    begin
        return R_TYPE(b"0000000",rs2,rs1,b"001",rd,OP);
    end function;
------------------------------------------------------
    function EV19_SLT(  rd    : in regNum_t ;
                        rs1    : in regNum_t ;
                        rs2    : in regNum_t )
    return std_logic_vector is
    begin
        return R_TYPE(b"0000000",rs2,rs1,b"010",rd,OP);
    end function;
------------------------------------------------------
    function EV19_SLTU(rd    : in regNum_t ;
                        rs1    : in regNum_t ;
                        rs2    : in regNum_t )
    return std_logic_vector is
    begin
        return R_TYPE(b"0000000",rs2,rs1,b"011",rd,OP);
    end function;
------------------------------------------------------
    function EV19_XOR(  rd    : in regNum_t ;
                        rs1    : in regNum_t ;
                        rs2    : in regNum_t )
    return std_logic_vector is
    begin
        return R_TYPE(b"0000000",rs2,rs1,b"100",rd,OP);
    end function;
------------------------------------------------------
    function EV19_SRL(  rd    : in regNum_t ;
                        rs1    : in regNum_t ;
                        rs2    : in regNum_t )
    return std_logic_vector is
    begin
        return R_TYPE(b"0000000",rs2,rs1,b"101",rd,OP);
    end function;
------------------------------------------------------
    function EV19_SRA(  rd    : in regNum_t ;
                        rs1    : in regNum_t ;
                        rs2    : in regNum_t )
    return std_logic_vector is
    begin
        return R_TYPE(b"0100000",rs2,rs1,b"101",rd,OP);
    end function;
------------------------------------------------------
    function EV19_OR(   rd    : in regNum_t ;
                        rs1    : in regNum_t ;
                        rs2    : in regNum_t )
    return std_logic_vector is
    begin
        return R_TYPE(b"0000000",rs2,rs1,b"110",rd,OP);
    end function;
------------------------------------------------------
    function EV19_AND(  rd    : in regNum_t ;
                        rs1    : in regNum_t ;
                        rs2    : in regNum_t )
    return std_logic_vector is
    begin
        return R_TYPE(b"0000000",rs2,rs1,b"111",rd,OP);
    end function;
------------------------------------------------------

----------------------------------------------------------------------
--                              Inmediate Instructions                            --
----------------------------------------------------------------------
    function EV19_ADDI(rd    : in regNum_t ;
                        rs1   : in regNum_t ;
                        imm   : in immNum_t)
    return std_logic_vector is
    begin
        return I_TYPE(imm,rs1,b"000",rd,OP_IMM);
    end function;
------------------------------------------------------
    function EV19_SLTI(rd    : in regNum_t ;
                        rs1   : in regNum_t ;
                        imm   : in immNum_t)
    return std_logic_vector is
    begin
        return I_TYPE(imm,rs1,b"010",rd,OP_IMM);
    end function;
------------------------------------------------------
    function EV19_SLTIU(rd    : in regNum_t ;
                         rs1   : in regNum_t ;
                         imm   : in immNum_t)
    return std_logic_vector is
    begin
        return I_TYPE(imm,rs1,b"011",rd,OP_IMM);
    end function;
------------------------------------------------------
    function EV19_XORI(rd    : in regNum_t ;
                        rs1   : in regNum_t ;
                        imm   : in immNum_t)
    return std_logic_vector is
    begin
        return I_TYPE(imm,rs1,b"100",rd,OP_IMM);
    end function;
------------------------------------------------------
    function EV19_ORI(  rd    : in regNum_t ;
                        rs1   : in regNum_t ;
                        imm   : in immNum_t)
    return std_logic_vector is
    begin
        return I_TYPE(imm,rs1,b"110",rd,OP_IMM);
    end function;
------------------------------------------------------
    function EV19_ANDI(rd    : in regNum_t ;
                        rs1   : in regNum_t ;
                        imm   : in immNum_t)
    return std_logic_vector is
    begin
        return I_TYPE(imm,rs1,b"111",rd,OP_IMM);
    end function;
------------------------------------------------------
    function EV19_SLLI(rd    : in regNum_t ;
                        rs1   : in regNum_t ;
                        shamt : in regNum_t )
    return std_logic_vector is
    begin
        return I_TYPE(std_logic_vector(to_unsigned(shamt,32)),rs1,b"001",rd,OP_IMM);
    end function;
------------------------------------------------------
    function EV19_SRLI(rd    : in regNum_t ;
                        rs1    : in regNum_t ;
                        shamt : in regNum_t )
    return std_logic_vector is
    begin
        return I_TYPE(std_logic_vector(to_unsigned(shamt,32)),rs1,b"101",rd,OP_IMM);
    end function;
------------------------------------------------------
    function EV19_SRAI(rd    : in regNum_t ;
                        rs1    : in regNum_t ;
                        shamt : in regNum_t )
    return std_logic_vector is
    begin

        return I_TYPE(std_logic_vector(to_unsigned(shamt+1024,32)),rs1,b"101",rd,OP_IMM);
    end function;    
     
----------------------------------------------------------------------
--                              Load imm                            --
----------------------------------------------------------------------
    function EV19_LUI(	rd    : in regNum_t;
						imm   : in immNum_t)
    return std_logic_vector is
    begin
        return U_TYPE(imm,rd,LUI);
    end function;
------------------------------------------------------	 
	 function EV19_AUIPC(rd    : in regNum_t;
							imm   : in immNum_t)
    return std_logic_vector is
    begin
        return U_TYPE(imm,rd,AUIPC);
    end function;

----------------------------------------------------------------------
--                              Jump Instructions                            --
----------------------------------------------------------------------
	 function EV19_JAL(rd    : in regNum_t;
						imm   : in immNum_t)
    return std_logic_vector is
    begin
        return J_TYPE(imm,rd,JAL);
    end function;
---------------------------------------------------------------------
	 function EV19_JALR( rd    : in regNum_t ;
                         rs1   : in regNum_t ;
                         offset: in immNum_t )
    return std_logic_vector is
    begin
        return I_TYPE(offset,rs1,b"000",rd,JALR);
    end function;
----------------------------------------------------------------------
--                              Branch Intructions                            --
----------------------------------------------------------------------
	 function EV19_BEQ(  rs1    : in regNum_t ;
                        rs2    : in regNum_t ;
                        offset : in immNum_t )
    return std_logic_vector is
    begin
        return B_TYPE(offset,rs2,rs1,b"000",BRANCH);
    end function;
---------------------------------------------------------------------- 
	 function EV19_BNE(  rs1    : in regNum_t ;
                        rs2    : in regNum_t ;
                        offset : in immNum_t )
    return std_logic_vector is
    begin
        return B_TYPE(offset,rs2,rs1,b"001",BRANCH);
    end function;
---------------------------------------------------------------------- 
	 function EV19_BLT(  rs1    : in regNum_t ;
                        rs2    : in regNum_t ;
                        offset : in immNum_t )
    return std_logic_vector is
    begin
        return B_TYPE(offset,rs2,rs1,b"100",BRANCH);
    end function;
----------------------------------------------------------------------
	 function EV19_BGE(  rs1    : in regNum_t ;
                        rs2    : in regNum_t ;
                        offset : in immNum_t )
    return std_logic_vector is
    begin
        return B_TYPE(offset,rs2,rs1,b"101",BRANCH);
    end function;
---------------------------------------------------------------------- 
	 function EV19_BLTU(  rs1    : in regNum_t ;
                        rs2    : in regNum_t ;
                        offset : in immNum_t )
    return std_logic_vector is
    begin
        return B_TYPE(offset,rs2,rs1,b"110",BRANCH);
    end function;
---------------------------------------------------------------------- 
	 function EV19_BGEU(  rs1    : in regNum_t ;
                        rs2    : in regNum_t ;
                        offset : in immNum_t )
    return std_logic_vector is
    begin
        return B_TYPE(offset,rs2,rs1,b"111",BRANCH);
    end function;
----------------------------------------------------------------------
--                              Load Instructions                            --
----------------------------------------------------------------------
    function EV19_LB(   rd    : in regNum_t ;
                        rs1   : in regNum_t ;
                        imm   : in immNum_t)
    return std_logic_vector is
    begin
        return I_TYPE(imm,rs1,b"000",rd,LOAD);
    end function;
----------------------------------------------------------------------
    function EV19_LH(   rd    : in regNum_t ;
                        rs1   : in regNum_t ;
                        imm   : in immNum_t)
    return std_logic_vector is
    begin
        return I_TYPE(imm,rs1,b"001",rd,LOAD);
    end function;   
----------------------------------------------------------------------
    function EV19_LW(   rd    : in regNum_t ;
                        rs1   : in regNum_t ;
                        imm   : in immNum_t)
    return std_logic_vector is
    begin
        return I_TYPE(imm,rs1,b"010",rd,LOAD);
    end function;
----------------------------------------------------------------------
    function EV19_LBU(   rd    : in regNum_t ;
                        rs1   : in regNum_t ;
                        imm   : in immNum_t)
    return std_logic_vector is
    begin
        return I_TYPE(imm,rs1,b"100",rd,LOAD);
    end function;  
----------------------------------------------------------------------
    function EV19_LHU(   rd    : in regNum_t ;
                        rs1   : in regNum_t ;
                        imm   : in immNum_t)
    return std_logic_vector is
    begin
        return I_TYPE(imm,rs1,b"101",rd,LOAD);
    end function;  
----------------------------------------------------------------------
--                              Store Instructions                            --
----------------------------------------------------------------------	  
    function EV19_SB(   rs2    : in regNum_t ;
                        rs1   : in regNum_t ;
                        imm   : in immNum_t)
    return std_logic_vector is
    begin
        return S_TYPE(imm,rs2,rs1,b"000",STORE);
    end function;
----------------------------------------------------------------------
    function EV19_SH(   rs2    : in regNum_t ;
                        rs1   : in regNum_t ;
                        imm   : in immNum_t)
    return std_logic_vector is
    begin
        return S_TYPE(imm,rs2,rs1,b"001",STORE);
    end function;  
----------------------------------------------------------------------
    function EV19_SW(   rs2   : in regNum_t ;
                        rs1   : in regNum_t ;
                        imm   : in immNum_t)
    return std_logic_vector is
    begin
        return S_TYPE(imm,rs2,rs1,b"010",STORE);
    end function;  
----------------------------------------------------------------------
--                        Mul and Div Instructions                            --
----------------------------------------------------------------------	 
	 function EV19_MUL(  rd    : in regNum_t ;
                        rs1   : in regNum_t ;
                        rs2   : in regNum_t )
    return std_logic_vector is
    begin
        return R_TYPE(b"0000001",rs2,rs1,b"000",rd,OP);
    end function;
----------------------------------------------------------------------
	function EV19_MULH(  rd    : in regNum_t ;
                        rs1   : in regNum_t ;
                        rs2   : in regNum_t )
    return std_logic_vector is
    begin
        return R_TYPE(b"0000001",rs2,rs1,b"001",rd,OP);
    end function;
----------------------------------------------------------------------
function EV19_MULHSU(  rd    : in regNum_t ;
                        rs1   : in regNum_t ;
                        rs2   : in regNum_t )
    return std_logic_vector is
    begin
        return R_TYPE(b"0000001",rs2,rs1,b"010",rd,OP);
    end function;
----------------------------------------------------------------------
function EV19_MULHU(  rd    : in regNum_t ;
                        rs1   : in regNum_t ;
                        rs2   : in regNum_t )
    return std_logic_vector is
    begin
        return R_TYPE(b"0000001",rs2,rs1,b"011",rd,OP);
    end function;
----------------------------------------------------------------------
function EV19_DIV(  rd    : in regNum_t ;
                        rs1   : in regNum_t ;
                        rs2   : in regNum_t )
    return std_logic_vector is
    begin
        return R_TYPE(b"0000001",rs2,rs1,b"100",rd,OP);
    end function;
----------------------------------------------------------------------
function EV19_DIVU(  rd    : in regNum_t ;
                        rs1   : in regNum_t ;
                        rs2   : in regNum_t )
    return std_logic_vector is
    begin
        return R_TYPE(b"0000001",rs2,rs1,b"101",rd,OP);
    end function;
----------------------------------------------------------------------
function EV19_REM(  rd    : in regNum_t ;
                        rs1   : in regNum_t ;
                        rs2   : in regNum_t )
    return std_logic_vector is
    begin
        return R_TYPE(b"0000001",rs2,rs1,b"110",rd,OP);
    end function;
----------------------------------------------------------------------
function EV19_REMU(  rd    : in regNum_t ;
                        rs1   : in regNum_t ;
                        rs2   : in regNum_t )
    return std_logic_vector is
    begin
        return R_TYPE(b"0000001",rs2,rs1,b"111",rd,OP);
    end function;
end package body EV19_ISA;
