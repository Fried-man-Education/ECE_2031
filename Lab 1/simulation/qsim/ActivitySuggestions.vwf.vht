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
-- Generated on "05/25/2023 16:20:48"
                                                             
-- Vhdl Test Bench(with test vectors) for design  :          CabbageSorting
-- 
-- Simulation tool : 3rd Party
-- 

LIBRARY ieee;                                               
USE ieee.std_logic_1164.all;                                

ENTITY CabbageSorting_vhd_vec_tst IS
END CabbageSorting_vhd_vec_tst;
ARCHITECTURE CabbageSorting_arch OF CabbageSorting_vhd_vec_tst IS
-- constants                                                 
-- signals                                                   
SIGNAL Cold : STD_LOGIC;
SIGNAL Dirty : STD_LOGIC;
SIGNAL Discard : STD_LOGIC;
SIGNAL Grocery : STD_LOGIC;
SIGNAL Hot : STD_LOGIC;
SIGNAL Large : STD_LOGIC;
SIGNAL Round : STD_LOGIC;
SIGNAL Shred : STD_LOGIC;
SIGNAL Wash : STD_LOGIC;
COMPONENT CabbageSorting
	PORT (
	Cold : IN STD_LOGIC;
	Dirty : IN STD_LOGIC;
	Discard : OUT STD_LOGIC;
	Grocery : OUT STD_LOGIC;
	Hot : IN STD_LOGIC;
	Large : IN STD_LOGIC;
	Round : IN STD_LOGIC;
	Shred : OUT STD_LOGIC;
	Wash : OUT STD_LOGIC
	);
END COMPONENT;
BEGIN
	i1 : CabbageSorting
	PORT MAP (
-- list connections between master ports and signals
	Cold => Cold,
	Dirty => Dirty,
	Discard => Discard,
	Grocery => Grocery,
	Hot => Hot,
	Large => Large,
	Round => Round,
	Shred => Shred,
	Wash => Wash
	);

-- Hot
t_prcs_Hot: PROCESS
BEGIN
LOOP
	Hot <= '0';
	WAIT FOR 1600000 ps;
	Hot <= '1';
	WAIT FOR 1600000 ps;
	IF (NOW >= 3200000 ps) THEN WAIT; END IF;
END LOOP;
END PROCESS t_prcs_Hot;

-- Cold
t_prcs_Cold: PROCESS
BEGIN
LOOP
	Cold <= '0';
	WAIT FOR 800000 ps;
	Cold <= '1';
	WAIT FOR 800000 ps;
	IF (NOW >= 3200000 ps) THEN WAIT; END IF;
END LOOP;
END PROCESS t_prcs_Cold;

-- Dirty
t_prcs_Dirty: PROCESS
BEGIN
LOOP
	Dirty <= '0';
	WAIT FOR 400000 ps;
	Dirty <= '1';
	WAIT FOR 400000 ps;
	IF (NOW >= 3200000 ps) THEN WAIT; END IF;
END LOOP;
END PROCESS t_prcs_Dirty;

-- Large
t_prcs_Large: PROCESS
BEGIN
LOOP
	Large <= '0';
	WAIT FOR 200000 ps;
	Large <= '1';
	WAIT FOR 200000 ps;
	IF (NOW >= 3200000 ps) THEN WAIT; END IF;
END LOOP;
END PROCESS t_prcs_Large;

-- Round
t_prcs_Round: PROCESS
BEGIN
LOOP
	Round <= '0';
	WAIT FOR 100000 ps;
	Round <= '1';
	WAIT FOR 100000 ps;
	IF (NOW >= 3200000 ps) THEN WAIT; END IF;
END LOOP;
END PROCESS t_prcs_Round;
END CabbageSorting_arch;
