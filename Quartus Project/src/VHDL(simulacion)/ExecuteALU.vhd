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
-- CREATED		"Wed Jun 26 19:07:14 2019"

LIBRARY ieee;
USE ieee.std_logic_1164.all; 

LIBRARY work;

ENTITY ExecuteALU IS 
	PORT
	(
		Clk :  IN  STD_LOGIC;
		A :  IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
		ALU_Ctrl :  IN  STD_LOGIC_VECTOR(4 DOWNTO 0);
		B :  IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
		LongInst :  OUT  STD_LOGIC;
		RES :  OUT  STD_LOGIC_VECTOR(31 DOWNTO 0)
	);
END ExecuteALU;

ARCHITECTURE bdf_type OF ExecuteALU IS 

COMPONENT adder
	PORT(add_sub : IN STD_LOGIC;
		 dataa : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 datab : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 result : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
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

COMPONENT divideru_pipe
	PORT(clock : IN STD_LOGIC;
		 denom : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 numer : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 quotient : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
		 remain : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
	);
END COMPONENT;

COMPONENT alu_extendbit
GENERIC (DATA_WIDTH : INTEGER
			);
	PORT(inBit : IN STD_LOGIC;
		 outBus : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
	);
END COMPONENT;

COMPONENT alu_logic
GENERIC (DATA_WIDTH : INTEGER
			);
	PORT(a : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 b : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 andOut : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
		 orOut : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
		 xorOut : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
	);
END COMPONENT;

COMPONENT multiply
	PORT(dataa : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 datab : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 result : OUT STD_LOGIC_VECTOR(63 DOWNTO 0)
	);
END COMPONENT;

COMPONENT multiplyu
	PORT(dataa : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 datab : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 result : OUT STD_LOGIC_VECTOR(63 DOWNTO 0)
	);
END COMPONENT;

COMPONENT mux32x32bit
	PORT(data0x : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 data10x : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 data11x : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 data12x : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 data13x : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 data14x : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 data15x : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 data16x : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 data17x : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 data18x : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 data19x : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 data1x : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 data20x : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 data21x : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 data22x : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 data23x : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 data24x : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 data25x : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 data26x : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 data27x : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 data28x : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 data29x : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 data2x : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 data30x : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 data31x : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 data3x : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 data4x : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 data5x : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 data6x : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 data7x : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 data8x : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 data9x : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 sel : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
		 result : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
	);
END COMPONENT;

COMPONENT plus4
	PORT(dataa : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 result : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
	);
END COMPONENT;

COMPONENT divider_pipe
	PORT(clock : IN STD_LOGIC;
		 denom : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 numer : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 quotient : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
		 remain : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
	);
END COMPONENT;

COMPONENT longinstruction
	PORT(Clk : IN STD_LOGIC;
		 AluOp : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
		 longInst : OUT STD_LOGIC
	);
END COMPONENT;

COMPONENT shifterarith
	PORT(data : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 distance : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
		 result : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
	);
END COMPONENT;

COMPONENT shifterlogic
	PORT(direction : IN STD_LOGIC;
		 data : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 distance : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
		 result : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
	);
END COMPONENT;

SIGNAL	Mul :  STD_LOGIC_VECTOR(63 DOWNTO 0);
SIGNAL	MulU :  STD_LOGIC_VECTOR(63 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_0 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_1 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_29 :  STD_LOGIC_VECTOR(0 TO 31);
SIGNAL	SYNTHESIZED_WIRE_3 :  STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_4 :  STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_5 :  STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_6 :  STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_7 :  STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_9 :  STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_10 :  STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_30 :  STD_LOGIC_VECTOR(0 TO 31);
SIGNAL	SYNTHESIZED_WIRE_19 :  STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_22 :  STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_31 :  STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_25 :  STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_26 :  STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_32 :  STD_LOGIC_VECTOR(31 DOWNTO 0);


BEGIN 
SYNTHESIZED_WIRE_29 <= "00000000000000000000000000000000";
SYNTHESIZED_WIRE_30 <= "00000000000000000000000000000000";



b2v_AluAdder : adder
PORT MAP(add_sub => ALU_Ctrl(0),
		 dataa => A,
		 datab => B,
		 result => SYNTHESIZED_WIRE_32);


b2v_AluComp : comparator32
PORT MAP(dataa => A,
		 datab => B,
		 alb => SYNTHESIZED_WIRE_0);


b2v_AluCompUnsignes : comparator32u
PORT MAP(dataa => A,
		 datab => B,
		 alb => SYNTHESIZED_WIRE_1);


b2v_AluDivU : divideru_pipe
PORT MAP(clock => Clk,
		 denom => B,
		 numer => A,
		 quotient => SYNTHESIZED_WIRE_9,
		 remain => SYNTHESIZED_WIRE_10);


b2v_AluExtend1 : alu_extendbit
GENERIC MAP(DATA_WIDTH => 32
			)
PORT MAP(inBit => SYNTHESIZED_WIRE_0,
		 outBus => SYNTHESIZED_WIRE_26);


b2v_AluExtend2 : alu_extendbit
GENERIC MAP(DATA_WIDTH => 32
			)
PORT MAP(inBit => SYNTHESIZED_WIRE_1,
		 outBus => SYNTHESIZED_WIRE_25);


b2v_AluLogic : alu_logic
GENERIC MAP(DATA_WIDTH => 32
			)
PORT MAP(a => A,
		 b => B,
		 andOut => SYNTHESIZED_WIRE_5,
		 orOut => SYNTHESIZED_WIRE_4,
		 xorOut => SYNTHESIZED_WIRE_3);


b2v_AluMul : multiply
PORT MAP(dataa => A,
		 datab => B,
		 result => Mul);


b2v_AluMulU : multiplyu
PORT MAP(dataa => A,
		 datab => B,
		 result => MulU);


b2v_AluMux : mux32x32bit
PORT MAP(data0x => SYNTHESIZED_WIRE_29,
		 data10x => SYNTHESIZED_WIRE_3,
		 data11x => SYNTHESIZED_WIRE_4,
		 data12x => SYNTHESIZED_WIRE_5,
		 data13x => B,
		 data14x => A,
		 data15x => Mul(31 DOWNTO 0),
		 data16x => Mul(63 DOWNTO 32),
		 data17x => MulU(63 DOWNTO 32),
		 data18x => SYNTHESIZED_WIRE_6,
		 data19x => SYNTHESIZED_WIRE_7,
		 data1x => SYNTHESIZED_WIRE_29,
		 data20x => SYNTHESIZED_WIRE_9,
		 data21x => SYNTHESIZED_WIRE_10,
		 data22x => SYNTHESIZED_WIRE_30,
		 data23x => SYNTHESIZED_WIRE_30,
		 data24x => SYNTHESIZED_WIRE_30,
		 data25x => SYNTHESIZED_WIRE_30,
		 data26x => SYNTHESIZED_WIRE_30,
		 data27x => SYNTHESIZED_WIRE_30,
		 data28x => SYNTHESIZED_WIRE_30,
		 data29x => SYNTHESIZED_WIRE_30,
		 data2x => SYNTHESIZED_WIRE_19,
		 data30x => SYNTHESIZED_WIRE_30,
		 data31x => SYNTHESIZED_WIRE_30,
		 data3x => SYNTHESIZED_WIRE_22,
		 data4x => SYNTHESIZED_WIRE_31,
		 data5x => SYNTHESIZED_WIRE_31,
		 data6x => SYNTHESIZED_WIRE_25,
		 data7x => SYNTHESIZED_WIRE_26,
		 data8x => SYNTHESIZED_WIRE_32,
		 data9x => SYNTHESIZED_WIRE_32,
		 sel => ALU_Ctrl,
		 result => RES);


b2v_AluPlus4 : plus4
PORT MAP(dataa => A,
		 result => SYNTHESIZED_WIRE_19);


b2v_inst : divider_pipe
PORT MAP(clock => Clk,
		 denom => B,
		 numer => A,
		 quotient => SYNTHESIZED_WIRE_6,
		 remain => SYNTHESIZED_WIRE_7);




b2v_LongInstStall : longinstruction
PORT MAP(Clk => Clk,
		 AluOp => ALU_Ctrl,
		 longInst => LongInst);


b2v_ShifterArith : shifterarith
PORT MAP(data => A,
		 distance => B(4 DOWNTO 0),
		 result => SYNTHESIZED_WIRE_22);


b2v_ShifterLogic : shifterlogic
PORT MAP(direction => ALU_Ctrl(0),
		 data => A,
		 distance => B(4 DOWNTO 0),
		 result => SYNTHESIZED_WIRE_31);


END bdf_type;