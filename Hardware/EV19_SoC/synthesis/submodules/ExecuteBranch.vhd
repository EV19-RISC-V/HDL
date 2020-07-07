-- Copyright (C) 2018  Intel Corporation. All rights reserved.
-- Your use of Intel Corporation's design tools, logic functions 
-- and other software and tools, and its AMPP partner logic 
-- functions, and any output files from any of the foregoing 
-- (including device programming or simulation files), and any 
-- associated documentation or information are expressly subject 
-- to the terms and conditions of the Intel Program License 
-- Subscription Agreement, the Intel Quartus Prime License Agreement,
-- the Intel FPGA IP License Agreement, or other applicable license
-- agreement, including, without limitation, that your use is for
-- the sole purpose of programming logic devices manufactured by
-- Intel and sold by Intel or its authorized distributors.  Please
-- refer to the applicable agreement for further details.

-- PROGRAM		"Quartus Prime"
-- VERSION		"Version 18.1.0 Build 625 09/12/2018 SJ Lite Edition"
-- CREATED		"Wed Jun 26 19:07:18 2019"

LIBRARY ieee;
USE ieee.std_logic_1164.all; 

LIBRARY work;

ENTITY ExecuteBranch IS 
	PORT
	(
		predict :  IN  STD_LOGIC;
		BranchType :  IN  STD_LOGIC_VECTOR(1 DOWNTO 0);
		CmpType :  IN  STD_LOGIC_VECTOR(2 DOWNTO 0);
		Imm :  IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
		nextPC :  IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
		PC :  IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
		Rs1 :  IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
		Rs2 :  IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
		unconditional :  OUT  STD_LOGIC;
		taken :  OUT  STD_LOGIC;
		updateBHT :  OUT  STD_LOGIC;
		updateBTB :  OUT  STD_LOGIC;
		updatePC :  OUT  STD_LOGIC;
		cancelJump :  OUT  STD_LOGIC;
		BranchTarget :  OUT  STD_LOGIC_VECTOR(31 DOWNTO 0)
	);
END ExecuteBranch;

ARCHITECTURE bdf_type OF ExecuteBranch IS 

COMPONENT adder
	PORT(add_sub : IN STD_LOGIC;
		 dataa : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 datab : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 result : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
	);
END COMPONENT;

COMPONENT mux8x1
	PORT(data7 : IN STD_LOGIC;
		 data6 : IN STD_LOGIC;
		 data5 : IN STD_LOGIC;
		 data4 : IN STD_LOGIC;
		 data3 : IN STD_LOGIC;
		 data2 : IN STD_LOGIC;
		 data1 : IN STD_LOGIC;
		 data0 : IN STD_LOGIC;
		 sel : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
		 result : OUT STD_LOGIC
	);
END COMPONENT;

COMPONENT comparator32
	PORT(dataa : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 datab : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 aeb : OUT STD_LOGIC;
		 aneb : OUT STD_LOGIC;
		 ageb : OUT STD_LOGIC;
		 alb : OUT STD_LOGIC
	);
END COMPONENT;

COMPONENT comparator32u
	PORT(dataa : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 datab : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 aeb : OUT STD_LOGIC;
		 aneb : OUT STD_LOGIC;
		 ageb : OUT STD_LOGIC;
		 alb : OUT STD_LOGIC
	);
END COMPONENT;

COMPONENT mux2x32bit
	PORT(sel : IN STD_LOGIC;
		 data0x : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 data1x : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 result : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
	);
END COMPONENT;

SIGNAL	branchTarget_ALTERA_SYNTHESIZED :  STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL	cancelJump_ALTERA_SYNTHESIZED :  STD_LOGIC;
SIGNAL	do_branch :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_0 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_1 :  STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_27 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_3 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_4 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_5 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_28 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_7 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_8 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_9 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_10 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_11 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_12 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_15 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_16 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_18 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_19 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_20 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_21 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_23 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_26 :  STD_LOGIC;


BEGIN 
SYNTHESIZED_WIRE_0 <= '1';
SYNTHESIZED_WIRE_28 <= '1';



b2v_Adder : adder
PORT MAP(add_sub => SYNTHESIZED_WIRE_0,
		 dataa => SYNTHESIZED_WIRE_1,
		 datab => Imm,
		 result => branchTarget_ALTERA_SYNTHESIZED);


SYNTHESIZED_WIRE_4 <= SYNTHESIZED_WIRE_27 AND SYNTHESIZED_WIRE_3;


SYNTHESIZED_WIRE_26 <= BranchType(1) AND BranchType(0);


do_branch <= SYNTHESIZED_WIRE_4 AND SYNTHESIZED_WIRE_5;


b2v_BranchMux : mux8x1
PORT MAP(data7 => SYNTHESIZED_WIRE_28,
		 data6 => SYNTHESIZED_WIRE_7,
		 data5 => SYNTHESIZED_WIRE_8,
		 data4 => SYNTHESIZED_WIRE_9,
		 data3 => SYNTHESIZED_WIRE_10,
		 data2 => SYNTHESIZED_WIRE_11,
		 data1 => SYNTHESIZED_WIRE_12,
		 data0 => SYNTHESIZED_WIRE_28,
		 sel => CmpType,
		 result => SYNTHESIZED_WIRE_3);


b2v_Comp32 : comparator32
PORT MAP(dataa => Rs1,
		 datab => Rs2,
		 aeb => SYNTHESIZED_WIRE_12,
		 aneb => SYNTHESIZED_WIRE_11,
		 ageb => SYNTHESIZED_WIRE_10,
		 alb => SYNTHESIZED_WIRE_9);


b2v_Comp32u : comparator32u
PORT MAP(dataa => Rs1,
		 datab => Rs2,
		 ageb => SYNTHESIZED_WIRE_8,
		 alb => SYNTHESIZED_WIRE_7);


b2v_compTarget : comparator32u
PORT MAP(dataa => branchTarget_ALTERA_SYNTHESIZED,
		 datab => nextPC,
		 aneb => SYNTHESIZED_WIRE_21);


updateBHT <= SYNTHESIZED_WIRE_27 AND SYNTHESIZED_WIRE_15;


cancelJump_ALTERA_SYNTHESIZED <= SYNTHESIZED_WIRE_16 AND predict;


SYNTHESIZED_WIRE_23 <= NOT(cancelJump_ALTERA_SYNTHESIZED);



updatePC <= SYNTHESIZED_WIRE_27 AND SYNTHESIZED_WIRE_18;


SYNTHESIZED_WIRE_18 <= SYNTHESIZED_WIRE_19 OR SYNTHESIZED_WIRE_20;


SYNTHESIZED_WIRE_19 <= do_branch AND predict AND SYNTHESIZED_WIRE_21;


SYNTHESIZED_WIRE_16 <= NOT(do_branch);



updateBTB <= SYNTHESIZED_WIRE_27 AND SYNTHESIZED_WIRE_23;



unconditional <= SYNTHESIZED_WIRE_27 AND BranchType(1);


SYNTHESIZED_WIRE_15 <= NOT(BranchType(1));




taken <= SYNTHESIZED_WIRE_27 AND do_branch;


b2v_Mux : mux2x32bit
PORT MAP(sel => SYNTHESIZED_WIRE_26,
		 data0x => PC,
		 data1x => Rs1,
		 result => SYNTHESIZED_WIRE_1);


SYNTHESIZED_WIRE_5 <= NOT(branchTarget_ALTERA_SYNTHESIZED(1) OR branchTarget_ALTERA_SYNTHESIZED(0));


SYNTHESIZED_WIRE_27 <= BranchType(1) OR BranchType(0);


SYNTHESIZED_WIRE_20 <= do_branch XOR predict;

cancelJump <= cancelJump_ALTERA_SYNTHESIZED;
BranchTarget <= branchTarget_ALTERA_SYNTHESIZED;

END bdf_type;