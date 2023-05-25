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

-- VENDOR "Altera"
-- PROGRAM "Quartus Prime"
-- VERSION "Version 19.1.0 Build 670 09/22/2019 SJ Lite Edition"

-- DATE "05/25/2023 13:29:41"

-- 
-- Device: Altera 5CSXFC6D6F31C6 Package FBGA896
-- 

-- 
-- This VHDL file should be used for ModelSim-Altera (VHDL) only
-- 

LIBRARY ALTERA_LNSIM;
LIBRARY CYCLONEV;
LIBRARY IEEE;
USE ALTERA_LNSIM.ALTERA_LNSIM_COMPONENTS.ALL;
USE CYCLONEV.CYCLONEV_COMPONENTS.ALL;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY 	IntroCircuit IS
    PORT (
	LEDR0 : OUT std_logic;
	KEY0 : IN std_logic;
	LEDR1 : OUT std_logic;
	KEY1 : IN std_logic;
	LEDR9 : OUT std_logic;
	SW9 : IN std_logic;
	SW8 : IN std_logic
	);
END IntroCircuit;

-- Design Ports Information
-- LEDR0	=>  Location: PIN_AA24,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 16mA
-- LEDR1	=>  Location: PIN_AB23,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 16mA
-- LEDR9	=>  Location: PIN_AC22,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: 16mA
-- KEY0	=>  Location: PIN_AJ4,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: Default
-- KEY1	=>  Location: PIN_AK4,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: Default
-- SW9	=>  Location: PIN_AA30,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: Default
-- SW8	=>  Location: PIN_AC29,	 I/O Standard: 3.3-V LVTTL,	 Current Strength: Default


ARCHITECTURE structure OF IntroCircuit IS
SIGNAL gnd : std_logic := '0';
SIGNAL vcc : std_logic := '1';
SIGNAL unknown : std_logic := 'X';
SIGNAL devoe : std_logic := '1';
SIGNAL devclrn : std_logic := '1';
SIGNAL devpor : std_logic := '1';
SIGNAL ww_devoe : std_logic;
SIGNAL ww_devclrn : std_logic;
SIGNAL ww_devpor : std_logic;
SIGNAL ww_LEDR0 : std_logic;
SIGNAL ww_KEY0 : std_logic;
SIGNAL ww_LEDR1 : std_logic;
SIGNAL ww_KEY1 : std_logic;
SIGNAL ww_LEDR9 : std_logic;
SIGNAL ww_SW9 : std_logic;
SIGNAL ww_SW8 : std_logic;
SIGNAL \~QUARTUS_CREATED_GND~I_combout\ : std_logic;
SIGNAL \KEY0~input_o\ : std_logic;
SIGNAL \KEY1~input_o\ : std_logic;
SIGNAL \SW8~input_o\ : std_logic;
SIGNAL \SW9~input_o\ : std_logic;
SIGNAL \inst1~combout\ : std_logic;
SIGNAL \ALT_INV_SW8~input_o\ : std_logic;
SIGNAL \ALT_INV_SW9~input_o\ : std_logic;
SIGNAL \ALT_INV_KEY1~input_o\ : std_logic;

BEGIN

LEDR0 <= ww_LEDR0;
ww_KEY0 <= KEY0;
LEDR1 <= ww_LEDR1;
ww_KEY1 <= KEY1;
LEDR9 <= ww_LEDR9;
ww_SW9 <= SW9;
ww_SW8 <= SW8;
ww_devoe <= devoe;
ww_devclrn <= devclrn;
ww_devpor <= devpor;
\ALT_INV_SW8~input_o\ <= NOT \SW8~input_o\;
\ALT_INV_SW9~input_o\ <= NOT \SW9~input_o\;
\ALT_INV_KEY1~input_o\ <= NOT \KEY1~input_o\;

-- Location: IOOBUF_X89_Y11_N45
\LEDR0~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \KEY0~input_o\,
	devoe => ww_devoe,
	o => ww_LEDR0);

-- Location: IOOBUF_X89_Y9_N22
\LEDR1~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \ALT_INV_KEY1~input_o\,
	devoe => ww_devoe,
	o => ww_LEDR1);

-- Location: IOOBUF_X86_Y0_N2
\LEDR9~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \inst1~combout\,
	devoe => ww_devoe,
	o => ww_LEDR9);

-- Location: IOIBUF_X22_Y0_N35
\KEY0~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_KEY0,
	o => \KEY0~input_o\);

-- Location: IOIBUF_X22_Y0_N52
\KEY1~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_KEY1,
	o => \KEY1~input_o\);

-- Location: IOIBUF_X89_Y20_N95
\SW8~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_SW8,
	o => \SW8~input_o\);

-- Location: IOIBUF_X89_Y21_N21
\SW9~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_SW9,
	o => \SW9~input_o\);

-- Location: LABCELL_X88_Y20_N30
inst1 : cyclonev_lcell_comb
-- Equation(s):
-- \inst1~combout\ = ( !\SW8~input_o\ & ( \SW9~input_o\ ) ) # ( \SW8~input_o\ & ( !\SW9~input_o\ ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000000000000111111111111111111111111111111110000000000000000",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	datae => \ALT_INV_SW8~input_o\,
	dataf => \ALT_INV_SW9~input_o\,
	combout => \inst1~combout\);

-- Location: MLABCELL_X25_Y47_N0
\~QUARTUS_CREATED_GND~I\ : cyclonev_lcell_comb
-- Equation(s):

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000000000000000000000000000000000000000000000000000000000000",
	shared_arith => "off")
-- pragma translate_on
;
END structure;


