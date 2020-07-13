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
-- CREATED		"Wed Jun 26 19:07:08 2019"

LIBRARY ieee;
USE ieee.std_logic_1164.all; 

LIBRARY work;

ENTITY Execute IS 
	PORT
	(
		RegWrite_EX :  IN  STD_LOGIC;
		WbSource_EX :  IN  STD_LOGIC;
		AluSrcA_EX :  IN  STD_LOGIC;
		AluSrcB_EX :  IN  STD_LOGIC;
		clk :  IN  STD_LOGIC;
		reset :  IN  STD_LOGIC;
		flush :  IN  STD_LOGIC;
		stall :  IN  STD_LOGIC;
		loadHazard :  IN  STD_LOGIC;
		Predict_EX :  IN  STD_LOGIC;
		AluOp_EX :  IN  STD_LOGIC_VECTOR(4 DOWNTO 0);
		BranchType_EX :  IN  STD_LOGIC_VECTOR(1 DOWNTO 0);
		CmpType_EX :  IN  STD_LOGIC_VECTOR(2 DOWNTO 0);
		ForwardA :  IN  STD_LOGIC_VECTOR(1 DOWNTO 0);
		ForwardB :  IN  STD_LOGIC_VECTOR(1 DOWNTO 0);
		Imm_EX :  IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
		MemOp_EX :  IN  STD_LOGIC_VECTOR(1 DOWNTO 0);
		MemSize_EX :  IN  STD_LOGIC_VECTOR(1 DOWNTO 0);
		nextPC_EX :  IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
		PC_EX :  IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
		Rd_EX :  IN  STD_LOGIC_VECTOR(4 DOWNTO 0);
		Result_WB :  IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
		Rs1_EX :  IN  STD_LOGIC_VECTOR(4 DOWNTO 0);
		Rs1Data_EX :  IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
		Rs2_EX :  IN  STD_LOGIC_VECTOR(4 DOWNTO 0);
		Rs2Data_EX :  IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
		State_EX :  IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
		RegWrite_ME :  OUT  STD_LOGIC;
		WbSource_ME :  OUT  STD_LOGIC;
		dMemReadReq :  OUT  STD_LOGIC;
		dMemWriteReq :  OUT  STD_LOGIC;
		unconditional :  OUT  STD_LOGIC;
		taken :  OUT  STD_LOGIC;
		updateBTB :  OUT  STD_LOGIC;
		updateBHT :  OUT  STD_LOGIC;
		updatePC :  OUT  STD_LOGIC;
		longInstruction :  OUT  STD_LOGIC;
		AluRes_ME :  OUT  STD_LOGIC_VECTOR(31 DOWNTO 0);
		dMemAddress :  OUT  STD_LOGIC_VECTOR(31 DOWNTO 0);
		dMemByteEnable :  OUT  STD_LOGIC_VECTOR(3 DOWNTO 0);
		dMemWriteData :  OUT  STD_LOGIC_VECTOR(31 DOWNTO 0);
		MemOp_ME :  OUT  STD_LOGIC_VECTOR(1 DOWNTO 0);
		MemSize_ME :  OUT  STD_LOGIC_VECTOR(1 DOWNTO 0);
		PC_ME :  OUT  STD_LOGIC_VECTOR(31 DOWNTO 0);
		Rd_ME :  OUT  STD_LOGIC_VECTOR(4 DOWNTO 0);
		Rs1_ME :  OUT  STD_LOGIC_VECTOR(4 DOWNTO 0);
		Rs2_ME :  OUT  STD_LOGIC_VECTOR(4 DOWNTO 0);
		targetPC :  OUT  STD_LOGIC_VECTOR(31 DOWNTO 0)
	);
END Execute;

ARCHITECTURE bdf_type OF Execute IS 

COMPONENT mux2x32bit
	PORT(sel : IN STD_LOGIC;
		 data0x : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 data1x : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 result : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
	);
END COMPONENT;

COMPONENT executealu
	PORT(Clk : IN STD_LOGIC;
		 A : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 ALU_Ctrl : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
		 B : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 LongInst : OUT STD_LOGIC;
		 RES : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
	);
END COMPONENT;

COMPONENT mux2x4bit
	PORT(sel : IN STD_LOGIC;
		 data0x : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		 data1x : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		 result : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
	);
END COMPONENT;

COMPONENT byteenableblock
	PORT(dMemAddress : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
		 memOp : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
		 memSize : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
		 byteEnable : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
	);
END COMPONENT;

COMPONENT executebranch
	PORT(predict : IN STD_LOGIC;
		 BranchType : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
		 CmpType : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
		 Imm : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 nextPC : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 PC : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 Rs1 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 Rs2 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 updateBTB : OUT STD_LOGIC;
		 unconditional : OUT STD_LOGIC;
		 updateBHT : OUT STD_LOGIC;
		 taken : OUT STD_LOGIC;
		 updatePC : OUT STD_LOGIC;
		 cancelJump : OUT STD_LOGIC;
		 BranchTarget : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
	);
END COMPONENT;

COMPONENT expipelinereg
	PORT(RegWrite_EX : IN STD_LOGIC;
		 WbSource_EX : IN STD_LOGIC;
		 dMemReadReq_EX : IN STD_LOGIC;
		 dMemWriteReq_EX : IN STD_LOGIC;
		 clk : IN STD_LOGIC;
		 reset : IN STD_LOGIC;
		 flush : IN STD_LOGIC;
		 stall : IN STD_LOGIC;
		 AluRes_EX : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 dMemAddress_EX : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 dMemByteEnable_EX : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		 dMemWriteData_EX : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 MemOp_EX : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
		 MemSize_EX : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
		 PC_EX : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 Rd_EX : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
		 Rs1_EX : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
		 Rs2_EX : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
		 RegWrite_ME : OUT STD_LOGIC;
		 WbSource_ME : OUT STD_LOGIC;
		 dMemReadReq_ME : OUT STD_LOGIC;
		 dMemWriteReq_ME : OUT STD_LOGIC;
		 AluRes_ME : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
		 dMemAddress_ME : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
		 dMemByteEnable_ME : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
		 dMemWriteData_ME : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
		 MemOp_ME : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
		 MemSize_ME : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
		 PC_ME : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
		 Rd_ME : OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
		 Rs1_ME : OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
		 Rs2_ME : OUT STD_LOGIC_VECTOR(4 DOWNTO 0)
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

COMPONENT mux2x1bit
	PORT(data1 : IN STD_LOGIC;
		 data0 : IN STD_LOGIC;
		 sel : IN STD_LOGIC;
		 result : OUT STD_LOGIC
	);
END COMPONENT;

COMPONENT shiftblock
	PORT(dMemAddress : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
		 memOp : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
		 memSize : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
		 storeDataIn : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 missalignFlag : OUT STD_LOGIC;
		 storeDataOut : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
	);
END COMPONENT;

SIGNAL	AluOp :  STD_LOGIC_VECTOR(4 DOWNTO 0);
SIGNAL	AluResEX :  STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL	AluResME :  STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL	AluSrcA :  STD_LOGIC;
SIGNAL	AluSrcB :  STD_LOGIC;
SIGNAL	BranchType :  STD_LOGIC_VECTOR(1 DOWNTO 0);
SIGNAL	longInst :  STD_LOGIC;
SIGNAL	MemOp :  STD_LOGIC_VECTOR(1 DOWNTO 0);
SIGNAL	MemSize :  STD_LOGIC_VECTOR(1 DOWNTO 0);
SIGNAL	nextPC :  STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL	predict :  STD_LOGIC;
SIGNAL	RdEX :  STD_LOGIC_VECTOR(4 DOWNTO 0);
SIGNAL	RegWrite :  STD_LOGIC;
SIGNAL	Rs1EX :  STD_LOGIC_VECTOR(4 DOWNTO 0);
SIGNAL	Rs2EX :  STD_LOGIC_VECTOR(4 DOWNTO 0);
SIGNAL	state :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL	WbSource :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_0 :  STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_1 :  STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_2 :  STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_32 :  STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_33 :  STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_5 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_34 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_8 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_9 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_10 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_11 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_12 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_13 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_14 :  STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_35 :  STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_16 :  STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_36 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_37 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_38 :  STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_23 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_24 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_25 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_29 :  STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_30 :  STD_LOGIC;


BEGIN 



b2v_addressMux : mux2x32bit
PORT MAP(sel => stall,
		 data0x => AluResEX,
		 data1x => SYNTHESIZED_WIRE_0,
		 result => dMemAddress);


b2v_Alu : executealu
PORT MAP(Clk => clk,
		 A => SYNTHESIZED_WIRE_1,
		 ALU_Ctrl => AluOp,
		 B => SYNTHESIZED_WIRE_2,
		 LongInst => longInst,
		 RES => AluResEX);


b2v_AluSrcMuxA : mux2x32bit
PORT MAP(sel => AluSrcA,
		 data0x => PC_EX,
		 data1x => SYNTHESIZED_WIRE_32,
		 result => SYNTHESIZED_WIRE_1);


b2v_AluSrcMuxB : mux2x32bit
PORT MAP(sel => AluSrcB,
		 data0x => Imm_EX,
		 data1x => SYNTHESIZED_WIRE_33,
		 result => SYNTHESIZED_WIRE_2);


SYNTHESIZED_WIRE_36 <= SYNTHESIZED_WIRE_5 AND SYNTHESIZED_WIRE_34;


SYNTHESIZED_WIRE_37 <= SYNTHESIZED_WIRE_34 AND SYNTHESIZED_WIRE_8;


SYNTHESIZED_WIRE_8 <= MemOp(0) AND MemOp(1);


taken <= SYNTHESIZED_WIRE_9 AND SYNTHESIZED_WIRE_10;


SYNTHESIZED_WIRE_10 <= SYNTHESIZED_WIRE_11 AND SYNTHESIZED_WIRE_12;


b2v_BranchTargetMux : mux2x32bit
PORT MAP(sel => SYNTHESIZED_WIRE_13,
		 data0x => AluResEX,
		 data1x => SYNTHESIZED_WIRE_14,
		 result => targetPC);


b2v_byreEnableMux : mux2x4bit
PORT MAP(sel => stall,
		 data0x => SYNTHESIZED_WIRE_35,
		 data1x => SYNTHESIZED_WIRE_16,
		 result => dMemByteEnable);


b2v_ByteEnableBlock : byteenableblock
PORT MAP(dMemAddress => AluResEX(1 DOWNTO 0),
		 memOp => MemOp,
		 memSize => MemSize,
		 byteEnable => SYNTHESIZED_WIRE_35);


b2v_ExecuteBranch : executebranch
PORT MAP(predict => predict,
		 BranchType => BranchType,
		 CmpType => CmpType_EX,
		 Imm => Imm_EX,
		 nextPC => nextPC,
		 PC => PC_EX,
		 Rs1 => SYNTHESIZED_WIRE_32,
		 Rs2 => SYNTHESIZED_WIRE_33,
		 updateBTB => updateBTB,
		 unconditional => unconditional,
		 updateBHT => updateBHT,
		 taken => SYNTHESIZED_WIRE_9,
		 updatePC => updatePC,
		 cancelJump => SYNTHESIZED_WIRE_23,
		 BranchTarget => SYNTHESIZED_WIRE_14);


b2v_ExPipelineReg : expipelinereg
PORT MAP(RegWrite_EX => RegWrite,
		 WbSource_EX => WbSource,
		 dMemReadReq_EX => SYNTHESIZED_WIRE_36,
		 dMemWriteReq_EX => SYNTHESIZED_WIRE_37,
		 clk => clk,
		 reset => reset,
		 flush => flush,
		 stall => stall,
		 AluRes_EX => AluResEX,
		 dMemAddress_EX => AluResEX,
		 dMemByteEnable_EX => SYNTHESIZED_WIRE_35,
		 dMemWriteData_EX => SYNTHESIZED_WIRE_38,
		 MemOp_EX => MemOp,
		 MemSize_EX => MemSize,
		 PC_EX => PC_EX,
		 Rd_EX => RdEX,
		 Rs1_EX => Rs1EX,
		 Rs2_EX => Rs2EX,
		 RegWrite_ME => RegWrite_ME,
		 WbSource_ME => WbSource_ME,
		 dMemReadReq_ME => SYNTHESIZED_WIRE_25,
		 dMemWriteReq_ME => SYNTHESIZED_WIRE_30,
		 AluRes_ME => AluResME,
		 dMemAddress_ME => SYNTHESIZED_WIRE_0,
		 dMemByteEnable_ME => SYNTHESIZED_WIRE_16,
		 dMemWriteData_ME => SYNTHESIZED_WIRE_29,
		 MemOp_ME => MemOp_ME,
		 MemSize_ME => MemSize_ME,
		 PC_ME => PC_ME,
		 Rd_ME => Rd_ME,
		 Rs1_ME => Rs1_ME,
		 Rs2_ME => Rs2_ME);


b2v_ForwardingMuxA : mux3x32bit
PORT MAP(data0x => Result_WB,
		 data1x => AluResME,
		 data2x => Rs1Data_EX,
		 sel => ForwardA,
		 result => SYNTHESIZED_WIRE_32);


b2v_ForwardingMuxB : mux3x32bit
PORT MAP(data0x => Result_WB,
		 data1x => AluResME,
		 data2x => Rs2Data_EX,
		 sel => ForwardB,
		 result => SYNTHESIZED_WIRE_33);


SYNTHESIZED_WIRE_13 <= NOT(SYNTHESIZED_WIRE_23);



SYNTHESIZED_WIRE_34 <= NOT(SYNTHESIZED_WIRE_24);



SYNTHESIZED_WIRE_11 <= NOT(stall);



SYNTHESIZED_WIRE_12 <= NOT(loadHazard);



b2v_readMux : mux2x1bit
PORT MAP(data1 => SYNTHESIZED_WIRE_25,
		 data0 => SYNTHESIZED_WIRE_36,
		 sel => stall,
		 result => dMemReadReq);


b2v_ShiftStoreData : shiftblock
PORT MAP(dMemAddress => AluResEX(1 DOWNTO 0),
		 memOp => MemOp,
		 memSize => MemSize,
		 storeDataIn => SYNTHESIZED_WIRE_33,
		 missalignFlag => SYNTHESIZED_WIRE_24,
		 storeDataOut => SYNTHESIZED_WIRE_38);


b2v_writeDataMux : mux2x32bit
PORT MAP(sel => stall,
		 data0x => SYNTHESIZED_WIRE_38,
		 data1x => SYNTHESIZED_WIRE_29,
		 result => dMemWriteData);


b2v_writeMux : mux2x1bit
PORT MAP(data1 => SYNTHESIZED_WIRE_30,
		 data0 => SYNTHESIZED_WIRE_37,
		 sel => stall,
		 result => dMemWriteReq);


SYNTHESIZED_WIRE_5 <= MemOp(0) XOR MemOp(1);

RegWrite <= RegWrite_EX;
WbSource <= WbSource_EX;
MemOp <= MemOp_EX;
AluSrcA <= AluSrcA_EX;
AluOp <= AluOp_EX;
AluSrcB <= AluSrcB_EX;
MemSize <= MemSize_EX;
RdEX <= Rd_EX;
Rs1EX <= Rs1_EX;
Rs2EX <= Rs2_EX;
predict <= Predict_EX;
BranchType <= BranchType_EX;
nextPC <= nextPC_EX;
longInstruction <= longInst;
AluRes_ME <= AluResME;

END bdf_type;