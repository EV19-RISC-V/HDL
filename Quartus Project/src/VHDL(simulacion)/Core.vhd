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
-- CREATED		"Wed Jun 26 19:06:58 2019"

LIBRARY ieee;
USE ieee.std_logic_1164.all; 

LIBRARY work;

ENTITY Core IS 
	PORT
	(
		reset :  IN  STD_LOGIC;
		clock :  IN  STD_LOGIC;
		enablePredictor :  IN  STD_LOGIC;
		dataMemWaitReq :  IN  STD_LOGIC;
		instMemWaitReq :  IN  STD_LOGIC;
		dataMemReadData :  IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
		instMemReadData :  IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
		dataMemReadReq :  OUT  STD_LOGIC;
		dataMemWriteReq :  OUT  STD_LOGIC;
		instMemReadReq :  OUT  STD_LOGIC;
		dataMemAddress :  OUT  STD_LOGIC_VECTOR(31 DOWNTO 0);
		dataMemByteEnable :  OUT  STD_LOGIC_VECTOR(3 DOWNTO 0);
		dataMemWriteData :  OUT  STD_LOGIC_VECTOR(31 DOWNTO 0);
		instMemAddress :  OUT  STD_LOGIC_VECTOR(31 DOWNTO 0);
		instMemByteEnable :  OUT  STD_LOGIC_VECTOR(3 DOWNTO 0)
	);
END Core;

ARCHITECTURE bdf_type OF Core IS 

COMPONENT decode
	PORT(RegWrite_WB : IN STD_LOGIC;
		 Predict_DE : IN STD_LOGIC;
		 clk : IN STD_LOGIC;
		 reset : IN STD_LOGIC;
		 flush : IN STD_LOGIC;
		 stall : IN STD_LOGIC;
		 InstD : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 PC_DE : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 Rd_WB : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
		 Result_WB : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
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
		 nextPC_EX : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
		 PC_EX : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
		 Rd_EX : OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
		 Rs1_EX : OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
		 Rs1Data_EX : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
		 Rs2_EX : OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
		 Rs2Data_EX : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
		 State_EX : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
	);
END COMPONENT;

COMPONENT register32
	PORT(stall : IN STD_LOGIC;
		 clr : IN STD_LOGIC;
		 clk : IN STD_LOGIC;
		 d : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 q : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
	);
END COMPONENT;

COMPONENT execute
	PORT(RegWrite_EX : IN STD_LOGIC;
		 WbSource_EX : IN STD_LOGIC;
		 AluSrcA_EX : IN STD_LOGIC;
		 AluSrcB_EX : IN STD_LOGIC;
		 Predict_EX : IN STD_LOGIC;
		 clk : IN STD_LOGIC;
		 reset : IN STD_LOGIC;
		 flush : IN STD_LOGIC;
		 stall : IN STD_LOGIC;
		 loadHazard : IN STD_LOGIC;
		 AluOp_EX : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
		 BranchType_EX : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
		 CmpType_EX : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
		 ForwardA : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
		 ForwardB : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
		 Imm_EX : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 MemOp_EX : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
		 MemSize_EX : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
		 nextPC_EX : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 PC_EX : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 Rd_EX : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
		 Result_WB : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 Rs1_EX : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
		 Rs1Data_EX : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 Rs2_EX : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
		 Rs2Data_EX : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 State_EX : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		 updateBTB : OUT STD_LOGIC;
		 unconditional : OUT STD_LOGIC;
		 updateBHT : OUT STD_LOGIC;
		 taken : OUT STD_LOGIC;
		 updatePC : OUT STD_LOGIC;
		 longInstruction : OUT STD_LOGIC;
		 RegWrite_ME : OUT STD_LOGIC;
		 WbSource_ME : OUT STD_LOGIC;
		 dMemReadReq : OUT STD_LOGIC;
		 dMemWriteReq : OUT STD_LOGIC;
		 AluRes_ME : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
		 dMemAddress : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
		 dMemByteEnable : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
		 dMemWriteData : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
		 MemOp_ME : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
		 MemSize_ME : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
		 PC_ME : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
		 Rd_ME : OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
		 Rs1_ME : OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
		 Rs2_ME : OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
		 targetPC : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
	);
END COMPONENT;

COMPONENT fetch
	PORT(updateBTB : IN STD_LOGIC;
		 unconditional : IN STD_LOGIC;
		 updateBHT : IN STD_LOGIC;
		 taken : IN STD_LOGIC;
		 updatePC : IN STD_LOGIC;
		 iMemAck : IN STD_LOGIC;
		 clock : IN STD_LOGIC;
		 reset : IN STD_LOGIC;
		 flush : IN STD_LOGIC;
		 stall : IN STD_LOGIC;
		 enablePredictor : IN STD_LOGIC;
		 iMemReadData : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 PC_EX : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 State_EX : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		 targetPC : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 Predict_DE : OUT STD_LOGIC;
		 iMemReadReq : OUT STD_LOGIC;
		 iMemAddress : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
		 iMemByteEnable : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
		 Instruction : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
		 PC_DE : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
		 State_DE : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
	);
END COMPONENT;

COMPONENT forwardinghazardunit
	PORT(RegWrite_ME : IN STD_LOGIC;
		 RegWrite_WB : IN STD_LOGIC;
		 dMemAck : IN STD_LOGIC;
		 updatePC : IN STD_LOGIC;
		 AluSrcA : IN STD_LOGIC;
		 AluSrcB : IN STD_LOGIC;
		 dMemReadReq : IN STD_LOGIC;
		 dMemWriteReq : IN STD_LOGIC;
		 longInstruction : IN STD_LOGIC;
		 branchType_EX : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
		 EX_Rd : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
		 MemOp_EX : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
		 MemOp_ME : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
		 Rd_ME : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
		 Rd_WB : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
		 Rs1_DE : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
		 Rs1_EX : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
		 Rs2_DE : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
		 Rs2_EX : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
		 StallFE : OUT STD_LOGIC;
		 StallDE : OUT STD_LOGIC;
		 StallEX : OUT STD_LOGIC;
		 StallME : OUT STD_LOGIC;
		 FlushF : OUT STD_LOGIC;
		 FlushD : OUT STD_LOGIC;
		 FlushE : OUT STD_LOGIC;
		 FlushM : OUT STD_LOGIC;
		 loadHazard : OUT STD_LOGIC;
		 ForwardA : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
		 ForwardB : OUT STD_LOGIC_VECTOR(1 DOWNTO 0)
	);
END COMPONENT;

COMPONENT memory
	PORT(RegWrite_ME : IN STD_LOGIC;
		 WbSource_ME : IN STD_LOGIC;
		 clk : IN STD_LOGIC;
		 reset : IN STD_LOGIC;
		 flush : IN STD_LOGIC;
		 stall : IN STD_LOGIC;
		 AluRes_ME : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 dMemReadData : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 MemOp_ME : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
		 MemSize_ME : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
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

COMPONENT writeback
	PORT(RegWrite_WB : IN STD_LOGIC;
		 WbSrc_WB : IN STD_LOGIC;
		 AluRes_WB : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 MemData_WB : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 Rd_WB : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
		 RegWrite : OUT STD_LOGIC;
		 Rd : OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
		 Result : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
	);
END COMPONENT;

SIGNAL	AluSrcA :  STD_LOGIC;
SIGNAL	AluSrcB :  STD_LOGIC;
SIGNAL	BranchTarget :  STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL	branchType_EX :  STD_LOGIC_VECTOR(1 DOWNTO 0);
SIGNAL	clk :  STD_LOGIC;
SIGNAL	dMemAck :  STD_LOGIC;
SIGNAL	dMemAddress :  STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL	dMemByteEnable :  STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL	dMemReadData :  STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL	dMemReadDataReg :  STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL	dMemReadReq :  STD_LOGIC;
SIGNAL	dMemWriteData :  STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL	dMemWriteReq :  STD_LOGIC;
SIGNAL	FlushD :  STD_LOGIC;
SIGNAL	FlushE :  STD_LOGIC;
SIGNAL	FlushF :  STD_LOGIC;
SIGNAL	FlushM :  STD_LOGIC;
SIGNAL	ForwardA :  STD_LOGIC_VECTOR(1 DOWNTO 0);
SIGNAL	ForwardB :  STD_LOGIC_VECTOR(1 DOWNTO 0);
SIGNAL	iMemAck :  STD_LOGIC;
SIGNAL	iMemAddress :  STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL	iMemByteEnable :  STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL	iMemReadData :  STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL	iMemReadReq :  STD_LOGIC;
SIGNAL	inst :  STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL	loadHazard :  STD_LOGIC;
SIGNAL	longInstruction :  STD_LOGIC;
SIGNAL	MemOp_EX :  STD_LOGIC_VECTOR(1 DOWNTO 0);
SIGNAL	MemOp_ME :  STD_LOGIC_VECTOR(1 DOWNTO 0);
SIGNAL	Rd_EX :  STD_LOGIC_VECTOR(4 DOWNTO 0);
SIGNAL	Rd_ME :  STD_LOGIC_VECTOR(4 DOWNTO 0);
SIGNAL	Rd_WB :  STD_LOGIC_VECTOR(4 DOWNTO 0);
SIGNAL	RegWrite_ME :  STD_LOGIC;
SIGNAL	RegWrite_WB :  STD_LOGIC;
SIGNAL	Rs1_EX :  STD_LOGIC_VECTOR(4 DOWNTO 0);
SIGNAL	Rs2_EX :  STD_LOGIC_VECTOR(4 DOWNTO 0);
SIGNAL	StallDE :  STD_LOGIC;
SIGNAL	StallEX :  STD_LOGIC;
SIGNAL	StallFE :  STD_LOGIC;
SIGNAL	StallME :  STD_LOGIC;
SIGNAL	updateBHT :  STD_LOGIC;
SIGNAL	updateBTB :  STD_LOGIC;
SIGNAL	updatePC :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_0 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_1 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_2 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_3 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_4 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_5 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_6 :  STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_7 :  STD_LOGIC_VECTOR(4 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_39 :  STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_9 :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_10 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_11 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_12 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_13 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_14 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_15 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_16 :  STD_LOGIC_VECTOR(4 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_17 :  STD_LOGIC_VECTOR(2 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_18 :  STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_19 :  STD_LOGIC_VECTOR(1 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_20 :  STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_40 :  STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_23 :  STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_24 :  STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_41 :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_26 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_27 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_30 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_31 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_32 :  STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_33 :  STD_LOGIC_VECTOR(1 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_34 :  STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_35 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_36 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_37 :  STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_38 :  STD_LOGIC_VECTOR(31 DOWNTO 0);


BEGIN 
dataMemWriteReq <= SYNTHESIZED_WIRE_35;
SYNTHESIZED_WIRE_11 <= '0';
SYNTHESIZED_WIRE_12 <= '0';



SYNTHESIZED_WIRE_10 <= SYNTHESIZED_WIRE_0 AND SYNTHESIZED_WIRE_1;


SYNTHESIZED_WIRE_30 <= iMemReadReq AND SYNTHESIZED_WIRE_2;


SYNTHESIZED_WIRE_35 <= dMemWriteReq AND SYNTHESIZED_WIRE_3;


b2v_Decode : decode
PORT MAP(RegWrite_WB => SYNTHESIZED_WIRE_4,
		 Predict_DE => SYNTHESIZED_WIRE_5,
		 clk => clk,
		 reset => reset,
		 flush => FlushD,
		 stall => StallDE,
		 InstD => inst,
		 PC_DE => SYNTHESIZED_WIRE_6,
		 Rd_WB => SYNTHESIZED_WIRE_7,
		 Result_WB => SYNTHESIZED_WIRE_39,
		 State_DE => SYNTHESIZED_WIRE_9,
		 RegWrite_EX => SYNTHESIZED_WIRE_13,
		 WbSource_EX => SYNTHESIZED_WIRE_14,
		 AluSrcA_EX => AluSrcA,
		 AluSrcB_EX => AluSrcB,
		 Predict_EX => SYNTHESIZED_WIRE_15,
		 AluOp_EX => SYNTHESIZED_WIRE_16,
		 BranchType_EX => branchType_EX,
		 CompareType_EX => SYNTHESIZED_WIRE_17,
		 Immediate_EX => SYNTHESIZED_WIRE_18,
		 MemOp_EX => MemOp_EX,
		 MemSize_EX => SYNTHESIZED_WIRE_19,
		 nextPC_EX => SYNTHESIZED_WIRE_20,
		 PC_EX => SYNTHESIZED_WIRE_40,
		 Rd_EX => Rd_EX,
		 Rs1_EX => Rs1_EX,
		 Rs1Data_EX => SYNTHESIZED_WIRE_23,
		 Rs2_EX => Rs2_EX,
		 Rs2Data_EX => SYNTHESIZED_WIRE_24,
		 State_EX => SYNTHESIZED_WIRE_41);


PROCESS(clock)
BEGIN
IF (RISING_EDGE(clock)) THEN
	dMemAck <= SYNTHESIZED_WIRE_10;
END IF;
END PROCESS;


b2v_dMemDataReg : register32
PORT MAP(stall => SYNTHESIZED_WIRE_11,
		 clr => SYNTHESIZED_WIRE_12,
		 clk => clk,
		 d => dMemReadData,
		 q => dMemReadDataReg);


b2v_Execute : execute
PORT MAP(RegWrite_EX => SYNTHESIZED_WIRE_13,
		 WbSource_EX => SYNTHESIZED_WIRE_14,
		 AluSrcA_EX => AluSrcA,
		 AluSrcB_EX => AluSrcB,
		 Predict_EX => SYNTHESIZED_WIRE_15,
		 clk => clk,
		 reset => reset,
		 flush => FlushE,
		 stall => StallEX,
		 loadHazard => loadHazard,
		 AluOp_EX => SYNTHESIZED_WIRE_16,
		 BranchType_EX => branchType_EX,
		 CmpType_EX => SYNTHESIZED_WIRE_17,
		 ForwardA => ForwardA,
		 ForwardB => ForwardB,
		 Imm_EX => SYNTHESIZED_WIRE_18,
		 MemOp_EX => MemOp_EX,
		 MemSize_EX => SYNTHESIZED_WIRE_19,
		 nextPC_EX => SYNTHESIZED_WIRE_20,
		 PC_EX => SYNTHESIZED_WIRE_40,
		 Rd_EX => Rd_EX,
		 Result_WB => SYNTHESIZED_WIRE_39,
		 Rs1_EX => Rs1_EX,
		 Rs1Data_EX => SYNTHESIZED_WIRE_23,
		 Rs2_EX => Rs2_EX,
		 Rs2Data_EX => SYNTHESIZED_WIRE_24,
		 State_EX => SYNTHESIZED_WIRE_41,
		 updateBTB => updateBTB,
		 unconditional => SYNTHESIZED_WIRE_26,
		 updateBHT => updateBHT,
		 taken => SYNTHESIZED_WIRE_27,
		 updatePC => updatePC,
		 longInstruction => longInstruction,
		 RegWrite_ME => RegWrite_ME,
		 WbSource_ME => SYNTHESIZED_WIRE_31,
		 dMemReadReq => dMemReadReq,
		 dMemWriteReq => dMemWriteReq,
		 AluRes_ME => SYNTHESIZED_WIRE_32,
		 dMemAddress => dMemAddress,
		 dMemByteEnable => dMemByteEnable,
		 dMemWriteData => dMemWriteData,
		 MemOp_ME => MemOp_ME,
		 MemSize_ME => SYNTHESIZED_WIRE_33,
		 PC_ME => SYNTHESIZED_WIRE_34,
		 Rd_ME => Rd_ME,
		 targetPC => BranchTarget);


b2v_Fetch : fetch
PORT MAP(updateBTB => updateBTB,
		 unconditional => SYNTHESIZED_WIRE_26,
		 updateBHT => updateBHT,
		 taken => SYNTHESIZED_WIRE_27,
		 updatePC => updatePC,
		 iMemAck => iMemAck,
		 clock => clock,
		 reset => reset,
		 flush => FlushF,
		 stall => StallFE,
		 enablePredictor => enablePredictor,
		 iMemReadData => iMemReadData,
		 PC_EX => SYNTHESIZED_WIRE_40,
		 State_EX => SYNTHESIZED_WIRE_41,
		 targetPC => BranchTarget,
		 Predict_DE => SYNTHESIZED_WIRE_5,
		 iMemReadReq => iMemReadReq,
		 iMemAddress => iMemAddress,
		 iMemByteEnable => iMemByteEnable,
		 Instruction => inst,
		 PC_DE => SYNTHESIZED_WIRE_6,
		 State_DE => SYNTHESIZED_WIRE_9);


b2v_ForwardingHazardUnit : forwardinghazardunit
PORT MAP(RegWrite_ME => RegWrite_ME,
		 RegWrite_WB => RegWrite_WB,
		 dMemAck => dMemAck,
		 updatePC => updatePC,
		 AluSrcA => AluSrcA,
		 AluSrcB => AluSrcB,
		 dMemReadReq => dMemReadReq,
		 dMemWriteReq => dMemWriteReq,
		 longInstruction => longInstruction,
		 branchType_EX => branchType_EX,
		 EX_Rd => Rd_EX,
		 MemOp_EX => MemOp_EX,
		 MemOp_ME => MemOp_ME,
		 Rd_ME => Rd_ME,
		 Rd_WB => Rd_WB,
		 Rs1_DE => inst(19 DOWNTO 15),
		 Rs1_EX => Rs1_EX,
		 Rs2_DE => inst(24 DOWNTO 20),
		 Rs2_EX => Rs2_EX,
		 StallFE => StallFE,
		 StallDE => StallDE,
		 StallEX => StallEX,
		 StallME => StallME,
		 FlushF => FlushF,
		 FlushD => FlushD,
		 FlushE => FlushE,
		 FlushM => FlushM,
		 loadHazard => loadHazard,
		 ForwardA => ForwardA,
		 ForwardB => ForwardB);


PROCESS(clock)
BEGIN
IF (RISING_EDGE(clock)) THEN
	iMemAck <= SYNTHESIZED_WIRE_30;
END IF;
END PROCESS;




b2v_Memory : memory
PORT MAP(RegWrite_ME => RegWrite_ME,
		 WbSource_ME => SYNTHESIZED_WIRE_31,
		 clk => clk,
		 reset => reset,
		 flush => FlushM,
		 stall => StallME,
		 AluRes_ME => SYNTHESIZED_WIRE_32,
		 dMemReadData => dMemReadDataReg,
		 MemOp_ME => MemOp_ME,
		 MemSize_ME => SYNTHESIZED_WIRE_33,
		 PC_ME => SYNTHESIZED_WIRE_34,
		 Rd_ME => Rd_ME,
		 RegWrite_WB => RegWrite_WB,
		 WbSource_WB => SYNTHESIZED_WIRE_36,
		 AluRes_WB => SYNTHESIZED_WIRE_37,
		 MemData_WB => SYNTHESIZED_WIRE_38,
		 Rd_WB => Rd_WB);


SYNTHESIZED_WIRE_1 <= NOT(dataMemWaitReq);



SYNTHESIZED_WIRE_2 <= NOT(instMemWaitReq);



SYNTHESIZED_WIRE_3 <= NOT(loadHazard);



SYNTHESIZED_WIRE_0 <= SYNTHESIZED_WIRE_35 OR dMemReadReq;


b2v_Writeback : writeback
PORT MAP(RegWrite_WB => RegWrite_WB,
		 WbSrc_WB => SYNTHESIZED_WIRE_36,
		 AluRes_WB => SYNTHESIZED_WIRE_37,
		 MemData_WB => SYNTHESIZED_WIRE_38,
		 Rd_WB => Rd_WB,
		 RegWrite => SYNTHESIZED_WIRE_4,
		 Rd => SYNTHESIZED_WIRE_7,
		 Result => SYNTHESIZED_WIRE_39);

dataMemReadReq <= dMemReadReq;
clk <= clock;
iMemReadData <= instMemReadData;
dMemReadData <= dataMemReadData;
instMemReadReq <= iMemReadReq;
dataMemAddress <= dMemAddress;
dataMemByteEnable <= dMemByteEnable;
dataMemWriteData <= dMemWriteData;
instMemAddress <= iMemAddress;
instMemByteEnable <= iMemByteEnable;

END bdf_type;