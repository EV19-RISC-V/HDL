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
-- CREATED		"Wed Jun 26 19:07:01 2019"

LIBRARY ieee;
USE ieee.std_logic_1164.all; 

LIBRARY work;

ENTITY Fetch IS 
	PORT
	(
		iMemAck :  IN  STD_LOGIC;
		clock :  IN  STD_LOGIC;
		reset :  IN  STD_LOGIC;
		flush :  IN  STD_LOGIC;
		stall :  IN  STD_LOGIC;
		unconditional :  IN  STD_LOGIC;
		taken :  IN  STD_LOGIC;
		updateBTB :  IN  STD_LOGIC;
		updateBHT :  IN  STD_LOGIC;
		updatePC :  IN  STD_LOGIC;
		enablePredictor :  IN  STD_LOGIC;
		iMemReadData :  IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
		PC_EX :  IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
		State_EX :  IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
		targetPC :  IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
		iMemReadReq :  OUT  STD_LOGIC;
		Predict_DE :  OUT  STD_LOGIC;
		iMemAddress :  OUT  STD_LOGIC_VECTOR(31 DOWNTO 0);
		iMemByteEnable :  OUT  STD_LOGIC_VECTOR(3 DOWNTO 0);
		Instruction :  OUT  STD_LOGIC_VECTOR(31 DOWNTO 0);
		PC_DE :  OUT  STD_LOGIC_VECTOR(31 DOWNTO 0);
		State_DE :  OUT  STD_LOGIC_VECTOR(7 DOWNTO 0)
	);
END Fetch;

ARCHITECTURE bdf_type OF Fetch IS 

COMPONENT bht
GENERIC (COLS : INTEGER;
			NBITS : INTEGER;
			ROWS : INTEGER;
			SIZE : INTEGER
			);
	PORT(clock : IN STD_LOGIC;
		 reset : IN STD_LOGIC;
		 update : IN STD_LOGIC;
		 taken : IN STD_LOGIC;
		 execPC : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 execState : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		 fetchPC : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 take : OUT STD_LOGIC;
		 nextStateOut : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
	);
END COMPONENT;

COMPONENT btb
GENERIC (SIZE : INTEGER
			);
	PORT(clk : IN STD_LOGIC;
		 reset : IN STD_LOGIC;
		 update : IN STD_LOGIC;
		 uncondIn : IN STD_LOGIC;
		 nextPC : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 sourcePC : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 targetPC : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 hit : OUT STD_LOGIC;
		 uncondOut : OUT STD_LOGIC;
		 predictedPC : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
	);
END COMPONENT;

COMPONENT mux2x32bit
	PORT(sel : IN STD_LOGIC;
		 data0x : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 data1x : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
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

COMPONENT genpipelinereg
GENERIC (RESET_ADDRESS : STD_LOGIC_VECTOR(31 DOWNTO 0)
			);
	PORT(predict_GEN : IN STD_LOGIC;
		 clk : IN STD_LOGIC;
		 reset : IN STD_LOGIC;
		 flush : IN STD_LOGIC;
		 stall : IN STD_LOGIC;
		 PC_GEN : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 State_GEN : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		 predict_FE : OUT STD_LOGIC;
		 PC_FE : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
		 State_FE : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
	);
END COMPONENT;

COMPONENT mux4x32bit
	PORT(data0x : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 data1x : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 data2x : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 data3x : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 sel : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
		 result : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
	);
END COMPONENT;

COMPONENT fepipelinereg
	PORT(predict_FE : IN STD_LOGIC;
		 clk : IN STD_LOGIC;
		 reset : IN STD_LOGIC;
		 flush : IN STD_LOGIC;
		 stall : IN STD_LOGIC;
		 instruction_FE : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 PC_FE : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 State_FE : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		 predict_DE : OUT STD_LOGIC;
		 instruction_DE : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
		 PC_DE : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
		 State_DE : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
	);
END COMPONENT;

COMPONENT plus4
	PORT(dataa : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 result : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
	);
END COMPONENT;

COMPONENT nop
	PORT(		 result : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
	);
END COMPONENT;

COMPONENT resetpc
	PORT(		 result : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
	);
END COMPONENT;

SIGNAL	cancelFe :  STD_LOGIC;
SIGNAL	clk :  STD_LOGIC;
SIGNAL	instructionReady :  STD_LOGIC;
SIGNAL	MuxSel :  STD_LOGIC_VECTOR(1 DOWNTO 0);
SIGNAL	nextCancelFe :  STD_LOGIC;
SIGNAL	nextPC :  STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL	PC :  STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL	prediction :  STD_LOGIC;
SIGNAL	readData :  STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL	State :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_0 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_1 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_2 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_3 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_4 :  STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_5 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_6 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_7 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_8 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_9 :  STD_LOGIC_VECTOR(0 TO 7);
SIGNAL	SYNTHESIZED_WIRE_10 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_11 :  STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_12 :  STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_13 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_14 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_15 :  STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_16 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_17 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_18 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_31 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_20 :  STD_LOGIC;
SIGNAL	DFF_inst5 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_21 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_23 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_24 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_25 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_26 :  STD_LOGIC;
SIGNAL	DFF_inst4 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_27 :  STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_28 :  STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_29 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_30 :  STD_LOGIC;


BEGIN 
iMemByteEnable <= "1111";
SYNTHESIZED_WIRE_6 <= '0';
SYNTHESIZED_WIRE_7 <= '0';
SYNTHESIZED_WIRE_8 <= '0';
SYNTHESIZED_WIRE_9 <= "00000000";
SYNTHESIZED_WIRE_14 <= '0';



SYNTHESIZED_WIRE_5 <= SYNTHESIZED_WIRE_0 AND SYNTHESIZED_WIRE_1;


SYNTHESIZED_WIRE_16 <= SYNTHESIZED_WIRE_2 AND iMemAck;


b2v_BHT : bht
GENERIC MAP(COLS => 4,
			NBITS => 2,
			ROWS => 64,
			SIZE => 128
			)
PORT MAP(clock => clk,
		 reset => reset,
		 update => updateBHT,
		 taken => taken,
		 execPC => PC_EX,
		 execState => State_EX,
		 fetchPC => PC,
		 take => SYNTHESIZED_WIRE_29,
		 nextStateOut => State);


b2v_BTB : btb
GENERIC MAP(SIZE => 128
			)
PORT MAP(clk => clk,
		 reset => reset,
		 update => updateBTB,
		 uncondIn => unconditional,
		 nextPC => PC,
		 sourcePC => PC_EX,
		 targetPC => targetPC,
		 hit => SYNTHESIZED_WIRE_0,
		 uncondOut => SYNTHESIZED_WIRE_30,
		 predictedPC => SYNTHESIZED_WIRE_12);


b2v_BubbleMux : mux2x32bit
PORT MAP(sel => SYNTHESIZED_WIRE_3,
		 data0x => readData,
		 data1x => SYNTHESIZED_WIRE_4,
		 result => SYNTHESIZED_WIRE_15);


PROCESS(clk)
BEGIN
IF (RISING_EDGE(clk)) THEN
	cancelFe <= nextCancelFe;
END IF;
END PROCESS;


b2v_enablePredictMux : mux2x1bit
PORT MAP(data1 => SYNTHESIZED_WIRE_5,
		 data0 => SYNTHESIZED_WIRE_6,
		 sel => enablePredictor,
		 result => prediction);


b2v_GEN_FE : genpipelinereg
GENERIC MAP(RESET_ADDRESS => "00000000000000000000000000000000"
			)
PORT MAP(predict_GEN => prediction,
		 clk => clk,
		 reset => reset,
		 flush => SYNTHESIZED_WIRE_7,
		 stall => SYNTHESIZED_WIRE_8,
		 PC_GEN => nextPC,
		 State_GEN => SYNTHESIZED_WIRE_9,
		 predict_FE => SYNTHESIZED_WIRE_13,
		 PC_FE => PC);




SYNTHESIZED_WIRE_3 <= reset OR SYNTHESIZED_WIRE_10 OR flush;


SYNTHESIZED_WIRE_23 <= NOT(reset);



SYNTHESIZED_WIRE_24 <= NOT(iMemAck);



b2v_inst14 : mux4x32bit
PORT MAP(data0x => PC,
		 data1x => SYNTHESIZED_WIRE_11,
		 data2x => SYNTHESIZED_WIRE_12,
		 data3x => targetPC,
		 sel => MuxSel,
		 result => SYNTHESIZED_WIRE_27);


SYNTHESIZED_WIRE_17 <= NOT(cancelFe);



b2v_inst20 : fepipelinereg
PORT MAP(predict_FE => SYNTHESIZED_WIRE_13,
		 clk => clk,
		 reset => reset,
		 flush => SYNTHESIZED_WIRE_14,
		 stall => stall,
		 instruction_FE => SYNTHESIZED_WIRE_15,
		 PC_FE => PC,
		 State_FE => State,
		 predict_DE => Predict_DE,
		 instruction_DE => Instruction,
		 PC_DE => PC_DE,
		 State_DE => State_DE);



b2v_inst22 : plus4
PORT MAP(dataa => PC,
		 result => SYNTHESIZED_WIRE_11);


instructionReady <= SYNTHESIZED_WIRE_16 AND SYNTHESIZED_WIRE_17;



SYNTHESIZED_WIRE_18 <= updatePC OR prediction;


SYNTHESIZED_WIRE_31 <= taken OR instructionReady;


MuxSel(1) <= SYNTHESIZED_WIRE_18 AND SYNTHESIZED_WIRE_31;


SYNTHESIZED_WIRE_21 <= updatePC OR SYNTHESIZED_WIRE_20;


PROCESS(clk)
BEGIN
IF (RISING_EDGE(clk)) THEN
	DFF_inst4 <= DFF_inst5;
END IF;
END PROCESS;


MuxSel(0) <= SYNTHESIZED_WIRE_21 AND SYNTHESIZED_WIRE_31;


SYNTHESIZED_WIRE_20 <= NOT(prediction);




PROCESS(clk)
BEGIN
IF (RISING_EDGE(clk)) THEN
	DFF_inst5 <= reset;
END IF;
END PROCESS;


SYNTHESIZED_WIRE_25 <= SYNTHESIZED_WIRE_23 AND SYNTHESIZED_WIRE_24;


nextCancelFe <= SYNTHESIZED_WIRE_25 AND SYNTHESIZED_WIRE_26;


SYNTHESIZED_WIRE_26 <= taken OR cancelFe;


b2v_Mux1 : mux2x32bit
PORT MAP(sel => DFF_inst4,
		 data0x => SYNTHESIZED_WIRE_27,
		 data1x => SYNTHESIZED_WIRE_28,
		 result => nextPC);


b2v_Mux2 : mux2x32bit
PORT MAP(sel => cancelFe,
		 data0x => nextPC,
		 data1x => PC,
		 result => iMemAddress);


b2v_NOP : nop
PORT MAP(		 result => SYNTHESIZED_WIRE_4);


SYNTHESIZED_WIRE_10 <= NOT(instructionReady);



iMemReadReq <= NOT(reset);



SYNTHESIZED_WIRE_2 <= NOT(stall);



SYNTHESIZED_WIRE_1 <= SYNTHESIZED_WIRE_29 OR SYNTHESIZED_WIRE_30;


b2v_ResetPC : resetpc
PORT MAP(		 result => SYNTHESIZED_WIRE_28);


clk <= clock;
readData <= iMemReadData;

END bdf_type;