library ieee;
use ieee.std_logic_1164.all;

entity EXMEM is 
    port(
		clk : in std_logic;
		clr_EXMEM: in std_logic;
		wr_EXMEM, EXMEM_match : in std_logic;
		EXMEM_indexout : in integer;
		EXMEM_opcode : in std_logic_vector(3 downto 0);
      EXMEM_inc, EXMEM_PC, EXMEM_RF_D1, EXMEM_LMSM, EXMEM_RF_D2, EXMEM_ALU_C, EXMEM_SE6, EXMEM_SE9 : in std_logic_vector(15 downto 0);
		EXMEM_11_9, EXMEM_8_6, EXMEM_5_3, EXMEM_dec : in std_logic_vector(2 downto 0);
		EXMEM_8_0 : in std_logic_vector(8 downto 0);
		EXMEM_5_0 : in std_logic_vector(5 downto 0);
		EXMEM_cy, EXMEM_z : in std_logic;
		EXMEM_opcode_Op : out std_logic_vector(3 downto 0);
		EXMEM_inc_Op, EXMEM_PC_Op, EXMEM_RF_D1_Op, EXMEM_LMSM_Op, EXMEM_RF_D2_Op, EXMEM_ALU_C_Op, EXMEM_SE6_Op, EXMEM_SE9_Op : out std_logic_vector(15 downto 0);
		EXMEM_11_9_Op, EXMEM_8_6_Op, EXMEM_5_3_Op, EXMEM_dec_Op : out std_logic_vector(2 downto 0);
		EXMEM_8_0_Op : out std_logic_vector(8 downto 0);
		EXMEM_5_0_Op : out std_logic_vector(5 downto 0);
		EXMEM_cy_Op, EXMEM_z_Op : out std_logic;
		EXMEM_indexout_Op : out integer;
		EXMEM_match_Op : out std_logic
		);
end EXMEM;

architecture arch of EXMEM is

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

opcode: reg4 port map (wr=>wr_EXMEM, clk=>clk, data=>EXMEM_opcode, Op=>EXMEM_opcode_Op, clr=>clr_EXMEM);
inc: reg port map (wr=>wr_EXMEM, clk=>clk, data=>EXMEM_inc, Op=>EXMEM_inc_Op, clr=>clr_EXMEM);
PC: reg port map (wr=>wr_EXMEM, clk=>clk, data=>EXMEM_PC, Op=>EXMEM_PC_Op, clr=>clr_EXMEM);
RF_D1: reg port map (wr=>wr_EXMEM, clk=>clk, data=>EXMEM_RF_D1, Op=>EXMEM_RF_D1_Op, clr=>clr_EXMEM);
LMSM: reg port map (wr=>wr_EXMEM, clk=>clk, data=>EXMEM_LMSM, Op=>EXMEM_LMSM_Op, clr=>clr_EXMEM);
RF_D2: reg port map (wr=>wr_EXMEM, clk=>clk, data=>EXMEM_RF_D2, Op=>EXMEM_RF_D2_Op, clr=>clr_EXMEM);
ALU_C: reg port map (wr=>wr_EXMEM, clk=>clk, data=>EXMEM_ALU_C, Op=>EXMEM_ALU_C_Op, clr=>clr_EXMEM);
SE6: reg port map (wr=>wr_EXMEM, clk=>clk, data=>EXMEM_SE6, Op=>EXMEM_SE6_Op, clr=>clr_EXMEM);
SE9: reg port map (wr=>wr_EXMEM, clk=>clk, data=>EXMEM_SE9, Op=>EXMEM_SE9_Op, clr=>clr_EXMEM);
dec: reg3 port map (wr=>wr_EXMEM, clk=>clk, data=>EXMEM_dec, Op=>EXMEM_dec_Op, clr=>clr_EXMEM);
eleven_nine: reg3 port map (wr=>wr_EXMEM, clk=>clk, data=>EXMEM_11_9, Op=>EXMEM_11_9_Op, clr=>clr_EXMEM);
eight_six: reg3 port map (wr=>wr_EXMEM, clk=>clk, data=>EXMEM_8_6, Op=>EXMEM_8_6_Op, clr=>clr_EXMEM);
five_three: reg3 port map (wr=>wr_EXMEM, clk=>clk, data=>EXMEM_5_3, Op=>EXMEM_5_3_Op, clr=>clr_EXMEM);
eight_zero: reg9 port map (wr=>wr_EXMEM, clk=>clk, data=>EXMEM_8_0, Op=>EXMEM_8_0_Op, clr=>clr_EXMEM);
five_zero: reg6 port map (wr=>wr_EXMEM, clk=>clk, data=>EXMEM_5_0, Op=>EXMEM_5_0_Op, clr=>clr_EXMEM);
match: reg1 port map (wr=>wr_EXMEM, clk=>clk, data=>EXMEM_match, Op=>EXMEM_match_Op, clr=>clr_EXMEM);
indexout: reg1_int port map (wr=>wr_EXMEM, clk=>clk, data=>EXMEM_indexout, Op=>EXMEM_indexout_Op, clr=>clr_EXMEM);

end arch;