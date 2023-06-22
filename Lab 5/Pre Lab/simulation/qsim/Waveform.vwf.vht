-- Copyright (C) 2019  Intel Corporation. All rights reserved.
-- Your use of Intel Corporation's design tools, logic functions 
-- and other software and tools, and any partner logic 
-- functions, and any output files from any of the foregoing 
-- (including device programming or simulation files), and any 
-- associated documentation or information are expressly subject 
-- to the terms and conditions of the Intel Program License 
-- Subscription Agreement, the Intel Quartus Prime License Agreement,
-- the Intel FPGA IP License Agreement, or other applicable license
-- agreement, including, without limitation, that your use is for
-- the sole purpose of programming logic devices manufactured by
-- Intel and sold by Intel or its authorized distributors.  Please
-- refer to the applicable agreement for further details, at
-- https://fpgasoftware.intel.com/eula.

-- *****************************************************************************
-- This file contains a Vhdl test bench with test vectors .The test vectors     
-- are exported from a vector file in the Quartus Waveform Editor and apply to  
-- the top level entity of the current Quartus project .The user can use this   
-- testbench to simulate his design using a third-party simulation tool .       
-- *****************************************************************************
-- Generated on "06/22/2023 15:01:06"
                                                             
-- Vhdl Test Bench(with test vectors) for design  :          PreLab5
-- 
-- Simulation tool : 3rd Party
-- 

LIBRARY ieee;                                               
USE ieee.std_logic_1164.all;                                

ENTITY PreLab5_vhd_vec_tst IS
END PreLab5_vhd_vec_tst;
ARCHITECTURE PreLab5_arch OF PreLab5_vhd_vec_tst IS
-- constants                                                 
-- signals                                                   
SIGNAL clock : STD_LOGIC;
SIGNAL g_en : STD_LOGIC;
SIGNAL go : STD_LOGIC;
SIGNAL r_en : STD_LOGIC;
SIGNAL resetn : STD_LOGIC;
SIGNAL stop : STD_LOGIC;
SIGNAL y_en : STD_LOGIC;
COMPONENT PreLab5
	PORT (
	clock : IN STD_LOGIC;
	g_en : OUT STD_LOGIC;
	go : IN STD_LOGIC;
	r_en : OUT STD_LOGIC;
	resetn : IN STD_LOGIC;
	stop : IN STD_LOGIC;
	y_en : OUT STD_LOGIC
	);
END COMPONENT;
BEGIN
	i1 : PreLab5
	PORT MAP (
-- list connections between master ports and signals
	clock => clock,
	g_en => g_en,
	go => go,
	r_en => r_en,
	resetn => resetn,
	stop => stop,
	y_en => y_en
	);

-- clock
t_prcs_clock: PROCESS
BEGIN
LOOP
	clock <= '0';
	WAIT FOR 25000 ps;
	clock <= '1';
	WAIT FOR 25000 ps;
	IF (NOW >= 1000000 ps) THEN WAIT; END IF;
END LOOP;
END PROCESS t_prcs_clock;

-- resetn
t_prcs_resetn: PROCESS
BEGIN
	resetn <= '1';
	WAIT FOR 840000 ps;
	resetn <= '0';
	WAIT FOR 50000 ps;
	resetn <= '1';
WAIT;
END PROCESS t_prcs_resetn;

-- stop
t_prcs_stop: PROCESS
BEGIN
	stop <= '0';
	WAIT FOR 60000 ps;
	stop <= '1';
	WAIT FOR 50000 ps;
	stop <= '0';
	WAIT FOR 150000 ps;
	stop <= '1';
	WAIT FOR 80000 ps;
	stop <= '0';
	WAIT FOR 70000 ps;
	stop <= '1';
	WAIT FOR 100000 ps;
	stop <= '0';
	WAIT FOR 20000 ps;
	stop <= '1';
	WAIT FOR 60000 ps;
	stop <= '0';
	WAIT FOR 70000 ps;
	stop <= '1';
	WAIT FOR 140000 ps;
	stop <= '0';
WAIT;
END PROCESS t_prcs_stop;

-- go
t_prcs_go: PROCESS
BEGIN
	go <= '0';
	WAIT FOR 160000 ps;
	go <= '1';
	WAIT FOR 60000 ps;
	go <= '0';
	WAIT FOR 40000 ps;
	go <= '1';
	WAIT FOR 280000 ps;
	go <= '0';
	WAIT FOR 60000 ps;
	go <= '1';
	WAIT FOR 40000 ps;
	go <= '0';
WAIT;
END PROCESS t_prcs_go;
END PreLab5_arch;
