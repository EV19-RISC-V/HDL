library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

package EV19_Types is
-----------------------------------------------------------------------------------------------------------------------
    -- 
    subtype opcode_t   is STD_LOGIC_VECTOR(6 downto 0);
    --
    subtype func3_t    is STD_LOGIC_VECTOR(2 downto 0);
    --
    subtype func7_t    is STD_LOGIC_VECTOR(6 downto 0);
    --
    subtype regIndex_t is STD_LOGIC_VECTOR(4 downto 0);
    -- 
    subtype word_t     is STD_LOGIC_VECTOR(31 downto 0);
    --
    subtype half_t     is STD_LOGIC_VECTOR(15 downto 0);
    --
    subtype byte_t     is STD_LOGIC_VECTOR(7 downto 0);
    -- Numero de registro (para EV19_ISA.vhd)
    subtype regNum_t is natural range 0 to 31;
    -- Inmediato (para EV19_ISA.vhd)
    subtype immNum_t is STD_LOGIC_VECTOR(31 downto 0);
-----------------------------------------------------------------------------------------------------------------------
    --
    subtype BranchType_t  is STD_LOGIC_VECTOR(1 downto 0); --is INTEGER range 0 to 3; 		-- 3
    --    --
    subtype CompareType_t is STD_LOGIC_VECTOR(2 downto 0); --is INTEGER range 0 to 6;		-- 6
    --    --
    subtype AluOp_t       is STD_LOGIC_VECTOR(4 downto 0); --is INTEGER range 0 to 15;		-- 15
    --    --
    subtype AluSourceA_t  is STD_LOGIC; --is INTEGER range 0 to 1;		-- 1
    --    		--
    subtype AluSourceB_t  is STD_LOGIC; --is INTEGER range 0 to 1;		-- 1
    --  --
    subtype MemOp_t       is STD_LOGIC_VECTOR(1 downto 0);--is INTEGER range 0 to 3; 		-- 3
    --  --
    subtype MemSize_t     is STD_LOGIC_VECTOR(1 downto 0);--is INTEGER range 0 to 2;		-- 2
    --  --
    subtype WbSource_t    is STD_LOGIC; --is INTEGER range 0 to 1;		-- 1

end package EV19_Types;


package body EV19_Types is
end package body EV19_Types;
