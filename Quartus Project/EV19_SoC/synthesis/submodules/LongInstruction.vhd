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
-- CREATED		"Wed Jun 26 19:07:11 2019"

LIBRARY ieee;
USE ieee.std_logic_1164.all; 

LIBRARY work;

ENTITY LongInstruction IS 
	PORT
	(
		Clk :  IN  STD_LOGIC;
		AluOp :  IN  STD_LOGIC_VECTOR(4 DOWNTO 0);
		longInst :  OUT  STD_LOGIC
	);
END LongInstruction;

ARCHITECTURE bdf_type OF LongInstruction IS 

COMPONENT counter4bit
	PORT(clock : IN STD_LOGIC;
		 cnt_en : IN STD_LOGIC;
		 aclr : IN STD_LOGIC;
		 q : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
	);
END COMPONENT;

COMPONENT compare5bit
	PORT(dataa : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
		 ageb : OUT STD_LOGIC
	);
END COMPONENT;

SIGNAL	counter :  STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_4 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_1 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_3 :  STD_LOGIC;


BEGIN 
SYNTHESIZED_WIRE_1 <= '0';



b2v_ClkCounter : counter4bit
PORT MAP(clock => Clk,
		 cnt_en => SYNTHESIZED_WIRE_4,
		 aclr => SYNTHESIZED_WIRE_1,
		 q => counter);


b2v_CompareALUop : compare5bit
PORT MAP(dataa => AluOp,
		 ageb => SYNTHESIZED_WIRE_4);


longInst <= SYNTHESIZED_WIRE_4 AND SYNTHESIZED_WIRE_3;



SYNTHESIZED_WIRE_3 <= NOT(counter(1) AND counter(3));


END bdf_type;