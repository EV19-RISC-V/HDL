library ieee;
library work;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
use ieee.std_logic_textio.all;
use std.textio.all;


use work.EV19_Constants.all;
use work.EV19_Types.all;
use work.EV19_ISA.all;

use work.all;

entity CoreTestBench is
end entity CoreTestBench;

architecture testbench of CoreTestBench is

    -- Simulation variables
    constant clk_period : time := 10 ns;
    constant DMEM_SIZE : integer := 1024;
    constant IMEM_SIZE : integer := 256;
    signal simulationEnded : boolean := false;


    function IMM32(value: integer) return std_logic_vector is
    begin
        return std_logic_vector(to_signed(value,32));
    end function;

    -- 
	constant N 		: integer := 12;
    constant DELAY_VAL : std_logic_vector(31 downto 0) := x"00555000";--x"004F4000";

    -- Regs
    constant COUNTER_SHIFTS : integer := 4;
    constant DELAY 			: integer := 5;
    constant COUNTER_DELAY 	: integer := 6;
    constant LEDS 			: integer := 7;
    constant LEDS_NUM 		: integer := 8;
    constant LEDS_ADDR 		: std_logic_vector(31 downto 0) := x"00008000";
	constant RAM_ADDR 		: std_logic_vector(31 downto 0) := x"00001000";
  	constant SDRAM_ADDR 	: std_logic_vector(31 downto 0) := x"02000000";

    -- Simulated memories
    type dmem_t is array (0 to DMEM_SIZE-1) of Word_t;
    type imem_t is array (0 to IMEM_SIZE-1) of Word_t;
    shared variable dataRAM : dmem_t := (others=>(x"00000000")); 
    constant instructionROM : imem_t:= (
                                --Calcula primos, compilado en c. Guarda en RAM.
                                --x"00000097",
                                --x"15808093",
                                --x"00001117",
                                --x"ff810113",
                                --x"00001197",
                                --x"ff018193",
                                --x"00310c63",
                                --x"00008203",
                                --x"00410023",
                                --x"00108093",
                                --x"00110113",
                                --x"fe3118e3",
                                --x"00001097",
                                --x"fd008093",
                                --x"00001117",
                                --x"ff010113",
                                --x"00208863",
                                --x"0000a023",
                                --x"00408093",
                                --x"fe209ce3",
                                --x"00002117",
                                --x"fb010113",
                                --x"004000ef",
                                --x"fe010113",
                                --x"00812e23",
                                --x"02010413",
                                --x"fe042423",
                                --x"000017b7",
                                --x"fe842703",
                                --x"00271713",
                                --x"00078793",
                                --x"00f707b3",
                                --x"00200713",
                                --x"00e7a023",
                                --x"0c00006f",
                                --x"000017b7",
                                --x"fe842703",
                                --x"00271713",
                                --x"00078793",
                                --x"00f707b3",
                                --x"0007a783",
                                --x"00178793",
                                --x"fef42223",
                                --x"fe042623",
                                --x"00200793",
                                --x"fef42023",
                                --x"02c0006f",
                                --x"fe442703",
                                --x"fe042783",
                                --x"02f767b3",
                                --x"00079863",
                                --x"00100793",
                                --x"fef42623",
                                --x"02c0006f",
                                --x"fe042783",
                                --x"00178793",
                                --x"fef42023",
                                --x"fe442783",
                                --x"01f7d713",
                                --x"00f707b3",
                                --x"4017d793",
                                --x"00078713",
                                --x"fe042783",
                                --x"fcf750e3",
                                --x"fec42783",
                                --x"02079463",
                                --x"fe842783",
                                --x"00178713",
                                --x"000017b7",
                                --x"00271713",
                                --x"00078793",
                                --x"00f707b3",
                                --x"fe442703",
                                --x"00e7a023",
                                --x"0140006f",
                                --x"fe442783",
                                --x"00178793",
                                --x"fef42223",
                                --x"f75ff06f",
                                --x"fe842783",
                                --x"00178793",
                                --x"fef42423",
                                --x"fe842703",
                                --x"00900793",
                                --x"f2e7dee3",
                                --x"0000006f",
                                ------------------
                                --Lee del ADC e imprime en LEDs, compilado en c.
                                X"00000097",
                                X"0f008093",
                                X"00001117",
                                X"ff810113",
                                X"00001197",
                                X"ff018193",
                                X"00310c63",
                                X"00008203",
                                X"00410023",
                                X"00108093",
                                X"00110113",
                                X"fe3118e3",
                                X"00001097",
                                X"fd008093",
                                X"00001117",
                                X"fcc10113",
                                X"00208863",
                                X"0000a023",
                                X"00408093",
                                X"fe209ce3",
                                X"00002117",
                                X"fb010113",
                                X"004000ef",
                                X"fd010113",
                                X"02812623",
                                X"03010413",
                                X"000097b7",
                                X"fef42423",
                                X"000087b7",
                                X"fef42223",
                                X"fe042023",
                                X"fc042e23",
                                X"fe842783",
                                X"0007a023",
                                X"fdc42783",
                                X"00279793",
                                X"fe842703",
                                X"00f707b3",
                                X"0007a783",
                                X"fef42023",
                                X"fe042783",
                                X"0047d793",
                                X"fef42023",
                                X"fe042703",
                                X"000017b7",
                                X"00e7a023",
                                X"fe042783",
                                X"0ff7f713",
                                X"fe442783",
                                X"00e78023",
                                X"000027b7",
                                X"71078793",
                                X"fef42623",
                                X"0100006f",
                                X"fec42783",
                                X"fff78793",
                                X"fef42623",
                                X"fec42783",
                                X"fef048e3",
                                X"f95ff06f",   
                                --Auto fantastico compilado en c
                                --x"00000097",
                                --x"1a808093",
                                --x"00001117",
                                --x"ff810113",
                                --x"00001197",
                                --x"ff018193",
                                --x"00310c63",
                                --x"00008203",
                                --x"00410023",
                                --x"00108093",
                                --x"00110113",
                                --x"fe3118e3",
                                --x"00001097",
                                --x"fd008093",
                                --x"00001117",
                                --x"fd410113",
                                --x"00208863",
                                --x"0000a023",
                                --x"00408093",
                                --x"fe209ce3",
                                --x"00002117",
                                --x"fb010113",
                                --x"004000ef",
                                --x"fd010113",
                                --x"02812623",
                                --x"03010413",
                                --x"000087b7",
                                --x"fcf42e23",
                                --x"000017b7",
                                --x"00c78793",
                                --x"fcf42c23",
                                --x"000017b7",
                                --x"00100713",
                                --x"00e78023",
                                --x"000017b7",
                                --x"00078793",
                                --x"00100713",
                                --x"00e780a3",
                                --x"00200793",
                                --x"fef42623",
                                --x"05c0006f",
                                --x"fec42783",
                                --x"fff78713",
                                --x"000017b7",
                                --x"00078793",
                                --x"00f707b3",
                                --x"0007c703",
                                --x"fec42783",
                                --x"ffe78693",
                                --x"000017b7",
                                --x"00078793",
                                --x"00f687b3",
                                --x"0007c783",
                                --x"00f707b3",
                                --x"0ff7f713",
                                --x"000017b7",
                                --x"00078693",
                                --x"fec42783",
                                --x"00f687b3",
                                --x"00e78023",
                                --x"fec42783",
                                --x"00178793",
                                --x"fef42623",
                                --x"fec42703",
                                --x"00b00793",
                                --x"fae7d0e3",
                                --x"fe042423",
                                --x"00100793",
                                --x"fef403a3",
                                --x"000f47b7",
                                --x"24078793",
                                --x"fef42023",
                                --x"0100006f",
                                --x"fe042783",
                                --x"fff78793",
                                --x"fef42023",
                                --x"fe042783",
                                --x"fef048e3",
                                --x"fdc42783",
                                --x"fe744703",
                                --x"00e78023",
                                --x"fd842783",
                                --x"fe744703",
                                --x"00e78023",
                                --x"fe842783",
                                --x"00079a63",
                                --x"fe744783",
                                --x"00179793",
                                --x"fef403a3",
                                --x"0100006f",
                                --x"fe744783",
                                --x"0017d793",
                                --x"fef403a3",
                                --x"fe744783",
                                --x"f8079ee3",
                                --x"fe842783",
                                --x"00079863",
                                --x"f8000793",
                                --x"fef403a3",
                                --x"00c0006f",
                                --x"00100793",
                                --x"fef403a3",
                                --x"fe842783",
                                --x"0017c793",
                                --x"fef42423",
                                --x"f71ff06f",
                                --Fibonacci a los LEDs escrito en C. Sin optimizacion, con delay.
                                --x"00000097",
                                --x"18808093",
                                --x"00001117",
                                --x"ff810113",
                                --x"00001197",
                                --x"ff018193",
                                --x"00310c63",
                                --x"00008203",
                                --x"00410023",
                                --x"00108093",
                                --x"00110113",
                                --x"fe3118e3",
                                --x"00001097",
                                --x"fd008093",
                                --x"00001117",
                                --x"fd410113",
                                --x"00208863",
                                --x"0000a023",
                                --x"00408093",
                                --x"fe209ce3",
                                --x"00002117",
                                --x"fb010113",
                                --x"004000ef",
                                --x"fd010113",
                                --x"02812623",
                                --x"03010413",
                                --x"000087b7",
                                --x"fef42023",
                                --x"000017b7",
                                --x"00c78793",
                                --x"fcf42e23",
                                --x"000017b7",
                                --x"00100713",
                                --x"00e78023",
                                --x"000017b7",
                                --x"00078793",
                                --x"00100713",
                                --x"00e780a3",
                                --x"00200793",
                                --x"fef42623",
                                --x"05c0006f",
                                --x"fec42783",
                                --x"fff78713",
                                --x"000017b7",
                                --x"00078793",
                                --x"00f707b3",
                                --x"0007c703",
                                --x"fec42783",
                                --x"ffe78693",
                                --x"000017b7",
                                --x"00078793",
                                --x"00f687b3",
                                --x"0007c783",
                                --x"00f707b3",
                                --x"0ff7f713",
                                --x"000017b7",
                                --x"00078693",
                                --x"fec42783",
                                --x"00f687b3",
                                --x"00e78023",
                                --x"fec42783",
                                --x"00178793",
                                --x"fef42623",
                                --x"fec42703",
                                --x"00b00793",
                                --x"fae7d0e3",
                                --x"fe042423",
                                --x"000187b7",
                                --x"6a078793",
                                --x"fef42223",
                                --x"0100006f",
                                --x"fe442783",
                                --x"fff78793",
                                --x"fef42223",
                                --x"fe442783",
                                --x"fef048e3",
                                --x"000017b7",
                                --x"00078713",
                                --x"fe842783",
                                --x"00f707b3",
                                --x"0007c703",
                                --x"fe042783",
                                --x"00e78023",
                                --x"000017b7",
                                --x"00078713",
                                --x"fe842783",
                                --x"00f707b3",
                                --x"0007c703",
                                --x"fdc42783",
                                --x"00e78023",
                                --x"fe842783",
                                --x"00178793",
                                --x"fef42423",
                                --x"fe842703",
                                --x"00c00793",
                                --x"f8f718e3",
                                --x"fe042423",
                                --x"f89ff06f",
        -----------------------------------------------------------------------
    							-- Fibo Maxi
    							--EV19_LUI(1,x"00000000"),    -- 0  countMax
    							--EV19_ADDI(2,0,IMM32(0)),	-- 4  count = 0
    							--EV19_ADDI(2,2,IMM32(1)),	-- 8  count = count + 1
								--EV19_BLTU(2,1,IMM32(-1*4)), -- 12  while(count < countMax)
  								--
    							--EV19_LUI(1,DELAY_VAL),		-- 16  countMax
    							--EV19_ADDI(2,0,IMM32(0)),	-- 20  count = 0
    							--EV19_ADDI(3,0,IMM32(0)),	-- 24  i1 = 0
    							----EV19_LUI(7,SDRAM_ADDR),		-- 28  i2 = SDRAM_ADDR
    							--EV19_ADDI(7,0,IMM32()),		
    							--EV19_ADDI(4,0,IMM32(36)),	-- 32  N = 36
    							--EV19_ADDI(5,0,IMM32(36)),	-- 36  n = 0
----
    							--EV19_LW(6,7,IMM32(0)),		-- 40  x = SDRAM[i]
								--EV19_SW(6,3,IMM32(0)),	    -- 44  RAM[i] = x
								--EV19_ADDI(2,2,IMM32(1)),	-- 48  count = count + 1
								--EV19_BLTU(2,1,IMM32(-1*4)), -- 52  while(count < countMax)
								--EV19_NOP,
								--EV19_NOP,
								--EV19_NOP,
								--EV19_ADDI(5,0,IMM32(1)),    -- 56  n = n + 1
								--EV19_NOP,
								--EV19_NOP,
								--EV19_NOP,
								--EV19_ADDI(3,3,IMM32(4)),	-- 60  i1 = i1 + 4
								--EV19_NOP,
								--EV19_NOP,
								--EV19_NOP,
								--EV19_ADDI(7,7,IMM32(4)),	-- 64  i2 = i2 + 4
								--EV19_NOP,
								--EV19_NOP,
								--EV19_NOP,
								--EV19_BLTU(5,4,IMM32(-19*4)), -- 68  while(n < N)
								--EV19_NOP,
								--EV19_NOP,
								--EV19_NOP,
								--EV19_BEQ(0,0,IMM32(0)),		-- 72  while(1)
----------------------------------------------------------------------------------------------
                                --Test Fibo a los LEDS desde SDRAM
								--EV19_ADDI(25,0,IMM32(N)),      -- 0   n = 12                    
								--EV19_ADDI(24,0,IMM32(0)),      -- 4   i = 0     
								--EV19_ADDI(1,0,IMM32(0)),       -- 8   a = 0         
								--EV19_ADDI(2,0,IMM32(1)),       -- 12  b = 1           
								--EV19_ADDI(3,0,IMM32(0)),       -- 16  c = 0
								--EV19_LUI(4,SDRAM_ADDR),	   -- 20  address_i
                                --EV19_LUI(23,LEDS_ADDR),    -- 20  address_i
								----EV19_ADDI(4,0, IMM32(4*(N+1))),-- 20	  
								--EV19_ADDI(5,0,IMM32(0)),	   -- 24
								--------------------------------------------------
								--EV19_ADD(3,1,2),               -- 28  c = a + b   
								--EV19_ADD(1,0,2),               -- 32  a = b  
								--EV19_ADD(2,0,3),               -- 36  b = c 
								--EV19_SW(3,4,IMM32(0)),		   -- 40  MEM[address_i] = c SDRAM
								--EV19_SW(3,5,IMM32(0)),		   -- 44  MEM[]
								--EV19_ADDI(24,24,IMM32(1)),     -- 48  i = i + 1         
								--EV19_ADDI(4,4,IMM32(4)),	   -- 52  address_i += 4 
								--EV19_ADDI(5,5,IMM32(4)),	   -- 56  address_i += 4     
								--EV19_BLT(24,25,IMM32(-8*4)),   -- 60  while(i<n)
								--------------------------------------------------
								--EV19_ADDI(24,0,IMM32(0)),	   -- 64  i = 0
								--EV19_ADDI(5,0,IMM32(0)),	   -- 68  counterDelay = 0
								--EV19_LUI(4,SDRAM_ADDR),	   -- 72  address_i
								----EV19_ADDI(4,0, IMM32(4*(N+1))),-- 72		
								--EV19_LUI(10,DELAY_VAL),    -- 76  delay
								----EV19_ADDI(10,0,IMM32(20)),     -- 76
								--EV19_LW(6,4,IMM32(0)),		   -- 80  x = MEM[address_i]
								----EV19_NOP,
								----EV19_NOP,
								----EV19_NOP,
								----EV19_NOP,
								----EV19_NOP,
								--EV19_SB(6,23,IMM32(0)),    -- 80  MEM[N+1] = x --- aca decia reg=0
								--EV19_ADDI(4,4,IMM32(4)),	   -- 84  address_i += 4   
								--EV19_ADDI(24,24,IMM32(1)),     -- 88  i = i + 1 
--------
								--EV19_ADDI(5,5,IMM32(1)),	   -- 92  counterDelay ++
								--EV19_BLTU(5,10,IMM32(-1*4)),   -- 96  while(counterDelay<delay)
--------
								--EV19_ADDI(5,0,IMM32(0)),	   -- 100  counterDelay = 0
								--EV19_BLT(24,25,IMM32(-7*4)),  -- 104  while(i<n)
								--EV19_BEQ(0,0,IMM32(0)),		   -- 110  while(1)
--

    							-- Stores en memoria
    							--EV19_ADDI(30,0,IMM32(30)),		--cantidad a guardar
								--EV19_ADDI(1,0,IMM32(5))	,		--valor a guardar, guarda i+5 en i
								--EV19_ADDI(2,0,IMM32(0))	,		--contador
								--EV19_SW(1,2,IMM32(0))	,		--guardo en memoria
								--EV19_SW(1,2,IMM32(40))	,		--guardo en memoria
								--EV19_ADDI(1,1,IMM32(1))	,		--++
								--EV19_ADDI(2,2,IMM32(4))	,		--++
								--EV19_BLT(2,30,IMM32(-4*4)),		--for contador < cantidad

    							-- LEDS
    							--EV19_ADDI(COUNTER_SHIFTS,0,IMM32(0)),				-- 	0							
    							--EV19_LUI(DELAY,x"017D7000"),				-- 	4		
    							--EV19_ORI(DELAY,DELAY,x"00000740"),					
    							--EV19_ADDI(COUNTER_DELAY,0,IMM32(0)),				-- 	8							
    							--EV19_ADDI(LEDS,0,IMM32(1)),							-- 12					
    							--EV19_ADDI(LEDS_NUM,0,IMM32(32)),						-- 16						
    							----EV19_LUI(10,x"00001000"),							-- 20					
    							--EV19_SW(LEDS,0,IMM32(0)),							-- 24					
    							----EV19_SB(LEDS,0,IMM32(0)),							-- 28					
    							--EV19_SLLI(LEDS,LEDS,1),								-- 32				
    							--EV19_ADDI(COUNTER_SHIFTS,COUNTER_SHIFTS,IMM32(1)),	-- 36									
    							--EV19_ANDI(9,COUNTER_SHIFTS,IMM32(31)),				-- 40				
    							--EV19_BNE(9,0,IMM32(2*4)),							-- 44	
    							--EV19_ADDI(LEDS,0,IMM32(1)),							-- 48	
    							--EV19_ADDI(COUNTER_DELAY,COUNTER_DELAY,IMM32(1)),	-- 52							
    							--EV19_BLTU(COUNTER_DELAY,DELAY,IMM32(-1*4)),			-- 56					
    							--EV19_ADDI(COUNTER_DELAY,0,IMM32(0)),				-- 60				
    							--EV19_JAL(0,IMM32(-9*4)),							-- 64	

                                -- Fibo Maxi
                                -- EV19_ADDI(25,0,IMM32(25)),     -- 0   n = 25                    
                                -- EV19_ADDI(24,0,IMM32(0)),      -- 4   i = 0     
                                -- EV19_ADDI(1,0,IMM32(1)),       -- 8   a = 1         
                                -- EV19_ADDI(2,0,IMM32(1)),       -- 12  b = 1           
                                -- EV19_ADDI(3,0,IMM32(0)),       -- 16  c = 0
                                ---------------------------------------------------
                                -- EV19_ADD(3,1,2),               -- 20  c = a + b   
                                -- EV19_ADD(1,0,2),               -- 24  a = b  
                                -- EV19_ADD(2,0,3),               -- 28  c = b 
                                -- EV19_ADDI(24,24,x"00000001"),  -- 32  i = i + 1               
                                -- EV19_BLT(24,25,IMM32(-4*4)),   -- 36  while(i<n)
                                -- EV19_ADDI(4,0,IMM32(1)),       -- 40
                                -- EV19_SW(5,0,IMM32(76)),        -- 44

                                --   LOAD HAZARD (load a registro) (habia que flushear ~execute~ MEMORY!!!!!! me di cuenta a las 6am :) )
                                --EV19_ADDI(1,0,IMM32(14)),                                              
                                --EV19_SW(1,0,IMM32(0)),       
                                --EV19_ADDI(1,0,IMM32(0)),
                                --EV19_NOP,
                                --EV19_NOP,
                                --EV19_NOP,
                                --EV19_NOP,
                                --EV19_NOP,
                                --EV19_NOP,
                                --EV19_NOP,
                                --EV19_NOP,
                                --EV19_NOP,
                                --EV19_LW(2,0,IMM32(0)),
                                --EV19_ADDI(3,2,IMM32(1)),

                                --   LOAD HAZARD (RAW in memory) 
                                --EV19_ADDI(1,0,IMM32(14)),                                              
                                --EV19_SW(1,0,IMM32(0)),
                                --EV19_LW(2,0,IMM32(0)),     
                                --EV19_NOP,
                                --EV19_NOP,
                                --EV19_NOP,
                                --EV19_NOP,
                                --EV19_NOP,
                                --EV19_NOP,
                                --EV19_NOP,
                                --EV19_NOP,
                                --EV19_NOP,
                                --EV19_LW(2,0,IMM32(0)),
                                --EV19_ADDI(3,2,IMM32(1)),

                                --   LOAD HAZARD (y despues un branch) 
                                --EV19_ADDI(1,0,IMM32(-14)),      -- 0                                                                      
                                --EV19_SW(1,1,IMM32(18)),         -- 4                
                                --EV19_ADDI(2,1,IMM32(20)),       -- 8                    
                                --EV19_NOP,                      -- 12      
                                --EV19_NOP,                      -- 16      
                                --EV19_NOP,                      -- 20      
                                --EV19_NOP,                      -- 24      
                                --EV19_NOP,                      -- 28      
                                --EV19_NOP,                      -- 32      
                                --EV19_NOP,                      -- 36      
                                --EV19_NOP,                      -- 40      
                                --EV19_NOP,                      -- 44      
                                --EV19_LW(2,0,IMM32(0)),         -- 48
                                --EV19_BGE(0,2,IMM32(4*4)),      -- 52
                                --EV19_ADDI(3,0,IMM32(3)),       -- 56
                                --EV19_ADDI(4,0,IMM32(4)),       -- 60
                                --EV19_ADDI(5,0,IMM32(5)),       --



                                -- Fibo Santi
                               --EV19_ADDI(25,0,IMM32(25)),   -- n = 25           0                       
                               --EV19_ADDI(1,0,IMM32(1)),     --                  4       
                               --                                                
                               --EV19_SW(0,0,IMM32(0)),       -- a = 0            8                   
                               --EV19_SW(1,0,IMM32(4)),       -- b = 1            12                   
                               --EV19_SW(0,0,IMM32(8)),       -- i = 0            16                   
                               ---------------------------------------------------                             
                               --EV19_LW(2,0,IMM32(8)),       -- if i % 2 = 0     20                           
                               --EV19_ANDI(2,2,IMM32(1)),     --                  24       
                               --EV19_BNE(2,0,IMM32(6*4)),    --                  28       
                               -------- PARES  -----------------------------------                              
                               --EV19_LW(1,0,IMM32(0)),       --                  32       
                               --EV19_LW(2,0,IMM32(4)),       --                  36       
                               --EV19_ADD(1,1,2),             --                  40       
                               --EV19_SW(1,0,IMM32(0)),       -- a = a + b        44                           
                               --EV19_JAL(0,IMM32(5*4)),      --                  48   
                               ------- IMPARES -----------------------------------
                               --EV19_LW(1,0,IMM32(0)),       --                  52       
                               --EV19_LW(2,0,IMM32(4)),       --                  56       
                               --EV19_ADD(1,1,2),             --                  60       
                               --EV19_SW(1,0,IMM32(4)),       -- b = a + b        64                       
                               ------- COMUN  ------------------------------------
                               --EV19_LW(2,0,IMM32(8)),       --                  68       
                               --EV19_ADDI(1,2,IMM32(1)),     --                  72               
                               --EV19_SW(1,0,IMM32(8)),       -- i = i + 1        76                       
                               --                      
                               --EV19_BLT(1,25,IMM32(-15*4)), ---- while(i<n)                                    
                               --EV19_ADDI(25,24,x"DEADBEEF"),----                                               
                               --  
                                others=> EV19_NOP);


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

    -------------------------------------------------------------------------------------
    -- Signal to interface core
    signal clk              : STD_LOGIC := '0';
    signal reset            : STD_LOGIC := '0';
    signal dMemReadData     : STD_LOGIC_VECTOR(31 DOWNTO 0) := (others =>'0');
    signal dMemAck          : STD_LOGIC := '0';
    signal dMemWaitReq      : STD_LOGIC := '0';
    signal dMemAddress      : STD_LOGIC_VECTOR(31 DOWNTO 0);
    signal dMemByteEnable   : STD_LOGIC_VECTOR(3 DOWNTO 0);
    signal dMemReadReq      : STD_LOGIC;
    signal dMemWriteReq     : STD_LOGIC;
    signal dMemWriteData    : STD_LOGIC_VECTOR(31 DOWNTO 0);
    signal iMemReadData     : STD_LOGIC_VECTOR(31 DOWNTO 0) := (others =>'0');
    signal iMemAck          : STD_LOGIC;
    signal iMemWaitReq      : STD_LOGIC := '0';
    signal iMemAddress      : STD_LOGIC_VECTOR(31 DOWNTO 0);
    signal iMemByteEnable   : STD_LOGIC_VECTOR(3 DOWNTO 0);
    signal iMemReadReq      : STD_LOGIC;
    -- Probar si se pueden leer los registros desde afuera
    -- signal regAddress    : STD_LOGIC_VECTOR(4 DOWNTO 0);
    -- signal regData       : STD_LOGIC_VECTOR(31 DOWNTO 0);
    -------------------------------------------------------------------------------------
    
    COMPONENT Core
    PORT
    (
        clock               :    IN STD_LOGIC;
        reset               :    IN STD_LOGIC;
        dataMemReadData     :    IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        dataMemAck          :    IN STD_LOGIC;
        dataMemAddress      :    OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        dataMemByteEnable   :    OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
        dataMemReadReq      :    OUT STD_LOGIC;
        dataMemWriteReq     :    OUT STD_LOGIC;
        dataMemWriteData    :    OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        instMemReadData     :    IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        instMemAck          :    IN STD_LOGIC;
        instMemAddress      :    OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        instMemByteEnable   :    OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
        instMemReadReq      :    OUT STD_LOGIC
    );
    END COMPONENT;


begin
    uut: Core
        port map(
                clock               => clk      ,
                reset               => reset ,
                dataMemReadData     => dMemReadData ,
                dataMemAck          => dMemAck  ,
                dataMemAddress      => dMemAddress  ,
                dataMemByteEnable   => dMemByteEnable,
                dataMemReadReq      => dMemReadReq  ,
                dataMemWriteReq     => dMemWriteReq ,
                dataMemWriteData    => dMemWriteData,
                instMemReadData     => iMemReadData,    
                instMemAck          => iMemAck,         
                instMemAddress      => iMemAddress,     
                instMemByteEnable   => iMemByteEnable,
                instMemReadReq      => iMemReadReq                          
            );

    memoryDump: process
    file InstructionMemory : text;
    variable outputLine : line;
    begin
        file_open(InstructionMemory, "../../Bloques/imem/imem.mif", write_mode);

        write(outputLine, string'("WIDTH=32;"));
        writeline(InstructionMemory, outputLine);
        write(outputLine, string'("DEPTH=256;"));
        writeline(InstructionMemory, outputLine);
        write(outputLine, string'("ADDRESS_RADIX=UNS;"));
        writeline(InstructionMemory, outputLine);
        write(outputLine, string'("DATA_RADIX=HEX;"));
        writeline(InstructionMemory, outputLine);
        write(outputLine, string'("CONTENT BEGIN"));
        writeline(InstructionMemory, outputLine);

        dump : for i in 0 to IMEM_SIZE-1 loop
        	write(outputLine,i);
        	write(outputLine,string'(" : "));
            write(outputLine, to_hstring(instructionROM(i)));
            write(outputLine,string'(";"));
            writeline(InstructionMemory, outputLine);
        end loop dump;

        write(outputLine, string'("END;"));
        writeline(InstructionMemory, outputLine);

        file_close(InstructionMemory);
        wait until simulationEnded=true;
        wait;
    end process memoryDump;

    clock: process
    begin
        clk <= '0';
        wait for clk_period / 2;
        clk <= '1';
        wait for clk_period / 2;

        if simulationEnded then
            wait;
        end if;

    end process clock;

    resetPrc: process
    begin
        reset <= '1';
        wait for clk_period * 5;
        wait until rising_edge(Clk);
        reset <= '0';
        wait;
    end process resetPrc;

    -- Cuando cuenta 10 nops seguidos o 50 instrucciones
    -- para la simulación (para evitar loops infinitos)
    stopSimulation: process
    variable nopCount : integer :=0;
    variable instCount : integer :=0;
    variable instAddress : std_logic_vector(31 downto 0) :=(others=>'0');
    begin
        wait until reset='0';

        while simulationEnded=false loop
            wait until rising_edge(Clk);

            -- Count instructions and NOPS
            if iMemAck='1' and iMemAddress/=instAddress then
                -- Count NOP
                if iMemReadData=EV19_NOP then
                    nopCount := nopCount + 1;
                else 
                    nopCount := 0;
                end if;

                instAddress := iMemAddress;
                instCount := instCount + 1;
            end if;

            if (nopCount = 7 or instCount = 3000) then
                --wait until dMemAck='1';
                wait for clk_period*20;
                simulationEnded <= true;
            end if; 
        end loop;
        wait;
    end process stopSimulation;



    -- Contesta el request a la memoria de instrucciones
    iMemAck <= not iMemWaitReq and iMemReadReq;

    iMemPrc: process
    variable word : Word_t;
    variable byte0 : Byte_t;
    variable byte1 : Byte_t;
    variable byte2 : Byte_t;
    variable byte3 : Byte_t;
    begin
        wait until reset='0';
        
        while simulationEnded=false loop
            wait until rising_edge(Clk);

            if iMemReadReq='1' then
            	word  := instructionROM(to_integer(unsigned(iMemAddress(log2(IMEM_SIZE)+1 downto 2))));
            	if iMemByteEnable(0)='1' then byte0 := word(7 downto 0);   else byte0 := x"00"; end if;
            	if iMemByteEnable(1)='1' then byte1 := word(15 downto 8);  else byte1 := x"00"; end if;
            	if iMemByteEnable(2)='1' then byte2 := word(23 downto 16); else byte2 := x"00"; end if;
            	if iMemByteEnable(3)='1' then byte3 := word(31 downto 24); else byte3 := x"00"; end if;
            	iMemReadData <= byte3 & byte2 & byte1 & byte0; 
            end if;

        end loop;
        wait;
    end process iMemPrc;

    -- Contesta el request a la memoria de datos

  --  dMemAck <= not dMemWaitReq and (dMemWriteReq or dMemReadReq);

    dMemPrc: process
    variable word : Word_t;
    variable byte0 : Byte_t;
    variable byte1 : Byte_t;
    variable byte2 : Byte_t;
    variable byte3 : Byte_t;
    variable tempAddress : Word_t;
    file memoryOperations : text;
    variable operation : line;
    begin
        file_open(memoryOperations, "memoryOperations.txt", write_mode);
        wait until reset='0';
        
        while simulationEnded=false loop


            wait until rising_edge(Clk);
            if dMemAck='1' then
            	dMemAck <= '0';
            	dMemReadData <=(others	=>'0');
            elsif dMemReadReq='1' then
	            word  := dataRAM(to_integer(unsigned(dMemAddress(log2(DMEM_SIZE)+1 downto 2))));
	            if dMemByteEnable(0)='1' then byte0 := word(7 downto 0);   else byte0 := x"00"; end if;
	            if dMemByteEnable(1)='1' then byte1 := word(15 downto 8);  else byte1 := x"00"; end if;
	            if dMemByteEnable(2)='1' then byte2 := word(23 downto 16); else byte2 := x"00"; end if;
	            if dMemByteEnable(3)='1' then byte3 := word(31 downto 24); else byte3 := x"00"; end if;
	            
	            wait for clk_period*5;
	            wait until	rising_edge(clk);
	            dMemAck<='1';
	            dMemReadData <= byte3 & byte2 & byte1 & byte0; 
	            
	            write(operation, string'("READ  "));
	            write(operation, to_hstring(dMemAddress(3 downto 0)));
	            writeline(memoryOperations, operation);
	        elsif dMemWriteReq='1' then
	            word  := dataRAM(to_integer(unsigned(dMemAddress(log2(DMEM_SIZE)+1 downto 2))));
	            tempAddress := dMemAddress;
	            if dMemByteEnable(0)='1' then byte0 := dMemWriteData(7 downto 0);   else byte0 := word(7 downto 0)  ; end if;
	            if dMemByteEnable(1)='1' then byte1 := dMemWriteData(15 downto 8);  else byte1 := word(15 downto 8) ; end if;
	            if dMemByteEnable(2)='1' then byte2 := dMemWriteData(23 downto 16); else byte2 := word(23 downto 16); end if;
	            if dMemByteEnable(3)='1' then byte3 := dMemWriteData(31 downto 24); else byte3 := word(31 downto 24); end if;
	            word  := byte3 & byte2 & byte1 & byte0;

	            wait for clk_period*5;
	            wait until	rising_edge(clk);
	            dMemAck<='1';

	            dataRAM(to_integer(unsigned(tempAddress(log2(DMEM_SIZE)+1 downto 2)))) := word;
	            
	            write(operation, string'("WRITE "));
	            write(operation, to_hstring(dMemAddress(3 downto 0)));
	            writeline(memoryOperations, operation);
            end if;
        end loop;
        file_close(memoryOperations);
        wait;
    end process dMemPrc;

end architecture testbench;
