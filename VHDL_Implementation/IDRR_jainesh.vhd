library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity IDRR_reg is
port(
    clk: in std_logic;
    WR_EN: in std_logic;
    RegA_in, RegB_in, RegC_in : in std_logic_vector(2 downto 0);
    Imm_6_in, Imm_9_in : in std_logic_vector(15 downto 0);
    Rf_wr_in, PCr_in, history_bit_in, c_modify_in, z_modify_in, mem_wr_in mem_mux_in, imm_mux_in : in std_logic
    Alu_sel_in : in std_logic_vector(1 downto 0);
    i_in : in integer;
    RegA_out, RegB_out, RegC_out : in std_logic_vector(2 downto 0);
    Imm_6_out, Imm_9_out : in std_logic_vector(15 downto 0);
    Rf_wr_out, PCr_out, history_bit_out, c_modify_out, z_modify_out, mem_wr_out mem_mux_out, imm_mux_out: in std_logic
    Alu_sel_out : in std_logic_vector(1 downto 0);
    i_out : out integer;

);
end entity;

architecture IDRR_reg_arch of IDRR_reg is
--------16 bit di Register---------------
    component Register_16bit is
        port (DataIn:in std_logic_vector(15 downto 0);
        clock,Write_Enable:in std_logic;
        DataOut:out std_logic_vector(15 downto 0));
    end component Register_16bit;
	 
----------Ek bit di register-----------------
	 component Register_1bit is
		  port (DataIn:in std_logic;
		  clock,Write_Enable:in std_logic;
		  DataOut:out std_logic);
	 end component Register_1bit;

---------Int ke lie use karne wali Register---------
    component Register_int is
        port (DataIn:in integer;
        clock,Write_Enable:in std_logic;
        DataOut:out integer);
    end component Register_int;
-------Bache hue bits dalne ke lie 3 bit di register--------------
    component Register_3bit is
        port (DataIn:in std_logic_vector(2 downto 0);
        clock,Write_Enable:in std_logic;
        DataOut:out std_logic_vector(2 downto 0));
    end component Register_3bit;
    
    component Register_2bit is
        port (DataIn:in std_logic_vector(1 downto 0); 
        clock,Write_Enable:in std_logic;
        DataOut:out std_logic_vector(1 downto 0));
    end component Register_2bit;
    
begin
register_a : Register_3bit port map(RegA_in,clk,WR_EN,RegA_out);
register_b : Register_3bit port map(RegB_in,clk,WR_EN,RegB_out);
register_c : Register_3bit port map(RegC_in,clk,WR_EN,RegC_out);
Imm_6 : Register_16bit port map(Imm_6_in,clk,WR_EN,Imm_6_out);
Imm_9 : Register_16bit port map(Imm_9_in,clk,WR_EN,Imm_9_out);
Rf_wr : Register_1bit port map(Rf_wr_in,clk, WR_EN, Rf_wr_out);
Alu_sel : Register_2bit port map(Alu_sel_in,clk, WR_EN, Alu_sel_out);
Rf_wr : Register_1bit port map(Rf_wr_in,clk, WR_EN, Rf_wr_out);
PCr : Register_1bit port map(PCr_in,clk, WR_EN, PCr_out);
i : Register_int port map(i_in,clk, WR_EN, i_out);
Rf_wr : Register_1bit port map(Rf_wr_in,clk, WR_EN, Rf_wr_out);
history_bit : Register_1bit port map(history_bit_in,clk, WR_EN, history_bit_out);
c_modify : Register_1bit port map(c_modify_in,clk, WR_EN, c_modify_out); 
z_modify : Register_1bit port map(z_modify_in,clk, WR_EN, z_modify_out);
mem_wr : Register_1bit port map(mem_wr_in,clk, WR_EN, mem_wr_out);
mem_mux : Register_1bit port map(mem_mux_in,clk, WR_EN, mem_mux_out);
imm_mux : Register_1bit port map(imm_mux_in,clk, WR_EN, imm_mux_out);
end IDRR_reg_arch;
