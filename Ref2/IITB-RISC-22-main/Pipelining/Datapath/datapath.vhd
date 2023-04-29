library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;

entity datapath is
    port(
		wr_PC, wr_IR, wr_RF, wr_RF_r7, wr_inc, wr_DMem, wr_cy, wr_z : in std_logic;
		wr_IFID, wr_IDRR, wr_RREX, wr_EXMEM, wr_MEMWB : in std_logic;
		clr_IFID, clr_IDRR, clr_RREX, clr_EXMEM, clr_MEMWB: in std_logic;
		select_Mux_RF_D3, dec, select_Mux_PC : in std_logic_vector(2 downto 0);
		select_Mux_LUT, select_Mux_ALU_B, select_Mux_ALU2_B, select_ALU, select_ALU2, select_Mux_RF_A3 : in std_logic_vector(1 downto 0);
		select_Mux_ALU_A, select_Mux_ALU2_A, select_Mux_RF_A1, select_Mux_RF_A2, select_Mux_DMem_A, select_Mux_DMem_Din : in std_logic;
		select_Mux_LMSM : in std_logic;
		clk, reset : in std_logic;
		cy_in, z_in : in std_logic;
		
		cy_out, z_out : out std_logic;
		IDRR_opcode, RREX_opcode, EXMEM_opcode, MEMWB_opcode : out std_logic_vector(3 downto 0);
		IDRR_5_0, RREX_5_0 : out std_logic_vector(5 downto 0);
		haz_EX, haz_MEM, haz_WB, haz_BEQ, haz_JAL, haz_JLR, haz_JRI : out std_logic;
		IDRR_11_9, IDRR_8_6, RREX_11_9: out std_logic_vector(2 downto 0)
		);
end datapath;

architecture arch of datapath is
	
	--1-bit Register
	component reg1 is 
		port(
			wr: in std_logic;
			clk: in std_logic;
			data: in std_logic;
			clr: in std_logic;
			Op: out std_logic
		);
	end component;
	
	--16-bit Register
	component reg is
		port(
			wr: in std_logic;
			clk: in std_logic;
			data: in std_logic_vector(15 downto 0);
			clr: in std_logic;
			Op: out std_logic_vector(15 downto 0)
		);
	end component;
	
	--IFID
	component IFID is
		port(
			clk : in std_logic;
			clr_IFID: in std_logic;
			wr_IFID, IFID_match : in std_logic;
			IFID_indexout : in integer;
			IFID_inc, IFID_PC, IFID_IMem : in std_logic_vector(15 downto 0);
			IFID_inc_Op, IFID_PC_Op, IFID_IMem_Op : out std_logic_vector(15 downto 0);
			IFID_indexout_Op : out integer;
			IFID_match_Op : out std_logic
		);
	end component;
	
	--IDRR
	component IDRR is
		port(
			clk : in std_logic;
			clr_IDRR: in std_logic;
			wr_IDRR, IDRR_match : in std_logic;
			IDRR_indexout : in integer;
			IDRR_opcode : in std_logic_vector(3 downto 0);
			IDRR_inc, IDRR_PC : in std_logic_vector(15 downto 0);
			IDRR_11_9, IDRR_8_6, IDRR_5_3 : in std_logic_vector(2 downto 0);
			IDRR_8_0 : in std_logic_vector(8 downto 0);
			IDRR_5_0 : in std_logic_vector(5 downto 0);
			IDRR_opcode_Op : out std_logic_vector(3 downto 0);
			IDRR_inc_Op, IDRR_PC_Op : out std_logic_vector(15 downto 0);
			IDRR_11_9_Op, IDRR_8_6_Op, IDRR_5_3_Op : out std_logic_vector(2 downto 0);
			IDRR_8_0_Op : out std_logic_vector(8 downto 0);
			IDRR_5_0_Op : out std_logic_vector(5 downto 0);
			IDRR_indexout_Op : out integer;
			IDRR_match_Op : out std_logic
		);
	end component;
	
	--RREX
	component RREX is
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
	end component;
	
	--EXMEM
	component EXMEM is 
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
	end component;
	
	--MEMWB
	component MEMWB is
		port(
			clk : in std_logic;
			clr_MEMWB: in std_logic;
			wr_MEMWB : in std_logic;
			MEMWB_opcode : in std_logic_vector(3 downto 0);
			MEMWB_inc, MEMWB_PC, MEMWB_RF_D2, MEMWB_ALU_C, MEMWB_ALU2_C, MEMWB_DMem_D : in std_logic_vector(15 downto 0);
			MEMWB_11_9, MEMWB_8_6, MEMWB_5_3, MEMWB_dec : in std_logic_vector(2 downto 0);
			MEMWB_8_0 : in std_logic_vector(8 downto 0);
			MEMWB_5_0 : in std_logic_vector(5 downto 0);
			MEMWB_cy, MEMWB_z : in std_logic;
			MEMWB_opcode_Op : out std_logic_vector(3 downto 0);
			MEMWB_inc_Op, MEMWB_PC_Op, MEMWB_RF_D2_Op, MEMWB_ALU_C_Op, MEMWB_ALU2_C_Op, MEMWB_DMem_D_Op : out std_logic_vector(15 downto 0);
			MEMWB_11_9_Op, MEMWB_8_6_Op, MEMWB_5_3_Op, MEMWB_dec_Op : out std_logic_vector(2 downto 0);
			MEMWB_8_0_Op : out std_logic_vector(8 downto 0);
			MEMWB_5_0_Op : out std_logic_vector(5 downto 0);
			MEMWB_cy_Op, MEMWB_z_Op : out std_logic
		);
	end component;
	
	--Register Bank
	component register_bank is
		port(
			Add1: in std_logic_vector(2 downto 0);
			Add2: in std_logic_vector(2 downto 0);
			Add3: in std_logic_vector(2 downto 0);
			D3: in std_logic_vector(15 downto 0);
			r7_in: in std_logic_vector(15 downto 0);
			wr: in std_logic;
			wr_r7: in std_logic;
			clk: in std_logic;
			clr_rf: in std_logic;
			D1: out std_logic_vector(15 downto 0);
			D2: out std_logic_vector(15 downto 0);
			r7_out: out std_logic_vector(15 downto 0)
		);
	end component;
	
	--Branch Look-up Table
	component BranchLUT is
		port(
			clk, history: in std_logic;
			indexin: in integer;
			PC, EXMEM_PC_Op, IDRR_PC_Op, RREX_PC_Op: in std_logic_vector(15 downto 0);
			ALU2_C, RF_D2_Op, ALU_C: in std_logic_vector(15 downto 0);
			EXMEM_opcode, IDRR_opcode, RREX_opcode: in std_logic_vector(3 downto 0);
			Aout: out std_logic_vector(15 downto 0);
			match: out std_logic;
			indexout: out integer
		);	
	end component;
	
	--BEQ Hazard Block
	component Hazard_BEQ is
		port(
			match, exmem_z: in std_logic;
			indexout: in integer;
			EXMEM_opcode: in std_logic_vector(3 downto 0);
			
			history, haz_BEQ: out std_logic;
			indexin: out integer
		);
	end component;
	
	--JAL Hazard Block
	component Hazard_JAL is
		port(
			match: in std_logic;
			indexout: in integer;
			EXMEM_opcode: in std_logic_vector(3 downto 0);
			
			history, haz_JAL: out std_logic;
			indexin: out integer
		);
	end component;
	
	--JLR Hazard Block
	component Hazard_JLR is
		port(
			match: in std_logic;
			indexout: in integer;
			IDRR_opcode: in std_logic_vector(3 downto 0);
			RF_D2: in std_logic_vector(15 downto 0);
			IFID_PC_Op: in std_logic_vector(15 downto 0);
			
			history, haz_JLR: out std_logic;
			indexin: out integer
		);
	end component;
	
	--JRI Hazard Block
	component Hazard_JRI is
		port(
			match: in std_logic;
			indexout: in integer;
			RREX_opcode: in std_logic_vector(3 downto 0);
			ALU_C: in std_logic_vector(15 downto 0);
			IDRR_PC_Op: in std_logic_vector(15 downto 0);
			
			history, haz_JRI: out std_logic;
			indexin: out integer
		);
	end component;
	
	--EX Hazard Block
	component Hazard_EX is
    port(
        RREX_opcode_Op: in std_logic_vector(3 downto 0);
		  RREX_11_9_Op, RREX_8_6_Op, RREX_5_3_Op, RREX_2_0_Op: in std_logic_vector(2 downto 0);
		  cy_in, z_in: in std_logic;
		  
        haz_EX: out std_logic
		);
	end component;
	
	--MEM Hazard Block
	component Hazard_MEM is
    port(
        EXMEM_opcode_Op: in std_logic_vector(3 downto 0);
		  EXMEM_11_9_Op: in std_logic_vector(2 downto 0);
		  
        haz_MEM: out std_logic	
		);
	end component;
	
	--WB Hazard Block
	component Hazard_WB is
    port(
        MEMWB_opcode_Op: in std_logic_vector(3 downto 0);
		  MEMWB_11_9_Op: in std_logic_vector(2 downto 0);
		  
        haz_WB: out std_logic
		);
	end component;
	
	--Instruction Memory
	component rom is
		port(
			A: in std_logic_vector(15 downto 0);
			clr: in std_logic;
			Dout: out std_logic_vector(15 downto 0)
		);
	end component;
	
	--Data Memory
	component ram is
		port(
			wr: in std_logic;
			A: in std_logic_vector(15 downto 0);
			Din: in std_logic_vector(15 downto 0);
			clk, clr: in std_logic;
			Dout: out std_logic_vector(15 downto 0)
		);
	end component;
	
	--ALU
	component alu is
		port (
			A: in std_logic_vector(15 downto 0);
			B: in std_logic_vector(15 downto 0);
			S: in std_logic_vector(1 downto 0);
			--clk: in std_logic;
			Op: out std_logic_vector(15 downto 0);
			carry: out std_logic;
			zero: out std_logic
		);
	end component;
	
	--Incrementer
	component incr is
		port (
			A: in std_logic_vector(15 downto 0);
			wr: in std_logic;
			Op: out std_logic_vector(15 downto 0)
		);
	end component;
	
	--Incrementer for LMSM
	component incr_LMSM is
		port (
			A: in std_logic_vector(15 downto 0);
			Op: out std_logic_vector(15 downto 0)
		);
	end component;
	
	--Sign Extender-6
	component bitextender6 is
		port (
			A: in std_logic_vector(5 downto 0);
			Op: out std_logic_vector(15 downto 0)
		);
	end component;
	
	--Sign Extender-9
	component bitextender9 is
		port (
			A: in std_logic_vector(8 downto 0);
			Op: out std_logic_vector(15 downto 0)
		);
	end component;
	
	--1-bit Shifter
	component bit1shift is
		port(
			A: in std_logic_vector(15 downto 0);
			Op: out std_logic_vector(15 downto 0)
		);
	end component;
	
	--7-bit Shifter
	component bit7shift is
		port(
			A: in std_logic_vector(8 downto 0);
			Op: out std_logic_vector(15 downto 0)
		);
	end component;
	
	--Mux 2x1 3-bit
	component mux21_3 is
		port (
			A0: in std_logic_vector(2 downto 0);
			A1: in std_logic_vector(2 downto 0);
			S: in std_logic;
			Op: out std_logic_vector(2 downto 0)
		);
	end component;

	--Mux 2x1
	component mux21 is
		port(
			A0: in std_logic_vector(15 downto 0);
			A1: in std_logic_vector(15 downto 0);
			S: in std_logic;
			Op: out std_logic_vector(15 downto 0)
		);
	end component;
	
	--Mux 4x1 1-bit
	component mux41_1 is
		port (
			A0: in std_logic;
			A1: in std_logic;
			A2: in std_logic;
			A3: in std_logic;
			S: in std_logic_vector(1 downto 0);
			Op: out std_logic
		);
	end component;
  
	--Mux 4x1 3-bit
	component mux41_3 is
		port (
			A0: in std_logic_vector(2 downto 0);
			A1: in std_logic_vector(2 downto 0);
			A2: in std_logic_vector(2 downto 0);
			A3: in std_logic_vector(2 downto 0);
			S: in std_logic_vector(1 downto 0);
			Op: out std_logic_vector(2 downto 0)
		);
	end component;
  
	--Mux 4x1 Integer
	component mux41_int is
		port(
			A0: in integer;
			A1: in integer;
			A2: in integer;
			A3: in integer;
			S: in std_logic_vector(1 downto 0);
			Op: out integer
		);
	end component;
	
	--Mux 4x1 16-bit
	component mux41 is
		port(
			A0: in std_logic_vector(15 downto 0);
			A1: in std_logic_vector(15 downto 0);
			A2: in std_logic_vector(15 downto 0);
			A3: in std_logic_vector(15 downto 0);
			S: in std_logic_vector(1 downto 0);
			Op: out std_logic_vector(15 downto 0)
		);
	end component;
	
	--Mux 8x1 3-bit
	component mux81_3 is
		port (
			A0: in std_logic_vector(2 downto 0);
			A1: in std_logic_vector(2 downto 0);
			A2: in std_logic_vector(2 downto 0);
			A3: in std_logic_vector(2 downto 0);
			A4: in std_logic_vector(2 downto 0);
			A5: in std_logic_vector(2 downto 0);
			A6: in std_logic_vector(2 downto 0);
			A7: in std_logic_vector(2 downto 0);
			S: in std_logic_vector(2 downto 0);
			Op: out std_logic_vector(2 downto 0)
		);
	end component;
	
	--Mux 8x1
	component mux81 is 
		port(
			A0: in std_logic_vector(15 downto 0);
			A1: in std_logic_vector(15 downto 0);
			A2: in std_logic_vector(15 downto 0);
			A3: in std_logic_vector(15 downto 0);
			A4: in std_logic_vector(15 downto 0);
			A5: in std_logic_vector(15 downto 0);
			A6: in std_logic_vector(15 downto 0);
			A7: in std_logic_vector(15 downto 0);
			S: in std_logic_vector(2 downto 0);
			Op: out std_logic_vector(15 downto 0)
		);
   end component;
   
	--Forwarding block
	component fwd_logic is
	port(
			IDRR_opcode, RREX_opcode, EXMEM_opcode, MEMWB_opcode: in std_logic_vector(3 downto 0);
			IDRR_11_9, IDRR_8_6, RREX_8_6, RREX_5_3, EXMEM_11_9, MEMWB_11_9, MEMWB_8_6, MEMWB_5_3: in std_logic_vector(2 downto 0);
			select_Mux_forward1, select_Mux_forward2: out std_logic_vector(1 downto 0)
			);
   end component;
  
  
  signal DMem_A, DMem_Din, DMem_Dout : std_logic_vector(15 downto 0); 
  signal PC_in, PC_Op, branch_add, branch : std_logic_vector(15 downto 0); 
  signal IMem_Op, IR_Op : std_logic_vector(15 downto 0); 
  signal RF_D3, r7_Op, RF_D1_Op, RF_D2_Op : std_logic_vector(15 downto 0); 
  signal forward1, forward2 : std_logic_vector(15 downto 0);
  signal S7_Op, S1_Op : std_logic_vector(15 downto 0); 
  signal inc_Op, inc_LMSM_Op : std_logic_vector(15 downto 0); 
  signal ALU_A, ALU_B, ALU_C : std_logic_vector(15 downto 0); 
  signal ALU2_A, ALU2_B, ALU2_C : std_logic_vector(15 downto 0); 
  signal SE6_Op, SE9_Op : std_logic_vector(15 downto 0); 
  signal RREX_LMSM : std_logic_vector(15 downto 0);
  signal history_BEQ, history_JAL, history_JLR, history_JRI : std_logic;
  signal indexin_BEQ, indexin_JAL, indexin_JLR, indexin_JRI : integer;
  
  
  signal IFID_inc_Op, IFID_PC_Op, IFID_IMem_Op : std_logic_vector(15 downto 0);
  signal IFID_match_Op : std_logic;
  signal IFID_indexout_Op : integer;
  
  signal IDRR_opcode_Op : std_logic_vector(3 downto 0);
  signal IDRR_inc_Op, IDRR_PC_Op : std_logic_vector(15 downto 0);
  signal IDRR_11_9_Op, IDRR_8_6_Op, IDRR_5_3_Op : std_logic_vector(2 downto 0);
  signal IDRR_8_0_Op : std_logic_vector(8 downto 0);
  signal IDRR_5_0_Op : std_logic_vector(5 downto 0);
  signal IDRR_match_Op : std_logic;
  signal IDRR_indexout_Op : integer;
  
  signal RREX_opcode_Op : std_logic_vector(3 downto 0);
  signal RREX_inc_Op, RREX_PC_Op, RREX_RF_D1_Op, RREX_LMSM_Op, RREX_RF_D2_Op : std_logic_vector(15 downto 0);
  signal RREX_11_9_Op, RREX_8_6_Op, RREX_5_3_Op, RREX_dec_Op : std_logic_vector(2 downto 0);
  signal RREX_8_0_Op : std_logic_vector(8 downto 0);
  signal RREX_5_0_Op : std_logic_vector(5 downto 0);
  signal RREX_match_Op : std_logic;
  signal RREX_indexout_Op : integer;
  
  signal EXMEM_opcode_Op : std_logic_vector(3 downto 0);
  signal EXMEM_inc_Op, EXMEM_PC_Op, EXMEM_RF_D1_Op, EXMEM_LMSM_Op, EXMEM_RF_D2_Op, EXMEM_SE6_Op, EXMEM_SE9_Op, EXMEM_ALU_C_Op : std_logic_vector(15 downto 0);
  signal EXMEM_11_9_Op, EXMEM_8_6_Op, EXMEM_5_3_Op, EXMEM_dec_Op : std_logic_vector(2 downto 0);
  signal EXMEM_8_0_Op : std_logic_vector(8 downto 0);
  signal EXMEM_5_0_Op : std_logic_vector(5 downto 0);
  signal EXMEM_cy_Op, EXMEM_z_Op : std_logic;
  signal EXMEM_match_Op : std_logic;
  signal EXMEM_indexout_Op : integer;
  
  signal MEMWB_opcode_Op : std_logic_vector(3 downto 0);
  signal MEMWB_inc_Op, MEMWB_PC_Op, MEMWB_RF_D2_Op, MEMWB_ALU_C_Op, MEMWB_ALU2_C_Op, MEMWB_DMem_D_Op : std_logic_vector(15 downto 0);
  signal MEMWB_11_9_Op, MEMWB_8_6_Op, MEMWB_5_3_Op, MEMWB_dec_Op : std_logic_vector(2 downto 0);
  signal MEMWB_8_0_Op : std_logic_vector(8 downto 0);
  signal MEMWB_5_0_Op : std_logic_vector(5 downto 0);
  signal MEMWB_cy_Op, MEMWB_z_Op : std_logic;
  
  signal RF_A1, RF_A2, RF_A3 : std_logic_vector(2 downto 0);
  signal match, history_Op, cy, cy_Op, z, z_Op, cy_2, z_2 : std_logic;
  signal haz_EX_Op, haz_MEM_Op, haz_WB_Op, haz_BEQ_Op, haz_JAL_Op, haz_JLR_Op, haz_JRI_Op : std_logic;
  signal indexout, indexin_Op : integer;
  
  signal select_Mux_forward1, select_Mux_forward2: std_logic_vector(1 downto 0);

begin

--PC
PC: reg port map (wr=>wr_PC, clk=>clk, data=>PC_in, Op=>PC_Op, clr=>reset);

--Instruction Memory
IMem: rom port map (A=>PC_Op, clr=>reset, Dout=>IMem_Op);

--Incrementer
inc: incr port map (wr=>wr_inc, A=>PC_Op, Op=>inc_Op);

--Mux-LUT-indexin
Mux_LUT_indexin: mux41_int port map(A0=>indexin_BEQ, A1=>indexin_JAL, A2=>indexin_JLR, A3=>indexin_JRI, S=>select_Mux_LUT, Op=>indexin_Op); 

--Mux-LUT-history
Mux_LUT_history: mux41_1 port map(A0=>history_BEQ, A1=>history_JAL, A2=>history_JLR, A3=>history_JRI, S=>select_Mux_LUT, Op=>history_Op); 

--Branch Look-up Table
lut: BranchLUT port map (
								clk=>clk,
								history=>history_Op,
								indexin=>indexin_Op,
								PC=>PC_Op, 
								EXMEM_PC_Op=>EXMEM_PC_Op, 
								IDRR_PC_Op=>IDRR_PC_Op, 
								RREX_PC_Op=>RREX_PC_Op,
								ALU2_C=>ALU2_C, 
								RF_D2_Op=>RF_D2_Op, 
								ALU_C=>ALU_C,
								EXMEM_opcode=>EXMEM_opcode_Op, 
								IDRR_opcode=>IDRR_opcode_Op, 
								RREX_opcode=>RREX_opcode_Op,
								Aout=>branch_add,
								match=>match,
								indexout=>indexout
								);
								
--Mux-PC
Mux_PC: mux21 port map (A0=>inc_Op, A1=>branch_add, S=>match, Op=>branch);

--Mux-PC-2
Mux_PC_2: mux81 port map (A0=>branch, A1=>ALU2_C, A2=>RF_D2_Op, A3=>ALU_C, A4=>RF_D3, A5=>DMem_Dout, A6=>"0000000000000000", A7=>"0000000000000000", S=>select_Mux_PC, Op=>PC_in);

--IF/ID Register
IF_ID: IFID port map (
							clk=>clk,
							clr_IFID=>(clr_IFID or reset),
							wr_IFID=>wr_IFID,
							IFID_match=>match, IFID_match_Op=>IFID_match_Op, 
							IFID_inc=>inc_Op, IFID_inc_Op=>IFID_inc_Op,
							IFID_PC=>PC_Op, IFID_PC_Op=>IFID_PC_Op,
							IFID_IMem=>IMem_Op, IFID_IMem_Op=>IFID_IMem_Op,
							IFID_indexout=>indexout, IFID_indexout_Op=>IFID_indexout_Op
							);
							
--IR
IR: reg port map (wr=>wr_IR, clk=>clk, data=>IFID_IMem_Op, Op=>IR_Op, clr=>reset);

--ID/RR Register
ID_RR: IDRR port map (
							clk=>clk,
							clr_IDRR=>(clr_IDRR or reset),
							wr_IDRR=>wr_IDRR,
							IDRR_match=>IFID_match_Op, IDRR_match_Op=>IDRR_match_Op, 
							IDRR_opcode=>IR_Op(15 downto 12), IDRR_opcode_Op=>IDRR_opcode_Op,
							IDRR_inc=>IFID_inc_Op, IDRR_inc_Op=>IDRR_inc_Op, 
							IDRR_11_9=>IR_Op(11 downto 9), IDRR_11_9_Op=>IDRR_11_9_Op, 
							IDRR_8_6=>IR_Op(8 downto 6), IDRR_8_6_Op=>IDRR_8_6_Op,
							IDRR_PC=>IFID_PC_Op, IDRR_PC_Op=>IDRR_PC_Op,
							IDRR_8_0=>IR_Op(8 downto 0), IDRR_8_0_Op=>IDRR_8_0_Op,
							IDRR_5_0=>IR_Op(5 downto 0), IDRR_5_0_Op=>IDRR_5_0_Op,
							IDRR_5_3=>IR_Op(5 downto 3), IDRR_5_3_Op=>IDRR_5_3_Op,
							IDRR_indexout=>IFID_indexout_Op, IDRR_indexout_Op=>IDRR_indexout_Op
							);
							
--Hazard_JLR
JLR_haz: Hazard_JLR port map (match=>IDRR_match_Op, indexout=>IDRR_indexout_Op, IDRR_opcode=>IDRR_opcode_Op, RF_D2=>RF_D2_Op, IFID_PC_Op=>IFID_PC_Op, history=>history_JLR, haz_JLR=>haz_JLR_Op, indexin=>indexin_JLR);

--Mux_RF-A1
Mux_RF_A1: mux21_3 port map (A0=>IDRR_11_9_Op, A1=>IDRR_8_6_Op, S=>select_Mux_RF_A1, Op=>RF_A1);

--Mux_RF-A2
Mux_RF_A2: mux21_3 port map (A0=>IDRR_8_6_Op, A1=>dec, S=>select_Mux_RF_A2, Op=>RF_A2);

--RF
RF: register_bank port map (
							Add1=>RF_A1, 
							Add2=>RF_A2, 
							Add3=>RF_A3, 
							D3=>RF_D3, 
							r7_in=>IDRR_PC_Op, 
							wr=>wr_RF, 
							wr_r7=>wr_RF_r7, 
							clk=>clk, 
							clr_rf=>reset,
							D1=>RF_D1_Op, 
							D2=>RF_D2_Op,
							r7_out=>r7_Op
							);
							
--Forwarding Mux-1
forwardingmux1: mux41 port map(A0=>RF_D1_Op, A1=>ALU_C, A2=>DMem_Dout, A3=>RF_D3, S=>select_Mux_forward1, Op=>forward1); 

--Forwarding Mux-2
forwardingmux2: mux41 port map(A0=>RF_D2_Op, A1=>ALU_C, A2=>DMem_Dout, A3=>RF_D3, S=>select_Mux_forward2, Op=>forward2); 

--LMSM Mux-1
LMSMmux: mux21 port map (A0=>forward1, A1=>inc_LMSM_Op, S=>select_Mux_LMSM, Op=>RREX_LMSM);

--RR/EX Register
RR_EX: RREX port map (
							clk=>clk,
							clr_RREX=>(clr_RREX or reset),
							wr_RREX=>wr_RREX,
							RREX_match=>IDRR_match_Op, RREX_match_Op=>RREX_match_Op, 
							RREX_opcode=>IDRR_opcode_Op, RREX_opcode_Op=>RREX_opcode_Op,
							RREX_PC=>IDRR_PC_Op, RREX_PC_Op=>RREX_PC_Op,
							RREX_11_9=>IDRR_11_9_Op, RREX_11_9_Op=>RREX_11_9_Op, 
							RREX_8_6=>IDRR_8_6_Op, RREX_8_6_Op=>RREX_8_6_Op,
							RREX_inc=>IDRR_inc_Op, RREX_inc_Op=>RREX_inc_Op,
							RREX_RF_D1=>forward1, RREX_RF_D1_Op=>RREX_RF_D1_Op,
							RREX_LMSM=>RREX_LMSM, RREX_LMSM_Op=>RREX_LMSM_Op,
							RREX_dec=>dec, RREX_dec_Op=>RREX_dec_Op,
							RREX_RF_D2=>forward2, RREX_RF_D2_Op=>RREX_RF_D2_Op,
							RREX_8_0=>IDRR_8_0_Op, RREX_8_0_Op=>RREX_8_0_Op,
							RREX_5_0=>IDRR_5_0_Op, RREX_5_0_Op=>RREX_5_0_Op,
							RREX_5_3=>IDRR_5_3_Op, RREX_5_3_Op=>RREX_5_3_Op,
							RREX_indexout=>IDRR_indexout_Op, RREX_indexout_Op=>RREX_indexout_Op
							);
							
--Hazard_JRI
JRI_haz: Hazard_JRI port map (match=>RREX_match_Op, indexout=>RREX_indexout_Op, RREX_opcode=>RREX_opcode_Op, ALU_C=>ALU_C, IDRR_PC_Op=>IDRR_PC_Op, history=>history_JRI, haz_JRI=>haz_JRI_Op, indexin=>indexin_JRI);

--Hazard_EX
EX_haz: Hazard_EX port map (RREX_opcode_Op=>RREX_opcode_Op, RREX_11_9_Op=>RREX_11_9_Op, RREX_8_6_Op=>RREX_8_6_Op, RREX_5_3_Op=>RREX_5_3_Op, RREX_2_0_Op=>RREX_5_0_Op(2 downto 0), cy_in=>cy_in, z_in=>z_in, haz_EX=>haz_EX_Op);

--Incrementer for LMSM
inc_LMSM: incr_LMSM port map (A=>RREX_LMSM_Op, Op=>inc_LMSM_Op);						
							
--Mux_ALU_A
Mux_ALU_A: mux21 port map (A0=>RREX_RF_D1_Op, A1=>RREX_RF_D2_Op, S=>select_Mux_ALU_A, Op=>ALU_A);

--1-bit Shifter
S1: bit1shift port map (A=>RREX_RF_D2_Op, Op=>S1_Op);

--6-bit Sign Extender
SE6: bitextender6 port map (A=>RREX_5_0_Op, Op=>SE6_Op);

--9-bit Sign Extender
SE9: bitextender9 port map (A=>RREX_8_0_Op, Op=>SE9_Op);

--Mux_ALU_B
Mux_ALU_B: mux41 port map (A0=>RREX_RF_D2_Op, A1=>S1_Op, A2=>SE6_Op, A3=>SE9_Op, S=>select_Mux_ALU_B, Op=>ALU_B);

--ALU
ALU_1: alu port map (A=>ALU_A, B=>ALU_B, S=>select_ALU, Op=>ALU_C, carry=>cy, zero=>z);

--Carry
carry: reg1 port map (wr=>wr_cy, clk=>clk, data=>cy, Op=>cy_Op, clr=>reset);

--Zero
zero: reg1 port map (wr=>wr_z, clk=>clk, data=>z, Op=>z_Op, clr=>reset);

--EX/MEM Register
EX_MEM: EXMEM port map (
							clk=>clk,
							clr_EXMEM=>(clr_EXMEM or reset),
							wr_EXMEM=>wr_EXMEM,
							EXMEM_match=>RREX_match_Op, EXMEM_match_Op=>EXMEM_match_Op, 
							EXMEM_opcode=>RREX_opcode_Op, EXMEM_opcode_Op=>EXMEM_opcode_Op,
							EXMEM_11_9=>RREX_11_9_Op, EXMEM_11_9_Op=>EXMEM_11_9_Op, 
							EXMEM_8_6=>RREX_8_6_Op, EXMEM_8_6_Op=>EXMEM_8_6_Op,
							EXMEM_SE6=>SE6_Op, EXMEM_SE6_Op=>EXMEM_SE6_Op,
							EXMEM_SE9=>SE9_Op, EXMEM_SE9_Op=>EXMEM_SE9_Op,
							EXMEM_inc=>RREX_inc_Op, EXMEM_inc_Op=>EXMEM_inc_Op,
							EXMEM_PC=>RREX_PC_Op, EXMEM_PC_Op=>EXMEM_PC_Op,
							EXMEM_ALU_C=>ALU_C, EXMEM_ALU_C_Op=>EXMEM_ALU_C_Op,
							EXMEM_dec=>RREX_dec_Op, EXMEM_dec_Op=>EXMEM_dec_Op,
							EXMEM_RF_D1=>RREX_RF_D1_Op, EXMEM_RF_D1_Op=>EXMEM_RF_D1_Op,
							EXMEM_LMSM=>RREX_LMSM_Op, EXMEM_LMSM_Op=>EXMEM_LMSM_Op,
							EXMEM_RF_D2=>RREX_RF_D2_Op, EXMEM_RF_D2_Op=>EXMEM_RF_D2_Op,
							EXMEM_8_0=>RREX_8_0_Op, EXMEM_8_0_Op=>EXMEM_8_0_Op,
							EXMEM_5_0=>RREX_5_0_Op, EXMEM_5_0_Op=>EXMEM_5_0_Op,
							EXMEM_5_3=>RREX_5_3_Op, EXMEM_5_3_Op=>EXMEM_5_3_Op,
							EXMEM_cy=>cy_Op, EXMEM_cy_Op=>EXMEM_cy_Op,
							EXMEM_z=>z_Op, EXMEM_z_Op=>EXMEM_z_Op,
							EXMEM_indexout=>RREX_indexout_Op, EXMEM_indexout_Op=>EXMEM_indexout_Op
							);
							
--Hazard_MEM
MEM_haz: Hazard_MEM port map (EXMEM_opcode_Op=>EXMEM_opcode_Op, EXMEM_11_9_Op=>EXMEM_11_9_Op, haz_MEM=>haz_MEM_Op);

--Hazard_BEQ
BEQ_haz: Hazard_BEQ port map (match=>EXMEM_match_Op, exmem_z=>EXMEM_z_Op, indexout=>EXMEM_indexout_Op, EXMEM_opcode=>EXMEM_opcode_Op, history=>history_BEQ, haz_BEQ=>haz_BEQ_Op, indexin=>indexin_BEQ);

--Hazard_JAL
JAL_haz: Hazard_JAL port map (match=>EXMEM_match_Op, indexout=>EXMEM_indexout_Op, EXMEM_opcode=>EXMEM_opcode_Op, history=>history_JAL, haz_JAL=>haz_JAL_Op, indexin=>indexin_JAL);

--Mux_DMem_A
Mux_DMem_A: mux21 port map (A0=>EXMEM_ALU_C_Op, A1=>EXMEM_LMSM_Op, S=>select_Mux_DMem_A, Op=>DMem_A);

--Mux_DMem_Din
Mux_DMem_Din: mux21 port map (A0=>EXMEM_RF_D1_Op, A1=>EXMEM_RF_D2_Op, S=>select_Mux_DMem_Din, Op=>DMem_Din);

--Data Memory
DMem: ram port map (wr=>wr_DMem, A=>DMem_A, Din=>DMem_Din, clk=>clk, clr=>reset, Dout=>DMem_Dout);	

--Mux_ALU2_A
Mux_ALU2_A: mux21 port map (A0=>EXMEM_RF_D1_Op, A1=>EXMEM_PC_Op, S=>select_Mux_ALU2_A, Op=>ALU2_A);

--Mux_ALU2_B
Mux_ALU2_B: mux41 port map (A0=>"0000000000000001", A1=>EXMEM_SE6_Op, A2=>EXMEM_SE9_Op, A3=>"0000000000000000", S=>select_Mux_ALU2_B, Op=>ALU2_B);

--ALU2
ALU_2: alu port map (A=>ALU2_A, B=>ALU2_B, S=>select_ALU2, Op=>ALU2_C, carry=>cy_2, zero=>z_2);

--MEM/WB Register
MEM_WB: MEMWB port map (
							clk=>clk,
							clr_MEMWB=>(clr_MEMWB or reset),
							wr_MEMWB=>wr_MEMWB,
							MEMWB_opcode=>EXMEM_opcode_Op, MEMWB_opcode_Op=>MEMWB_opcode_Op,
							MEMWB_11_9=>EXMEM_11_9_Op, MEMWB_11_9_Op=>MEMWB_11_9_Op, 
							MEMWB_8_6=>EXMEM_8_6_Op, MEMWB_8_6_Op=>MEMWB_8_6_Op,
							MEMWB_ALU2_C=>ALU2_C, MEMWB_ALU2_C_Op=>MEMWB_ALU2_C_Op,
							MEMWB_ALU_C=>EXMEM_ALU_C_Op, MEMWB_ALU_C_Op=>MEMWB_ALU_C_Op,
							MEMWB_DMem_D=>DMem_Dout, MEMWB_DMem_D_Op=>MEMWB_DMem_D_Op,
							MEMWB_dec=>EXMEM_dec_Op, MEMWB_dec_Op=>MEMWB_dec_Op,
							MEMWB_PC=>EXMEM_PC_Op, MEMWB_PC_Op=>MEMWB_PC_Op,
							MEMWB_inc=>EXMEM_inc_Op, MEMWB_inc_Op=>MEMWB_inc_Op,
							MEMWB_RF_D2=>EXMEM_RF_D2_Op, MEMWB_RF_D2_Op=>MEMWB_RF_D2_Op,
							MEMWB_8_0=>EXMEM_8_0_Op, MEMWB_8_0_Op=>MEMWB_8_0_Op,
							MEMWB_5_0=>EXMEM_5_0_Op, MEMWB_5_0_Op=>MEMWB_5_0_Op,
							MEMWB_5_3=>EXMEM_5_3_Op, MEMWB_5_3_Op=>MEMWB_5_3_Op,
							MEMWB_cy=>EXMEM_cy_Op, MEMWB_cy_Op=>MEMWB_cy_Op,
							MEMWB_z=>EXMEM_z_Op, MEMWB_z_Op=>MEMWB_z_Op
							);
							
--Hazard_WB
WB_haz: Hazard_WB port map (MEMWB_opcode_Op=>MEMWB_opcode_Op, MEMWB_11_9_Op=>MEMWB_11_9_Op, haz_WB=>haz_WB_Op);

--Forwarding Block
Fwd_Block: fwd_logic port map (
									IDRR_opcode=>IDRR_opcode_Op,
									RREX_opcode=>RREX_opcode_Op,
									EXMEM_opcode=>EXMEM_opcode_Op,
									MEMWB_opcode=>MEMWB_opcode_Op,
									IDRR_11_9=>IDRR_11_9_Op,
									IDRR_8_6=>IDRR_8_6_Op,
									RREX_8_6=>RREX_8_6_Op,
									RREX_5_3=>RREX_5_3_Op,
									EXMEM_11_9=>EXMEM_11_9_Op,
									MEMWB_11_9=>MEMWB_11_9_Op,
									MEMWB_8_6=>MEMWB_8_6_Op,
									MEMWB_5_3=>MEMWB_5_3_Op,
									select_Mux_forward1=>select_Mux_forward1,
									select_Mux_forward2=>select_Mux_forward2
									);
							
--Mux_RF-A3
Mux_RF_A3: mux41_3 port map (A0=>MEMWB_5_3_Op, A1=>MEMWB_8_6_Op, A2=>MEMWB_11_9_Op, A3=>MEMWB_dec_Op, S=>select_Mux_RF_A3, Op=>RF_A3);

--7-bit Shifter
S7: bit7shift port map (A=>MEMWB_8_0_Op, Op=>S7_Op);

--Mux_RF-D3
Mux_RF_D3: mux81 port map (A0=>MEMWB_ALU_C_Op, A1=>S7_Op, A2=>MEMWB_DMem_D_Op, A3=>MEMWB_inc_Op, A4=>MEMWB_ALU2_C_Op, A5=>"0000000000000000", A6=>"0000000000000000", A7=>"0000000000000000", S=>select_Mux_RF_D3, Op=>RF_D3);

cy_out<=MEMWB_cy_Op;
z_out<=MEMWB_z_Op;
IDRR_opcode<=IDRR_opcode_Op; 
RREX_opcode<=RREX_opcode_Op; 
EXMEM_opcode<=EXMEM_opcode_Op;
MEMWB_opcode<=MEMWB_opcode_Op;
IDRR_5_0<=IDRR_5_0_Op; 
RREX_5_0<=RREX_5_0_Op;

haz_EX<=haz_EX_Op; 
haz_MEM<=haz_MEM_Op; 
haz_WB<=haz_WB_Op;
haz_BEQ<=haz_BEQ_Op; 
haz_JAL<=haz_JAL_Op; 
haz_JLR<=haz_JLR_Op; 
haz_JRI<=haz_JRI_Op;

IDRR_11_9<=IDRR_11_9_Op;
IDRR_8_6<=IDRR_8_6_Op;
RREX_11_9<=RREX_11_9_Op;

end arch;