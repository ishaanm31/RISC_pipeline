-- Copyright (C) 2020  Intel Corporation. All rights reserved.
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
-- VERSION "Version 20.1.1 Build 720 11/11/2020 SJ Lite Edition"

-- DATE "11/29/2022 00:34:56"

-- 
-- Device: Altera 10M25SAE144C8G Package EQFP144
-- 

-- 
-- This VHDL file should be used for ModelSim-Altera (VHDL) only
-- 

LIBRARY FIFTYFIVENM;
LIBRARY IEEE;
USE FIFTYFIVENM.FIFTYFIVENM_COMPONENTS.ALL;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY 	hard_block IS
    PORT (
	devoe : IN std_logic;
	devclrn : IN std_logic;
	devpor : IN std_logic
	);
END hard_block;

-- Design Ports Information
-- ~ALTERA_TMS~	=>  Location: PIN_16,	 I/O Standard: 2.5 V Schmitt Trigger,	 Current Strength: Default
-- ~ALTERA_TCK~	=>  Location: PIN_18,	 I/O Standard: 2.5 V Schmitt Trigger,	 Current Strength: Default
-- ~ALTERA_TDI~	=>  Location: PIN_19,	 I/O Standard: 2.5 V Schmitt Trigger,	 Current Strength: Default
-- ~ALTERA_TDO~	=>  Location: PIN_20,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- ~ALTERA_CONFIG_SEL~	=>  Location: PIN_126,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- ~ALTERA_nCONFIG~	=>  Location: PIN_129,	 I/O Standard: 2.5 V Schmitt Trigger,	 Current Strength: Default
-- ~ALTERA_nSTATUS~	=>  Location: PIN_136,	 I/O Standard: 2.5 V Schmitt Trigger,	 Current Strength: Default
-- ~ALTERA_CONF_DONE~	=>  Location: PIN_138,	 I/O Standard: 2.5 V Schmitt Trigger,	 Current Strength: Default


ARCHITECTURE structure OF hard_block IS
SIGNAL gnd : std_logic := '0';
SIGNAL vcc : std_logic := '1';
SIGNAL unknown : std_logic := 'X';
SIGNAL ww_devoe : std_logic;
SIGNAL ww_devclrn : std_logic;
SIGNAL ww_devpor : std_logic;
SIGNAL \~ALTERA_TMS~~padout\ : std_logic;
SIGNAL \~ALTERA_TCK~~padout\ : std_logic;
SIGNAL \~ALTERA_TDI~~padout\ : std_logic;
SIGNAL \~ALTERA_CONFIG_SEL~~padout\ : std_logic;
SIGNAL \~ALTERA_nCONFIG~~padout\ : std_logic;
SIGNAL \~ALTERA_nSTATUS~~padout\ : std_logic;
SIGNAL \~ALTERA_CONF_DONE~~padout\ : std_logic;
SIGNAL \~ALTERA_TMS~~ibuf_o\ : std_logic;
SIGNAL \~ALTERA_TCK~~ibuf_o\ : std_logic;
SIGNAL \~ALTERA_TDI~~ibuf_o\ : std_logic;
SIGNAL \~ALTERA_CONFIG_SEL~~ibuf_o\ : std_logic;
SIGNAL \~ALTERA_nCONFIG~~ibuf_o\ : std_logic;
SIGNAL \~ALTERA_nSTATUS~~ibuf_o\ : std_logic;
SIGNAL \~ALTERA_CONF_DONE~~ibuf_o\ : std_logic;

BEGIN

ww_devoe <= devoe;
ww_devclrn <= devclrn;
ww_devpor <= devpor;
END structure;


LIBRARY FIFTYFIVENM;
LIBRARY IEEE;
USE FIFTYFIVENM.FIFTYFIVENM_COMPONENTS.ALL;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY 	IITB_CPU IS
    PORT (
	clock : IN std_logic;
	Reset : IN std_logic;
	Mem_Ext_WR : IN std_logic;
	Mem_Ext_Data_in : IN std_logic_vector(15 DOWNTO 0);
	Mem_Ext_Add : IN std_logic_vector(15 DOWNTO 0)
	);
END IITB_CPU;

-- Design Ports Information
-- Mem_Ext_Add[10]	=>  Location: PIN_141,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- Mem_Ext_Add[11]	=>  Location: PIN_123,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- Mem_Ext_Add[12]	=>  Location: PIN_10,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- Mem_Ext_Add[13]	=>  Location: PIN_90,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- Mem_Ext_Add[14]	=>  Location: PIN_91,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- Mem_Ext_Add[15]	=>  Location: PIN_54,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- Mem_Ext_WR	=>  Location: PIN_46,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- Mem_Ext_Data_in[0]	=>  Location: PIN_89,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- Mem_Ext_Data_in[1]	=>  Location: PIN_86,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- Mem_Ext_Data_in[2]	=>  Location: PIN_48,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- Mem_Ext_Data_in[3]	=>  Location: PIN_64,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- Mem_Ext_Data_in[4]	=>  Location: PIN_114,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- Mem_Ext_Data_in[5]	=>  Location: PIN_47,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- Mem_Ext_Data_in[6]	=>  Location: PIN_78,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- Mem_Ext_Data_in[7]	=>  Location: PIN_120,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- Mem_Ext_Data_in[8]	=>  Location: PIN_69,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- Mem_Ext_Data_in[9]	=>  Location: PIN_110,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- Mem_Ext_Data_in[10]	=>  Location: PIN_80,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- Mem_Ext_Data_in[11]	=>  Location: PIN_111,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- Mem_Ext_Data_in[12]	=>  Location: PIN_59,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- Mem_Ext_Data_in[13]	=>  Location: PIN_79,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- Mem_Ext_Data_in[14]	=>  Location: PIN_66,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- Mem_Ext_Data_in[15]	=>  Location: PIN_88,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- Mem_Ext_Add[0]	=>  Location: PIN_38,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- Mem_Ext_Add[1]	=>  Location: PIN_76,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- Mem_Ext_Add[2]	=>  Location: PIN_57,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- Mem_Ext_Add[3]	=>  Location: PIN_105,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- Mem_Ext_Add[4]	=>  Location: PIN_134,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- Mem_Ext_Add[5]	=>  Location: PIN_39,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- Mem_Ext_Add[6]	=>  Location: PIN_85,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- Mem_Ext_Add[7]	=>  Location: PIN_25,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- Mem_Ext_Add[8]	=>  Location: PIN_98,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- Mem_Ext_Add[9]	=>  Location: PIN_58,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- clock	=>  Location: PIN_44,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- Reset	=>  Location: PIN_102,	 I/O Standard: 2.5 V,	 Current Strength: Default


ARCHITECTURE structure OF IITB_CPU IS
SIGNAL gnd : std_logic := '0';
SIGNAL vcc : std_logic := '1';
SIGNAL unknown : std_logic := 'X';
SIGNAL devoe : std_logic := '1';
SIGNAL devclrn : std_logic := '1';
SIGNAL devpor : std_logic := '1';
SIGNAL ww_devoe : std_logic;
SIGNAL ww_devclrn : std_logic;
SIGNAL ww_devpor : std_logic;
SIGNAL ww_clock : std_logic;
SIGNAL ww_Reset : std_logic;
SIGNAL ww_Mem_Ext_WR : std_logic;
SIGNAL ww_Mem_Ext_Data_in : std_logic_vector(15 DOWNTO 0);
SIGNAL ww_Mem_Ext_Add : std_logic_vector(15 DOWNTO 0);
SIGNAL \~QUARTUS_CREATED_ADC1~_CHSEL_bus\ : std_logic_vector(4 DOWNTO 0);
SIGNAL \~QUARTUS_CREATED_ADC2~_CHSEL_bus\ : std_logic_vector(4 DOWNTO 0);
SIGNAL \Mem_Ext_Add[10]~input_o\ : std_logic;
SIGNAL \Mem_Ext_Add[11]~input_o\ : std_logic;
SIGNAL \Mem_Ext_Add[12]~input_o\ : std_logic;
SIGNAL \Mem_Ext_Add[13]~input_o\ : std_logic;
SIGNAL \Mem_Ext_Add[14]~input_o\ : std_logic;
SIGNAL \Mem_Ext_Add[15]~input_o\ : std_logic;
SIGNAL \Mem_Ext_WR~input_o\ : std_logic;
SIGNAL \Mem_Ext_Data_in[0]~input_o\ : std_logic;
SIGNAL \Mem_Ext_Data_in[1]~input_o\ : std_logic;
SIGNAL \Mem_Ext_Data_in[2]~input_o\ : std_logic;
SIGNAL \Mem_Ext_Data_in[3]~input_o\ : std_logic;
SIGNAL \Mem_Ext_Data_in[4]~input_o\ : std_logic;
SIGNAL \Mem_Ext_Data_in[5]~input_o\ : std_logic;
SIGNAL \Mem_Ext_Data_in[6]~input_o\ : std_logic;
SIGNAL \Mem_Ext_Data_in[7]~input_o\ : std_logic;
SIGNAL \Mem_Ext_Data_in[8]~input_o\ : std_logic;
SIGNAL \Mem_Ext_Data_in[9]~input_o\ : std_logic;
SIGNAL \Mem_Ext_Data_in[10]~input_o\ : std_logic;
SIGNAL \Mem_Ext_Data_in[11]~input_o\ : std_logic;
SIGNAL \Mem_Ext_Data_in[12]~input_o\ : std_logic;
SIGNAL \Mem_Ext_Data_in[13]~input_o\ : std_logic;
SIGNAL \Mem_Ext_Data_in[14]~input_o\ : std_logic;
SIGNAL \Mem_Ext_Data_in[15]~input_o\ : std_logic;
SIGNAL \Mem_Ext_Add[0]~input_o\ : std_logic;
SIGNAL \Mem_Ext_Add[1]~input_o\ : std_logic;
SIGNAL \Mem_Ext_Add[2]~input_o\ : std_logic;
SIGNAL \Mem_Ext_Add[3]~input_o\ : std_logic;
SIGNAL \Mem_Ext_Add[4]~input_o\ : std_logic;
SIGNAL \Mem_Ext_Add[5]~input_o\ : std_logic;
SIGNAL \Mem_Ext_Add[6]~input_o\ : std_logic;
SIGNAL \Mem_Ext_Add[7]~input_o\ : std_logic;
SIGNAL \Mem_Ext_Add[8]~input_o\ : std_logic;
SIGNAL \Mem_Ext_Add[9]~input_o\ : std_logic;
SIGNAL \clock~input_o\ : std_logic;
SIGNAL \Reset~input_o\ : std_logic;
SIGNAL \~QUARTUS_CREATED_GND~I_combout\ : std_logic;
SIGNAL \~QUARTUS_CREATED_UNVM~~busy\ : std_logic;
SIGNAL \~QUARTUS_CREATED_ADC1~~eoc\ : std_logic;
SIGNAL \~QUARTUS_CREATED_ADC2~~eoc\ : std_logic;

COMPONENT hard_block
    PORT (
	devoe : IN std_logic;
	devclrn : IN std_logic;
	devpor : IN std_logic);
END COMPONENT;

BEGIN

ww_clock <= clock;
ww_Reset <= Reset;
ww_Mem_Ext_WR <= Mem_Ext_WR;
ww_Mem_Ext_Data_in <= Mem_Ext_Data_in;
ww_Mem_Ext_Add <= Mem_Ext_Add;
ww_devoe <= devoe;
ww_devclrn <= devclrn;
ww_devpor <= devpor;

\~QUARTUS_CREATED_ADC1~_CHSEL_bus\ <= (\~QUARTUS_CREATED_GND~I_combout\ & \~QUARTUS_CREATED_GND~I_combout\ & \~QUARTUS_CREATED_GND~I_combout\ & \~QUARTUS_CREATED_GND~I_combout\ & \~QUARTUS_CREATED_GND~I_combout\);

\~QUARTUS_CREATED_ADC2~_CHSEL_bus\ <= (\~QUARTUS_CREATED_GND~I_combout\ & \~QUARTUS_CREATED_GND~I_combout\ & \~QUARTUS_CREATED_GND~I_combout\ & \~QUARTUS_CREATED_GND~I_combout\ & \~QUARTUS_CREATED_GND~I_combout\);
auto_generated_inst : hard_block
PORT MAP (
	devoe => ww_devoe,
	devclrn => ww_devclrn,
	devpor => ww_devpor);

-- Location: LCCOMB_X26_Y23_N24
\~QUARTUS_CREATED_GND~I\ : fiftyfivenm_lcell_comb
-- Equation(s):
-- \~QUARTUS_CREATED_GND~I_combout\ = GND

-- pragma translate_off
GENERIC MAP (
	lut_mask => "0000000000000000",
	sum_lutc_input => "datac")
-- pragma translate_on
PORT MAP (
	combout => \~QUARTUS_CREATED_GND~I_combout\);

-- Location: IOIBUF_X8_Y21_N22
\Mem_Ext_Add[10]~input\ : fiftyfivenm_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	listen_to_nsleep_signal => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_Mem_Ext_Add(10),
	o => \Mem_Ext_Add[10]~input_o\);

-- Location: IOIBUF_X14_Y21_N1
\Mem_Ext_Add[11]~input\ : fiftyfivenm_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	listen_to_nsleep_signal => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_Mem_Ext_Add(11),
	o => \Mem_Ext_Add[11]~input_o\);

-- Location: IOIBUF_X25_Y28_N22
\Mem_Ext_Add[12]~input\ : fiftyfivenm_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	listen_to_nsleep_signal => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_Mem_Ext_Add(12),
	o => \Mem_Ext_Add[12]~input_o\);

-- Location: IOIBUF_X60_Y14_N22
\Mem_Ext_Add[13]~input\ : fiftyfivenm_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	listen_to_nsleep_signal => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_Mem_Ext_Add(13),
	o => \Mem_Ext_Add[13]~input_o\);

-- Location: IOIBUF_X60_Y14_N15
\Mem_Ext_Add[14]~input\ : fiftyfivenm_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	listen_to_nsleep_signal => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_Mem_Ext_Add(14),
	o => \Mem_Ext_Add[14]~input_o\);

-- Location: IOIBUF_X19_Y0_N22
\Mem_Ext_Add[15]~input\ : fiftyfivenm_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	listen_to_nsleep_signal => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_Mem_Ext_Add(15),
	o => \Mem_Ext_Add[15]~input_o\);

-- Location: IOIBUF_X14_Y0_N8
\Mem_Ext_WR~input\ : fiftyfivenm_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	listen_to_nsleep_signal => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_Mem_Ext_WR,
	o => \Mem_Ext_WR~input_o\);

-- Location: IOIBUF_X60_Y13_N15
\Mem_Ext_Data_in[0]~input\ : fiftyfivenm_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	listen_to_nsleep_signal => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_Mem_Ext_Data_in(0),
	o => \Mem_Ext_Data_in[0]~input_o\);

-- Location: IOIBUF_X60_Y10_N1
\Mem_Ext_Data_in[1]~input\ : fiftyfivenm_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	listen_to_nsleep_signal => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_Mem_Ext_Data_in(1),
	o => \Mem_Ext_Data_in[1]~input_o\);

-- Location: IOIBUF_X16_Y0_N29
\Mem_Ext_Data_in[2]~input\ : fiftyfivenm_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	listen_to_nsleep_signal => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_Mem_Ext_Data_in(2),
	o => \Mem_Ext_Data_in[2]~input_o\);

-- Location: IOIBUF_X40_Y0_N29
\Mem_Ext_Data_in[3]~input\ : fiftyfivenm_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	listen_to_nsleep_signal => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_Mem_Ext_Data_in(3),
	o => \Mem_Ext_Data_in[3]~input_o\);

-- Location: IOIBUF_X38_Y36_N15
\Mem_Ext_Data_in[4]~input\ : fiftyfivenm_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	listen_to_nsleep_signal => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_Mem_Ext_Data_in(4),
	o => \Mem_Ext_Data_in[4]~input_o\);

-- Location: IOIBUF_X14_Y0_N1
\Mem_Ext_Data_in[5]~input\ : fiftyfivenm_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	listen_to_nsleep_signal => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_Mem_Ext_Data_in(5),
	o => \Mem_Ext_Data_in[5]~input_o\);

-- Location: IOIBUF_X60_Y8_N8
\Mem_Ext_Data_in[6]~input\ : fiftyfivenm_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	listen_to_nsleep_signal => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_Mem_Ext_Data_in(6),
	o => \Mem_Ext_Data_in[6]~input_o\);

-- Location: IOIBUF_X19_Y21_N22
\Mem_Ext_Data_in[7]~input\ : fiftyfivenm_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	listen_to_nsleep_signal => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_Mem_Ext_Data_in(7),
	o => \Mem_Ext_Data_in[7]~input_o\);

-- Location: IOIBUF_X53_Y0_N8
\Mem_Ext_Data_in[8]~input\ : fiftyfivenm_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	listen_to_nsleep_signal => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_Mem_Ext_Data_in(8),
	o => \Mem_Ext_Data_in[8]~input_o\);

-- Location: IOIBUF_X58_Y36_N1
\Mem_Ext_Data_in[9]~input\ : fiftyfivenm_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	listen_to_nsleep_signal => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_Mem_Ext_Data_in(9),
	o => \Mem_Ext_Data_in[9]~input_o\);

-- Location: IOIBUF_X60_Y8_N1
\Mem_Ext_Data_in[10]~input\ : fiftyfivenm_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	listen_to_nsleep_signal => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_Mem_Ext_Data_in(10),
	o => \Mem_Ext_Data_in[10]~input_o\);

-- Location: IOIBUF_X58_Y36_N8
\Mem_Ext_Data_in[11]~input\ : fiftyfivenm_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	listen_to_nsleep_signal => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_Mem_Ext_Data_in(11),
	o => \Mem_Ext_Data_in[11]~input_o\);

-- Location: IOIBUF_X24_Y0_N8
\Mem_Ext_Data_in[12]~input\ : fiftyfivenm_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	listen_to_nsleep_signal => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_Mem_Ext_Data_in(12),
	o => \Mem_Ext_Data_in[12]~input_o\);

-- Location: IOIBUF_X60_Y8_N22
\Mem_Ext_Data_in[13]~input\ : fiftyfivenm_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	listen_to_nsleep_signal => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_Mem_Ext_Data_in(13),
	o => \Mem_Ext_Data_in[13]~input_o\);

-- Location: IOIBUF_X40_Y0_N1
\Mem_Ext_Data_in[14]~input\ : fiftyfivenm_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	listen_to_nsleep_signal => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_Mem_Ext_Data_in(14),
	o => \Mem_Ext_Data_in[14]~input_o\);

-- Location: IOIBUF_X60_Y13_N22
\Mem_Ext_Data_in[15]~input\ : fiftyfivenm_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	listen_to_nsleep_signal => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_Mem_Ext_Data_in(15),
	o => \Mem_Ext_Data_in[15]~input_o\);

-- Location: IOIBUF_X3_Y0_N1
\Mem_Ext_Add[0]~input\ : fiftyfivenm_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	listen_to_nsleep_signal => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_Mem_Ext_Add(0),
	o => \Mem_Ext_Add[0]~input_o\);

-- Location: IOIBUF_X60_Y2_N1
\Mem_Ext_Add[1]~input\ : fiftyfivenm_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	listen_to_nsleep_signal => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_Mem_Ext_Add(1),
	o => \Mem_Ext_Add[1]~input_o\);

-- Location: IOIBUF_X21_Y0_N1
\Mem_Ext_Add[2]~input\ : fiftyfivenm_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	listen_to_nsleep_signal => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_Mem_Ext_Add(2),
	o => \Mem_Ext_Add[2]~input_o\);

-- Location: IOIBUF_X60_Y31_N22
\Mem_Ext_Add[3]~input\ : fiftyfivenm_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	listen_to_nsleep_signal => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_Mem_Ext_Add(3),
	o => \Mem_Ext_Add[3]~input_o\);

-- Location: IOIBUF_X10_Y21_N1
\Mem_Ext_Add[4]~input\ : fiftyfivenm_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	listen_to_nsleep_signal => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_Mem_Ext_Add(4),
	o => \Mem_Ext_Add[4]~input_o\);

-- Location: IOIBUF_X6_Y0_N29
\Mem_Ext_Add[5]~input\ : fiftyfivenm_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	listen_to_nsleep_signal => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_Mem_Ext_Add(5),
	o => \Mem_Ext_Add[5]~input_o\);

-- Location: IOIBUF_X60_Y10_N23
\Mem_Ext_Add[6]~input\ : fiftyfivenm_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	listen_to_nsleep_signal => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_Mem_Ext_Add(6),
	o => \Mem_Ext_Add[6]~input_o\);

-- Location: IOIBUF_X0_Y15_N22
\Mem_Ext_Add[7]~input\ : fiftyfivenm_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	listen_to_nsleep_signal => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_Mem_Ext_Add(7),
	o => \Mem_Ext_Add[7]~input_o\);

-- Location: IOIBUF_X60_Y22_N15
\Mem_Ext_Add[8]~input\ : fiftyfivenm_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	listen_to_nsleep_signal => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_Mem_Ext_Add(8),
	o => \Mem_Ext_Add[8]~input_o\);

-- Location: IOIBUF_X24_Y0_N29
\Mem_Ext_Add[9]~input\ : fiftyfivenm_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	listen_to_nsleep_signal => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_Mem_Ext_Add(9),
	o => \Mem_Ext_Add[9]~input_o\);

-- Location: IOIBUF_X8_Y0_N15
\clock~input\ : fiftyfivenm_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	listen_to_nsleep_signal => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_clock,
	o => \clock~input_o\);

-- Location: IOIBUF_X60_Y23_N1
\Reset~input\ : fiftyfivenm_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	listen_to_nsleep_signal => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_Reset,
	o => \Reset~input_o\);

-- Location: UNVM_X0_Y22_N40
\~QUARTUS_CREATED_UNVM~\ : fiftyfivenm_unvm
-- pragma translate_off
GENERIC MAP (
	addr_range1_end_addr => -1,
	addr_range1_offset => -1,
	addr_range2_end_addr => -1,
	addr_range2_offset => -1,
	addr_range3_offset => -1,
	is_compressed_image => "false",
	is_dual_boot => "false",
	is_eram_skip => "false",
	max_ufm_valid_addr => -1,
	max_valid_addr => -1,
	min_ufm_valid_addr => -1,
	min_valid_addr => -1,
	part_name => "quartus_created_unvm",
	reserve_block => "true")
-- pragma translate_on
PORT MAP (
	nosc_ena => \~QUARTUS_CREATED_GND~I_combout\,
	xe_ye => \~QUARTUS_CREATED_GND~I_combout\,
	se => \~QUARTUS_CREATED_GND~I_combout\,
	busy => \~QUARTUS_CREATED_UNVM~~busy\);

-- Location: ADCBLOCK_X25_Y34_N0
\~QUARTUS_CREATED_ADC1~\ : fiftyfivenm_adcblock
-- pragma translate_off
GENERIC MAP (
	analog_input_pin_mask => 0,
	clkdiv => 1,
	device_partname_fivechar_prefix => "none",
	is_this_first_or_second_adc => 1,
	prescalar => 0,
	pwd => 1,
	refsel => 0,
	reserve_block => "true",
	testbits => 66,
	tsclkdiv => 1,
	tsclksel => 0)
-- pragma translate_on
PORT MAP (
	soc => \~QUARTUS_CREATED_GND~I_combout\,
	usr_pwd => VCC,
	tsen => \~QUARTUS_CREATED_GND~I_combout\,
	chsel => \~QUARTUS_CREATED_ADC1~_CHSEL_bus\,
	eoc => \~QUARTUS_CREATED_ADC1~~eoc\);

-- Location: ADCBLOCK_X25_Y33_N0
\~QUARTUS_CREATED_ADC2~\ : fiftyfivenm_adcblock
-- pragma translate_off
GENERIC MAP (
	analog_input_pin_mask => 0,
	clkdiv => 1,
	device_partname_fivechar_prefix => "none",
	is_this_first_or_second_adc => 2,
	prescalar => 0,
	pwd => 1,
	refsel => 0,
	reserve_block => "true",
	testbits => 66,
	tsclkdiv => 1,
	tsclksel => 0)
-- pragma translate_on
PORT MAP (
	soc => \~QUARTUS_CREATED_GND~I_combout\,
	usr_pwd => VCC,
	tsen => \~QUARTUS_CREATED_GND~I_combout\,
	chsel => \~QUARTUS_CREATED_ADC2~_CHSEL_bus\,
	eoc => \~QUARTUS_CREATED_ADC2~~eoc\);
END structure;


