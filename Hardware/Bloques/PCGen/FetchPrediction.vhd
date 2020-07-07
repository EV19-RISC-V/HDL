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
-- CREATED		"Fri Jun 07 02:41:45 2019"

LIBRARY ieee;
USE ieee.std_logic_1164.all; 

LIBRARY work;

ENTITY FetchPrediction IS 
	PORT
	(
		Clock :  IN  STD_LOGIC;
		reset :  IN  STD_LOGIC;
		stall :  IN  STD_LOGIC;
		unconditional :  IN  STD_LOGIC;
		updateTarget :  IN  STD_LOGIC;
		updateState :  IN  STD_LOGIC;
		taken :  IN  STD_LOGIC;
		PC_EX :  IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
		State_EX :  IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
		targetPC :  IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
		Predict_FE :  OUT  STD_LOGIC;
		PC_FE :  OUT  STD_LOGIC_VECTOR(31 DOWNTO 0);
		State_FE :  OUT  STD_LOGIC_VECTOR(7 DOWNTO 0)
	);
END FetchPrediction;

ARCHITECTURE bdf_type OF FetchPrediction IS 

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

COMPONENT mux3x32bit
	PORT(data0x : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 data1x : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 data2x : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 sel : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
		 result : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
	);
END COMPONENT;

COMPONENT add4
	PORT(dataa : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 result : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
	);
END COMPONENT;

SIGNAL	clk :  STD_LOGIC;
SIGNAL	MuxSel :  STD_LOGIC_VECTOR(1 DOWNTO 0);
SIGNAL	prediction :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_0 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_1 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_12 :  STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_4 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_5 :  STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_6 :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_7 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_8 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_9 :  STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_10 :  STD_LOGIC_VECTOR(31 DOWNTO 0);


BEGIN 
PC_FE <= SYNTHESIZED_WIRE_12;
SYNTHESIZED_WIRE_4 <= '0';



prediction <= SYNTHESIZED_WIRE_0 AND SYNTHESIZED_WIRE_1;


b2v_BHT : bht
GENERIC MAP(COLS => 4,
			NBITS => 2,
			ROWS => 64,
			SIZE => 128
			)
PORT MAP(clock => clk,
		 reset => reset,
		 update => updateState,
		 taken => taken,
		 execPC => PC_EX,
		 execState => State_EX,
		 fetchPC => SYNTHESIZED_WIRE_12,
		 take => SYNTHESIZED_WIRE_7,
		 nextStateOut => SYNTHESIZED_WIRE_6);


b2v_BTB : btb
GENERIC MAP(SIZE => 128
			)
PORT MAP(clk => clk,
		 reset => reset,
		 update => updateTarget,
		 uncondIn => unconditional,
		 nextPC => SYNTHESIZED_WIRE_12,
		 sourcePC => PC_EX,
		 targetPC => targetPC,
		 hit => SYNTHESIZED_WIRE_0,
		 uncondOut => SYNTHESIZED_WIRE_8,
		 predictedPC => SYNTHESIZED_WIRE_10);


b2v_GEN_FE : genpipelinereg
GENERIC MAP(RESET_ADDRESS => "00000000000000000000000000000000"
			)
PORT MAP(predict_GEN => prediction,
		 clk => clk,
		 reset => reset,
		 flush => SYNTHESIZED_WIRE_4,
		 stall => stall,
		 PC_GEN => SYNTHESIZED_WIRE_5,
		 State_GEN => SYNTHESIZED_WIRE_6,
		 predict_FE => Predict_FE,
		 PC_FE => SYNTHESIZED_WIRE_12,
		 State_FE => State_FE);



SYNTHESIZED_WIRE_1 <= SYNTHESIZED_WIRE_7 OR SYNTHESIZED_WIRE_8;


b2v_pcNextMux : mux3x32bit
PORT MAP(data0x => SYNTHESIZED_WIRE_9,
		 data1x => SYNTHESIZED_WIRE_10,
		 data2x => targetPC,
		 sel => MuxSel,
		 result => SYNTHESIZED_WIRE_5);


b2v_PLUS4 : add4
PORT MAP(dataa => SYNTHESIZED_WIRE_12,
		 result => SYNTHESIZED_WIRE_9);

MuxSel(1) <= updateTarget;


MuxSel(0) <= prediction;


clk <= Clock;

END bdf_type;