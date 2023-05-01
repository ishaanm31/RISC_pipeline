library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity RREX_reg is
port(
    clk: in std_logic;
    WR_EN: in std_logic;
    Alu1_A_in : in std_logic_vector(15 downto 0);
    Alu1_B_in : in std_logic_vector(15 downto 0);
    Rf_D2_in : in std_logic_vector(15 downto 0);
    PC_in : in std_logic_vector(15 downto 0);
    Imm9_in : in std_logic_vector(15 downto 0);
    RegC_in : in std_logic_vector(2 downto 0);
    Rf_wr_in, c_modify_in, z_modify_in,history_bit_in, mem_wr_in, mem_mux_in : in std_logic;
    ALU_sel_in : in std_logic_vector(1 downto 0);
    i_in : in integer;
    Alu1_A_out : out std_logic_vector(15 downto 0);
    Alu1_B_out : out std_logic_vector(15 downto 0);
    Rf_D2_out : out std_logic_vector(15 downto 0);
    PC_out : out std_logic_vector(15 downto 0);
    Imm9_out : out std_logic_vector(15 downto 0);
    RegC_out : out std_logic_vector(2 downto 0);
    Rf_wr_out, c_modify_out, z_modify_out,history_bit_out, mem_wr_out, mem_mux_out : out std_logic;
    ALU_sel_out : out std_logic_vector(1 downto 0);
    i_out : out integer;

    cancelin:in std_logic;
    cancelout: out std_logic;
);
end entity;
architecture RREX_reg_arch of RREX_reg is
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
Alu1_A : Register_16bit port map(Alu1_A_in,clk,WR_EN,Alu1_A_out);
Alu1_B : Register_16bit port map(Alu1_B_in,clk,WR_EN,Alu1_B_out);
Rf_D2 : Register_16bit port map(Rf_D2_in,clk,WR_EN,Rf_D2_out);
PC :  Register_16bit port map(PC_in,clk,WR_EN,PC_out);
RegC: Register_3bit port map(RegC_in,clk,WR_EN,RegC_out);
Rf_wr: Register_16bit port map(Rf_wr_in,clk,WR_EN,Rf_wr_out);
ALU_sel: Register_2bit port map(ALU_sel_in,clk,WR_EN,ALU_sel_out);
c_modify: Register_1bit port map(c_modify_in,clk,WR_EN,c_modify_out);
z_modify: Register_1bit port map(z_modify_in,clk,WR_EN,z_modify_out); 
mem_wr : Register_1bit port map(mem_wr_in,clk,WR_EN,mem_wr_out);
mem_mux : Register_1bit port map(mem_mux_in,clk,WR_EN,mem_mux_out);
i : Register_int port map(i_in,clk,WR_EN,i_out);
history_bit: Register_1bit port map(history_bit_in,clk,WR_EN,history_bit_out);
Canc : Register_1bit port map(cancelin,clk, WR_EN, cancelout);

end RREX_reg_arch;
