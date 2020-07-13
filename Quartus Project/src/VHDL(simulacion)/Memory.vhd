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
-- CREATED		"Wed Jun 26 19:07:21 2019"

LIBRARY ieee;
USE ieee.std_logic_1164.all; 

LIBRARY work;

ENTITY Memory IS 
	PORT
	(
		RegWrite_ME :  IN  STD_LOGIC;
		WbSource_ME :  IN  STD_LOGIC;
		clk :  IN  STD_LOGIC;
		reset :  IN  STD_LOGIC;
		flush :  IN  STD_LOGIC;
		stall :  IN  STD_LOGIC;
		AluRes_ME :  IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
		dMemReadData :  IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
		MemOp_ME :  IN  STD_LOGIC_VECTOR(1 DOWNTO 0);
		MemSize_ME :  IN  STD_LOGIC_VECTOR(1 DOWNTO 0);
		PC_ME :  IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
		Rd_ME :  IN  STD_LOGIC_VECTOR(4 DOWNTO 0);
		RegWrite_WB :  OUT  STD_LOGIC;
		WbSource_WB :  OUT  STD_LOGIC;
		AluRes_WB :  OUT  STD_LOGIC_VECTOR(31 DOWNTO 0);
		MemData_WB :  OUT  STD_LOGIC_VECTOR(31 DOWNTO 0);
		PC_WB :  OUT  STD_LOGIC_VECTOR(31 DOWNTO 0);
		Rd_WB :  OUT  STD_LOGIC_VECTOR(4 DOWNTO 0)
	);
END Memory;

ARCHITECTURE bdf_type OF Memory IS 

COMPONENT mepipelinereg
	PORT(RegWrite_ME : IN STD_LOGIC;
		 WbSource_ME : IN STD_LOGIC;
		 clk : IN STD_LOGIC;
		 reset : IN STD_LOGIC;
		 flush : IN STD_LOGIC;
		 stall : IN STD_LOGIC;
		 AluRes_ME : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 MemData_ME : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 PC_ME : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 Rd_ME : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
		 RegWrite_WB : OUT STD_LOGIC;
		 WbSource_WB : OUT STD_LOGIC;
		 AluRes_WB : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
		 MemData_WB : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
		 PC_WB : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
		 Rd_WB : OUT STD_LOGIC_VECTOR(4 DOWNTO 0)
	);
END COMPONENT;

COMPONENT loadblock
	PORT(dMemOffset : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
		 dMemReadData : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 MemOp : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
		 MemSize : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
		 MemDataM : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
	);
END COMPONENT;

SIGNAL	SYNTHESIZED_WIRE_0 :  STD_LOGIC_VECTOR(31 DOWNTO 0);


BEGIN 



b2v_inst1 : mepipelinereg
PORT MAP(RegWrite_ME => RegWrite_ME,
		 WbSource_ME => WbSource_ME,
		 clk => clk,
		 reset => reset,
		 flush => flush,
		 stall => stall,
		 AluRes_ME => AluRes_ME,
		 MemData_ME => SYNTHESIZED_WIRE_0,
		 PC_ME => PC_ME,
		 Rd_ME => Rd_ME,
		 RegWrite_WB => RegWrite_WB,
		 WbSource_WB => WbSource_WB,
		 AluRes_WB => AluRes_WB,
		 MemData_WB => MemData_WB,
		 PC_WB => PC_WB,
		 Rd_WB => Rd_WB);


b2v_LoadBlock : loadblock
PORT MAP(dMemOffset => AluRes_ME(1 DOWNTO 0),
		 dMemReadData => dMemReadData,
		 MemOp => MemOp_ME,
		 MemSize => MemSize_ME,
		 MemDataM => SYNTHESIZED_WIRE_0);


END bdf_type;