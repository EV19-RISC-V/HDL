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
-- CREATED		"Wed Jun 26 19:07:28 2019"

LIBRARY ieee;
USE ieee.std_logic_1164.all; 

LIBRARY work;

ENTITY Writeback IS 
	PORT
	(
		RegWrite_WB :  IN  STD_LOGIC;
		WbSrc_WB :  IN  STD_LOGIC;
		AluRes_WB :  IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
		MemData_WB :  IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
		Rd_WB :  IN  STD_LOGIC_VECTOR(4 DOWNTO 0);
		RegWrite :  OUT  STD_LOGIC;
		Rd :  OUT  STD_LOGIC_VECTOR(4 DOWNTO 0);
		Result :  OUT  STD_LOGIC_VECTOR(31 DOWNTO 0)
	);
END Writeback;

ARCHITECTURE bdf_type OF Writeback IS 

COMPONENT mux2x32bit
	PORT(sel : IN STD_LOGIC;
		 data0x : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 data1x : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 result : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
	);
END COMPONENT;



BEGIN 
RegWrite <= RegWrite_WB;
Rd <= Rd_WB;



b2v_inst : mux2x32bit
PORT MAP(sel => WbSrc_WB,
		 data0x => AluRes_WB,
		 data1x => MemData_WB,
		 result => Result);


END bdf_type;