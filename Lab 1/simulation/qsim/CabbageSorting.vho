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

-- DATE "05/25/2023 16:20:53"

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

ENTITY 	CabbageSorting IS
    PORT (
	Wash : OUT std_logic;
	Cold : IN std_logic;
	Hot : IN std_logic;
	Dirty : IN std_logic;
	Grocery : OUT std_logic;
	Large : IN std_logic;
	Round : IN std_logic;
	Shred : OUT std_logic;
	Discard : OUT std_logic
	);
END CabbageSorting;

ARCHITECTURE structure OF CabbageSorting IS
SIGNAL gnd : std_logic := '0';
SIGNAL vcc : std_logic := '1';
SIGNAL unknown : std_logic := 'X';
SIGNAL devoe : std_logic := '1';
SIGNAL devclrn : std_logic := '1';
SIGNAL devpor : std_logic := '1';
SIGNAL ww_devoe : std_logic;
SIGNAL ww_devclrn : std_logic;
SIGNAL ww_devpor : std_logic;
SIGNAL ww_Wash : std_logic;
SIGNAL ww_Cold : std_logic;
SIGNAL ww_Hot : std_logic;
SIGNAL ww_Dirty : std_logic;
SIGNAL ww_Grocery : std_logic;
SIGNAL ww_Large : std_logic;
SIGNAL ww_Round : std_logic;
SIGNAL ww_Shred : std_logic;
SIGNAL ww_Discard : std_logic;
SIGNAL \Wash~output_o\ : std_logic;
SIGNAL \Grocery~output_o\ : std_logic;
SIGNAL \Shred~output_o\ : std_logic;
SIGNAL \Discard~output_o\ : std_logic;
SIGNAL \Cold~input_o\ : std_logic;
SIGNAL \Hot~input_o\ : std_logic;
SIGNAL \Dirty~input_o\ : std_logic;
SIGNAL \inst2~combout\ : std_logic;
SIGNAL \Large~input_o\ : std_logic;
SIGNAL \Round~input_o\ : std_logic;
SIGNAL \inst4~0_combout\ : std_logic;
SIGNAL \inst6~0_combout\ : std_logic;
SIGNAL \inst~combout\ : std_logic;
SIGNAL \ALT_INV_Round~input_o\ : std_logic;
SIGNAL \ALT_INV_Large~input_o\ : std_logic;
SIGNAL \ALT_INV_Dirty~input_o\ : std_logic;
SIGNAL \ALT_INV_Hot~input_o\ : std_logic;
SIGNAL \ALT_INV_Cold~input_o\ : std_logic;

BEGIN

Wash <= ww_Wash;
ww_Cold <= Cold;
ww_Hot <= Hot;
ww_Dirty <= Dirty;
Grocery <= ww_Grocery;
ww_Large <= Large;
ww_Round <= Round;
Shred <= ww_Shred;
Discard <= ww_Discard;
ww_devoe <= devoe;
ww_devclrn <= devclrn;
ww_devpor <= devpor;
\ALT_INV_Round~input_o\ <= NOT \Round~input_o\;
\ALT_INV_Large~input_o\ <= NOT \Large~input_o\;
\ALT_INV_Dirty~input_o\ <= NOT \Dirty~input_o\;
\ALT_INV_Hot~input_o\ <= NOT \Hot~input_o\;
\ALT_INV_Cold~input_o\ <= NOT \Cold~input_o\;

\Wash~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \inst2~combout\,
	devoe => ww_devoe,
	o => \Wash~output_o\);

\Grocery~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \inst4~0_combout\,
	devoe => ww_devoe,
	o => \Grocery~output_o\);

\Shred~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \inst6~0_combout\,
	devoe => ww_devoe,
	o => \Shred~output_o\);

\Discard~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \inst~combout\,
	devoe => ww_devoe,
	o => \Discard~output_o\);

\Cold~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_Cold,
	o => \Cold~input_o\);

\Hot~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_Hot,
	o => \Hot~input_o\);

\Dirty~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_Dirty,
	o => \Dirty~input_o\);

inst2 : cyclonev_lcell_comb
-- Equation(s):
-- \inst2~combout\ = (!\Cold~input_o\ & (!\Hot~input_o\ & \Dirty~input_o\))

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000100000001000000010000000100000001000000010000000100000001000",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_Cold~input_o\,
	datab => \ALT_INV_Hot~input_o\,
	datac => \ALT_INV_Dirty~input_o\,
	combout => \inst2~combout\);

\Large~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_Large,
	o => \Large~input_o\);

\Round~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_Round,
	o => \Round~input_o\);

\inst4~0\ : cyclonev_lcell_comb
-- Equation(s):
-- \inst4~0_combout\ = ( \Round~input_o\ & ( (!\Cold~input_o\ & (!\Hot~input_o\ & (!\Dirty~input_o\ & \Large~input_o\))) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000000000000000000001000000000000000000000000000000010000000",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_Cold~input_o\,
	datab => \ALT_INV_Hot~input_o\,
	datac => \ALT_INV_Dirty~input_o\,
	datad => \ALT_INV_Large~input_o\,
	datae => \ALT_INV_Round~input_o\,
	combout => \inst4~0_combout\);

\inst6~0\ : cyclonev_lcell_comb
-- Equation(s):
-- \inst6~0_combout\ = ( \Round~input_o\ & ( (!\Cold~input_o\ & (!\Hot~input_o\ & (!\Dirty~input_o\ & !\Large~input_o\))) ) ) # ( !\Round~input_o\ & ( (!\Cold~input_o\ & (!\Hot~input_o\ & !\Dirty~input_o\)) ) )

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "1000000010000000100000000000000010000000100000001000000000000000",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_Cold~input_o\,
	datab => \ALT_INV_Hot~input_o\,
	datac => \ALT_INV_Dirty~input_o\,
	datad => \ALT_INV_Large~input_o\,
	datae => \ALT_INV_Round~input_o\,
	combout => \inst6~0_combout\);

inst : cyclonev_lcell_comb
-- Equation(s):
-- \inst~combout\ = (\Hot~input_o\) # (\Cold~input_o\)

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0111011101110111011101110111011101110111011101110111011101110111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_Cold~input_o\,
	datab => \ALT_INV_Hot~input_o\,
	combout => \inst~combout\);

ww_Wash <= \Wash~output_o\;

ww_Grocery <= \Grocery~output_o\;

ww_Shred <= \Shred~output_o\;

ww_Discard <= \Discard~output_o\;
END structure;


