library ieee;
use ieee.std_logic_1164.all;

entity RREX is 
    port(
		clk : in std_logic;
		clr_RREX: in std_logic;
		wr_RREX, RREX_match : in std_logic;
		RREX_indexout : in integer;
		RREX_opcode : in std_logic_vector(3 downto 0);
      RREX_inc, RREX_PC, RREX_RF_D1, RREX_LMSM, RREX_RF_D2 : in std_logic_vector(15 downto 0);
		RREX_11_9, RREX_8_6, RREX_5_3, RREX_dec : in std_logic_vector(2 downto 0);
		RREX_8_0 : in std_logic_vector(8 downto 0);
		RREX_5_0 : in std_logic_vector(5 downto 0);
		RREX_opcode_Op : out std_logic_vector(3 downto 0);
		RREX_inc_Op, RREX_PC_Op, RREX_RF_D1_Op, RREX_LMSM_Op, RREX_RF_D2_Op : out std_logic_vector(15 downto 0);
		RREX_11_9_Op, RREX_8_6_Op, RREX_5_3_Op, RREX_dec_Op : out std_logic_vector(2 downto 0);
		RREX_8_0_Op : out std_logic_vector(8 downto 0);
		RREX_5_0_Op : out std_logic_vector(5 downto 0);
		RREX_indexout_Op : out integer;
		RREX_match_Op : out std_logic
		);
end RREX;

architecture arch of RREX is

	--1-bit Register
	component reg1 is 
		port(
			wr: in std_logic;
			clk: in std_logic;
			clr: in std_logic;
			data: in std_logic;
			Op: out std_logic
		);
	end component;

	--1-bit Register-Integer
	component reg1_int is 
		port(
			wr: in std_logic;
			clk: in std_logic;
			clr: in std_logic;
			data: in integer;
			Op: out integer
		);
	end component;

	--3-bit Register
	component reg3 is 
		port(
			wr: in std_logic;
			clk: in std_logic;
			clr: in std_logic;
			data: in std_logic_vector(2 downto 0);
			Op: out std_logic_vector(2 downto 0)
		);
	end component;
	
	--4-bit Register
	component reg4 is 
		port(
			wr: in std_logic;
			clk: in std_logic;
			clr: in std_logic;
			data: in std_logic_vector(3 downto 0);
			Op: out std_logic_vector(3 downto 0)
		);
	end component;
	
	--6-bit Register
	component reg6 is 
		port(
			wr: in std_logic;
			clk: in std_logic;
			clr: in std_logic;
			data: in std_logic_vector(5 downto 0);
			Op: out std_logic_vector(5 downto 0)
		);
	end component;
	
	--9-bit Register
	component reg9 is 
		port(
			wr: in std_logic;
			clk: in std_logic;
			clr: in std_logic;
			data: in std_logic_vector(8 downto 0);
			Op: out std_logic_vector(8 downto 0)
		);
	end component;
	
	--16-bit Register
	component reg is
		port(
			wr: in std_logic;
			clk: in std_logic;
			clr: in std_logic;
			data: in std_logic_vector(15 downto 0);
			Op: out std_logic_vector(15 downto 0)
		);
	end component;
		
begin

opcode: reg4 port map (wr=>wr_RREX, clk=>clk, data=>RREX_opcode, Op=>RREX_opcode_Op, clr=>clr_RREX);
inc: reg port map (wr=>wr_RREX, clk=>clk, data=>RREX_inc, Op=>RREX_inc_Op, clr=>clr_RREX);
PC: reg port map (wr=>wr_RREX, clk=>clk, data=>RREX_PC, Op=>RREX_PC_Op, clr=>clr_RREX);
RF_D1: reg port map (wr=>wr_RREX, clk=>clk, data=>RREX_RF_D1, Op=>RREX_RF_D1_Op, clr=>clr_RREX);
LMSM: reg port map (wr=>wr_RREX, clk=>clk, data=>RREX_LMSM, Op=>RREX_LMSM_Op, clr=>clr_RREX);
RF_D2: reg port map (wr=>wr_RREX, clk=>clk, data=>RREX_RF_D2, Op=>RREX_RF_D2_Op, clr=>clr_RREX);
dec: reg3 port map (wr=>wr_RREX, clk=>clk, data=>RREX_dec, Op=>RREX_dec_Op, clr=>clr_RREX);
eleven_nine: reg3 port map (wr=>wr_RREX, clk=>clk, data=>RREX_11_9, Op=>RREX_11_9_Op, clr=>clr_RREX);
eight_six: reg3 port map (wr=>wr_RREX, clk=>clk, data=>RREX_8_6, Op=>RREX_8_6_Op, clr=>clr_RREX);
five_three: reg3 port map (wr=>wr_RREX, clk=>clk, data=>RREX_5_3, Op=>RREX_5_3_Op, clr=>clr_RREX);
eight_zero: reg9 port map (wr=>wr_RREX, clk=>clk, data=>RREX_8_0, Op=>RREX_8_0_Op, clr=>clr_RREX);
five_zero: reg6 port map (wr=>wr_RREX, clk=>clk, data=>RREX_5_0, Op=>RREX_5_0_Op, clr=>clr_RREX);
match: reg1 port map (wr=>wr_RREX, clk=>clk, data=>RREX_match, Op=>RREX_match_Op, clr=>clr_RREX);
indexout: reg1_int port map (wr=>wr_RREX, clk=>clk, data=>RREX_indexout, Op=>RREX_indexout_Op, clr=>clr_RREX);

end arch;