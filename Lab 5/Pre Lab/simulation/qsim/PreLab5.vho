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

-- DATE "06/22/2023 15:01:07"

-- 
-- Device: Altera 5CSXFC6D6F31C6 Package FBGA896
-- 

-- 
-- This VHDL file should be used for ModelSim-Altera (VHDL) only
-- 

LIBRARY ALTERA;
LIBRARY ALTERA_LNSIM;
LIBRARY CYCLONEV;
LIBRARY IEEE;
USE ALTERA.ALTERA_PRIMITIVES_COMPONENTS.ALL;
USE ALTERA_LNSIM.ALTERA_LNSIM_COMPONENTS.ALL;
USE CYCLONEV.CYCLONEV_COMPONENTS.ALL;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY 	PreLab5 IS
    PORT (
	stop : IN std_logic;
	go : IN std_logic;
	clock : IN std_logic;
	resetn : IN std_logic;
	r_en : OUT std_logic;
	y_en : OUT std_logic;
	g_en : OUT std_logic
	);
END PreLab5;

ARCHITECTURE structure OF PreLab5 IS
SIGNAL gnd : std_logic := '0';
SIGNAL vcc : std_logic := '1';
SIGNAL unknown : std_logic := 'X';
SIGNAL devoe : std_logic := '1';
SIGNAL devclrn : std_logic := '1';
SIGNAL devpor : std_logic := '1';
SIGNAL ww_devoe : std_logic;
SIGNAL ww_devclrn : std_logic;
SIGNAL ww_devpor : std_logic;
SIGNAL ww_stop : std_logic;
SIGNAL ww_go : std_logic;
SIGNAL ww_clock : std_logic;
SIGNAL ww_resetn : std_logic;
SIGNAL ww_r_en : std_logic;
SIGNAL ww_y_en : std_logic;
SIGNAL ww_g_en : std_logic;
SIGNAL \r_en~output_o\ : std_logic;
SIGNAL \y_en~output_o\ : std_logic;
SIGNAL \g_en~output_o\ : std_logic;
SIGNAL \clock~input_o\ : std_logic;
SIGNAL \go~input_o\ : std_logic;
SIGNAL \stop~input_o\ : std_logic;
SIGNAL \process_0~0_combout\ : std_logic;
SIGNAL \resetn~input_o\ : std_logic;
SIGNAL \state.g_light~q\ : std_logic;
SIGNAL \Selector1~0_combout\ : std_logic;
SIGNAL \state.y_light~q\ : std_logic;
SIGNAL \Selector0~0_combout\ : std_logic;
SIGNAL \state.r_light~q\ : std_logic;
SIGNAL \ALT_INV_stop~input_o\ : std_logic;
SIGNAL \ALT_INV_go~input_o\ : std_logic;
SIGNAL \ALT_INV_state.g_light~q\ : std_logic;
SIGNAL \ALT_INV_state.y_light~q\ : std_logic;

BEGIN

ww_stop <= stop;
ww_go <= go;
ww_clock <= clock;
ww_resetn <= resetn;
r_en <= ww_r_en;
y_en <= ww_y_en;
g_en <= ww_g_en;
ww_devoe <= devoe;
ww_devclrn <= devclrn;
ww_devpor <= devpor;
\ALT_INV_stop~input_o\ <= NOT \stop~input_o\;
\ALT_INV_go~input_o\ <= NOT \go~input_o\;
\ALT_INV_state.g_light~q\ <= NOT \state.g_light~q\;
\ALT_INV_state.y_light~q\ <= NOT \state.y_light~q\;

\r_en~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \state.r_light~q\,
	devoe => ww_devoe,
	o => \r_en~output_o\);

\y_en~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \ALT_INV_state.y_light~q\,
	devoe => ww_devoe,
	o => \y_en~output_o\);

\g_en~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => \state.g_light~q\,
	devoe => ww_devoe,
	o => \g_en~output_o\);

\clock~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_clock,
	o => \clock~input_o\);

\go~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_go,
	o => \go~input_o\);

\stop~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_stop,
	o => \stop~input_o\);

\process_0~0\ : cyclonev_lcell_comb
-- Equation(s):
-- \process_0~0_combout\ = (\go~input_o\ & !\stop~input_o\)

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0100010001000100010001000100010001000100010001000100010001000100",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_go~input_o\,
	datab => \ALT_INV_stop~input_o\,
	combout => \process_0~0_combout\);

\resetn~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_resetn,
	o => \resetn~input_o\);

\state.g_light\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clock~input_o\,
	d => \process_0~0_combout\,
	clrn => \resetn~input_o\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \state.g_light~q\);

\Selector1~0\ : cyclonev_lcell_comb
-- Equation(s):
-- \Selector1~0_combout\ = ((!\state.g_light~q\ & ((\stop~input_o\) # (\state.y_light~q\)))) # (\go~input_o\)

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0100111111001111010011111100111101001111110011110100111111001111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_state.y_light~q\,
	datab => \ALT_INV_state.g_light~q\,
	datac => \ALT_INV_go~input_o\,
	datad => \ALT_INV_stop~input_o\,
	combout => \Selector1~0_combout\);

\state.y_light\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clock~input_o\,
	d => \Selector1~0_combout\,
	clrn => \resetn~input_o\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \state.y_light~q\);

\Selector0~0\ : cyclonev_lcell_comb
-- Equation(s):
-- \Selector0~0_combout\ = (!\go~input_o\ & (!\state.g_light~q\ & ((\stop~input_o\) # (\state.y_light~q\)))) # (\go~input_o\ & (((\stop~input_o\))))

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0100000011001111010000001100111101000000110011110100000011001111",
	shared_arith => "off")
-- pragma translate_on
PORT MAP (
	dataa => \ALT_INV_state.y_light~q\,
	datab => \ALT_INV_state.g_light~q\,
	datac => \ALT_INV_go~input_o\,
	datad => \ALT_INV_stop~input_o\,
	combout => \Selector0~0_combout\);

\state.r_light\ : dffeas
-- pragma translate_off
GENERIC MAP (
	is_wysiwyg => "true",
	power_up => "low")
-- pragma translate_on
PORT MAP (
	clk => \clock~input_o\,
	d => \Selector0~0_combout\,
	clrn => \resetn~input_o\,
	devclrn => ww_devclrn,
	devpor => ww_devpor,
	q => \state.r_light~q\);

ww_r_en <= \r_en~output_o\;

ww_y_en <= \y_en~output_o\;

ww_g_en <= \g_en~output_o\;
END structure;


