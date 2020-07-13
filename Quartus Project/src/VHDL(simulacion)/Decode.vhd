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
-- CREATED		"Wed Jun 26 19:07:04 2019"

LIBRARY ieee;
USE ieee.std_logic_1164.all; 

LIBRARY work;

ENTITY Decode IS 
	PORT
	(
		RegWrite_WB :  IN  STD_LOGIC;
		reset :  IN  STD_LOGIC;
		flush :  IN  STD_LOGIC;
		stall :  IN  STD_LOGIC;
		clk :  IN  STD_LOGIC;
		Predict_DE :  IN  STD_LOGIC;
		InstD :  IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
		PC_DE :  IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
		Rd_WB :  IN  STD_LOGIC_VECTOR(4 DOWNTO 0);
		Result_WB :  IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
		State_DE :  IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
		AluSrcB_EX :  OUT  STD_LOGIC;
		RegWrite_EX :  OUT  STD_LOGIC;
		WbSource_EX :  OUT  STD_LOGIC;
		AluSrcA_EX :  OUT  STD_LOGIC;
		Predict_EX :  OUT  STD_LOGIC;
		AluOp_EX :  OUT  STD_LOGIC_VECTOR(4 DOWNTO 0);
		BranchType_EX :  OUT  STD_LOGIC_VECTOR(1 DOWNTO 0);
		CompareType_EX :  OUT  STD_LOGIC_VECTOR(2 DOWNTO 0);
		Immediate_EX :  OUT  STD_LOGIC_VECTOR(31 DOWNTO 0);
		MemOp_EX :  OUT  STD_LOGIC_VECTOR(1 DOWNTO 0);
		MemSize_EX :  OUT  STD_LOGIC_VECTOR(1 DOWNTO 0);
		nextPC_EX :  OUT  STD_LOGIC_VECTOR(31 DOWNTO 0);
		PC_EX :  OUT  STD_LOGIC_VECTOR(31 DOWNTO 0);
		Rd_EX :  OUT  STD_LOGIC_VECTOR(4 DOWNTO 0);
		Rs1_EX :  OUT  STD_LOGIC_VECTOR(4 DOWNTO 0);
		Rs1Data_EX :  OUT  STD_LOGIC_VECTOR(31 DOWNTO 0);
		Rs2_EX :  OUT  STD_LOGIC_VECTOR(4 DOWNTO 0);
		Rs2Data_EX :  OUT  STD_LOGIC_VECTOR(31 DOWNTO 0);
		State_EX :  OUT  STD_LOGIC_VECTOR(7 DOWNTO 0)
	);
END Decode;

ARCHITECTURE bdf_type OF Decode IS 

COMPONENT controlstore
	PORT(bubble : IN STD_LOGIC;
		 intAddr : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
		 RegWrite : OUT STD_LOGIC;
		 WbSource : OUT STD_LOGIC;
		 AluSourceA : OUT STD_LOGIC;
		 AluSourceB : OUT STD_LOGIC;
		 AluOp : OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
		 BranchType : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
		 CompareType : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
		 MemOp : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
		 MemSize : OUT STD_LOGIC_VECTOR(1 DOWNTO 0)
	);
END COMPONENT;

COMPONENT instdecoder
	PORT(instruction : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 invalidInstruction : OUT STD_LOGIC;
		 index : OUT STD_LOGIC_VECTOR(5 DOWNTO 0)
	);
END COMPONENT;

COMPONENT depipelinereg
	PORT(RegWrite_DE : IN STD_LOGIC;
		 WbSource_DE : IN STD_LOGIC;
		 AluSrcA_DE : IN STD_LOGIC;
		 AluSrcB_DE : IN STD_LOGIC;
		 Predict_DE : IN STD_LOGIC;
		 clk : IN STD_LOGIC;
		 reset : IN STD_LOGIC;
		 flush : IN STD_LOGIC;
		 stall : IN STD_LOGIC;
		 AluOp_DE : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
		 BranchType_DE : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
		 CompareType_DE : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
		 Immediate_DE : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 MemOp_DE : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
		 MemSize_DE : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
		 PC_DE : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 Rd_DE : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
		 Rs1_DE : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
		 Rs1Data_DE : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 Rs2_DE : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
		 Rs2Data_DE : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 State_DE : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		 RegWrite_EX : OUT STD_LOGIC;
		 WbSource_EX : OUT STD_LOGIC;
		 AluSrcA_EX : OUT STD_LOGIC;
		 AluSrcB_EX : OUT STD_LOGIC;
		 Predict_EX : OUT STD_LOGIC;
		 AluOp_EX : OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
		 BranchType_EX : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
		 CompareType_EX : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
		 Immediate_EX : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
		 MemOp_EX : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
		 MemSize_EX : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
		 PC_EX : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
		 Rd_EX : OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
		 Rs1_EX : OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
		 Rs1Data_EX : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
		 Rs2_EX : OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
		 Rs2Data_EX : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
		 State_EX : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
	);
END COMPONENT;

COMPONENT immgenerator
	PORT(instruction : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 immediate : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
	);
END COMPONENT;

COMPONENT mux2x5bit
	PORT(sel : IN STD_LOGIC;
		 data0x : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
		 data1x : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
		 result : OUT STD_LOGIC_VECTOR(4 DOWNTO 0)
	);
END COMPONENT;

COMPONENT registerfile
	PORT(WE : IN STD_LOGIC;
		 CLK : IN STD_LOGIC;
		 A1 : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
		 A2 : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
		 A3 : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
		 WD3 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 RD1 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
		 RD2 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
	);
END COMPONENT;

SIGNAL	func3 :  STD_LOGIC_VECTOR(2 DOWNTO 0);
SIGNAL	func7 :  STD_LOGIC_VECTOR(6 DOWNTO 0);
SIGNAL	opcode :  STD_LOGIC_VECTOR(6 DOWNTO 0);
SIGNAL	predict :  STD_LOGIC;
SIGNAL	RdDE :  STD_LOGIC_VECTOR(4 DOWNTO 0);
SIGNAL	Rs1DE :  STD_LOGIC_VECTOR(4 DOWNTO 0);
SIGNAL	Rs1EX :  STD_LOGIC_VECTOR(4 DOWNTO 0);
SIGNAL	Rs2DE :  STD_LOGIC_VECTOR(4 DOWNTO 0);
SIGNAL	Rs2EX :  STD_LOGIC_VECTOR(4 DOWNTO 0);
SIGNAL	state :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_0 :  STD_LOGIC_VECTOR(5 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_1 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_2 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_3 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_4 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_5 :  STD_LOGIC_VECTOR(4 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_6 :  STD_LOGIC_VECTOR(1 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_7 :  STD_LOGIC_VECTOR(2 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_8 :  STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_9 :  STD_LOGIC_VECTOR(1 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_10 :  STD_LOGIC_VECTOR(1 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_11 :  STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_12 :  STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_13 :  STD_LOGIC_VECTOR(4 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_14 :  STD_LOGIC_VECTOR(4 DOWNTO 0);


BEGIN 
nextPC_EX <= PC_DE;



b2v_ControlStore : controlstore
PORT MAP(bubble => flush,
		 intAddr => SYNTHESIZED_WIRE_0,
		 RegWrite => SYNTHESIZED_WIRE_1,
		 WbSource => SYNTHESIZED_WIRE_2,
		 AluSourceA => SYNTHESIZED_WIRE_3,
		 AluSourceB => SYNTHESIZED_WIRE_4,
		 AluOp => SYNTHESIZED_WIRE_5,
		 BranchType => SYNTHESIZED_WIRE_6,
		 CompareType => SYNTHESIZED_WIRE_7,
		 MemOp => SYNTHESIZED_WIRE_9,
		 MemSize => SYNTHESIZED_WIRE_10);


b2v_DecodeInst : instdecoder
PORT MAP(instruction => InstD,
		 index => SYNTHESIZED_WIRE_0);


b2v_DeEx : depipelinereg
PORT MAP(RegWrite_DE => SYNTHESIZED_WIRE_1,
		 WbSource_DE => SYNTHESIZED_WIRE_2,
		 AluSrcA_DE => SYNTHESIZED_WIRE_3,
		 AluSrcB_DE => SYNTHESIZED_WIRE_4,
		 Predict_DE => predict,
		 clk => clk,
		 reset => reset,
		 flush => flush,
		 stall => stall,
		 AluOp_DE => SYNTHESIZED_WIRE_5,
		 BranchType_DE => SYNTHESIZED_WIRE_6,
		 CompareType_DE => SYNTHESIZED_WIRE_7,
		 Immediate_DE => SYNTHESIZED_WIRE_8,
		 MemOp_DE => SYNTHESIZED_WIRE_9,
		 MemSize_DE => SYNTHESIZED_WIRE_10,
		 PC_DE => PC_DE,
		 Rd_DE => RdDE,
		 Rs1_DE => Rs1DE,
		 Rs1Data_DE => SYNTHESIZED_WIRE_11,
		 Rs2_DE => Rs2DE,
		 Rs2Data_DE => SYNTHESIZED_WIRE_12,
		 State_DE => state,
		 RegWrite_EX => RegWrite_EX,
		 WbSource_EX => WbSource_EX,
		 AluSrcA_EX => AluSrcA_EX,
		 AluSrcB_EX => AluSrcB_EX,
		 AluOp_EX => AluOp_EX,
		 BranchType_EX => BranchType_EX,
		 CompareType_EX => CompareType_EX,
		 Immediate_EX => Immediate_EX,
		 MemOp_EX => MemOp_EX,
		 MemSize_EX => MemSize_EX,
		 PC_EX => PC_EX,
		 Rd_EX => Rd_EX,
		 Rs1_EX => Rs1EX,
		 Rs1Data_EX => Rs1Data_EX,
		 Rs2_EX => Rs2EX,
		 Rs2Data_EX => Rs2Data_EX,
		 State_EX => State_EX);


b2v_inst : immgenerator
PORT MAP(instruction => InstD,
		 immediate => SYNTHESIZED_WIRE_8);


b2v_MuxA1 : mux2x5bit
PORT MAP(sel => stall,
		 data0x => Rs1DE,
		 data1x => Rs1EX,
		 result => SYNTHESIZED_WIRE_13);


b2v_MuxA2 : mux2x5bit
PORT MAP(sel => stall,
		 data0x => Rs2DE,
		 data1x => Rs2EX,
		 result => SYNTHESIZED_WIRE_14);


b2v_RegisterFile : registerfile
PORT MAP(WE => RegWrite_WB,
		 CLK => clk,
		 A1 => SYNTHESIZED_WIRE_13,
		 A2 => SYNTHESIZED_WIRE_14,
		 A3 => Rd_WB,
		 WD3 => Result_WB,
		 RD1 => SYNTHESIZED_WIRE_11,
		 RD2 => SYNTHESIZED_WIRE_12);

Rs1DE <= InstD(19 DOWNTO 15);


Rs2DE <= InstD(24 DOWNTO 20);


RdDE <= InstD(11 DOWNTO 7);





predict <= Predict_DE;
state <= State_DE;
Predict_EX <= predict;
Rs1_EX <= Rs1EX;
Rs2_EX <= Rs2EX;

END bdf_type;