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
-- CREATED		"Wed Jun 26 19:07:25 2019"

LIBRARY ieee;
USE ieee.std_logic_1164.all; 

LIBRARY work;

ENTITY LoadBlock IS 
	PORT
	(
		dMemOffset :  IN  STD_LOGIC_VECTOR(1 DOWNTO 0);
		dMemReadData :  IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
		MemOp :  IN  STD_LOGIC_VECTOR(1 DOWNTO 0);
		MemSize :  IN  STD_LOGIC_VECTOR(1 DOWNTO 0);
		MemDataM :  OUT  STD_LOGIC_VECTOR(31 DOWNTO 0)
	);
END LoadBlock;

ARCHITECTURE bdf_type OF LoadBlock IS 

COMPONENT mux4x1bit
	PORT(data3 : IN STD_LOGIC;
		 data2 : IN STD_LOGIC;
		 data1 : IN STD_LOGIC;
		 data0 : IN STD_LOGIC;
		 sel : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
		 result : OUT STD_LOGIC
	);
END COMPONENT;

COMPONENT mux2x32bit
	PORT(sel : IN STD_LOGIC;
		 data0x : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 data1x : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 result : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
	);
END COMPONENT;

COMPONENT mux2x16bit
	PORT(sel : IN STD_LOGIC;
		 data0x : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 data1x : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 result : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
	);
END COMPONENT;

COMPONENT mux4x8bit
	PORT(data0x : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		 data1x : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		 data2x : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		 data3x : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		 sel : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
		 result : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
	);
END COMPONENT;

COMPONENT mux3x32bit
	PORT(data0x : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 data1x : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 data2x : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 sel : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
		 result : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
	);
END COMPONENT;

SIGNAL	byte :  STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL	extension :  STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL	half :  STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL	MemData :  STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL	sel :  STD_LOGIC_VECTOR(1 DOWNTO 0);
SIGNAL	sign :  STD_LOGIC;
SIGNAL	signed :  STD_LOGIC;
SIGNAL	word :  STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_0 :  STD_LOGIC_VECTOR(0 TO 31);
SIGNAL	SYNTHESIZED_WIRE_1 :  STD_LOGIC_VECTOR(0 TO 31);
SIGNAL	SYNTHESIZED_WIRE_2 :  STD_LOGIC;


BEGIN 
SYNTHESIZED_WIRE_0 <= "00000000000000000000000000000000";
SYNTHESIZED_WIRE_1 <= "11111111111111111111111111111111";



b2v_inst : mux4x1bit
PORT MAP(data3 => MemData(31),
		 data2 => MemData(23),
		 data1 => MemData(15),
		 data0 => MemData(7),
		 sel => sel,
		 result => sign);


b2v_inst10 : mux2x32bit
PORT MAP(sel => signed,
		 data0x => SYNTHESIZED_WIRE_0,
		 data1x => SYNTHESIZED_WIRE_1,
		 result => extension);

word <= MemData;


byte(31 DOWNTO 8) <= extension(31 DOWNTO 8);


sel(1) <= dMemOffset(1);


half(31 DOWNTO 16) <= extension(31 DOWNTO 16);



b2v_inst4 : mux2x16bit
PORT MAP(sel => dMemOffset(1),
		 data0x => MemData(15 DOWNTO 0),
		 data1x => MemData(31 DOWNTO 16),
		 result => half(15 DOWNTO 0));


b2v_inst5 : mux4x8bit
PORT MAP(data0x => MemData(7 DOWNTO 0),
		 data1x => MemData(15 DOWNTO 8),
		 data2x => MemData(23 DOWNTO 16),
		 data3x => MemData(31 DOWNTO 24),
		 sel => dMemOffset,
		 result => byte(7 DOWNTO 0));




b2v_inst7 : mux3x32bit
PORT MAP(data0x => word,
		 data1x => byte,
		 data2x => half,
		 sel => MemSize,
		 result => MemDataM);


signed <= sign AND MemOp(0);


SYNTHESIZED_WIRE_2 <= NOT(MemSize(0));



sel(0) <= dMemOffset(0) OR SYNTHESIZED_WIRE_2;

MemData <= dMemReadData;

END bdf_type;