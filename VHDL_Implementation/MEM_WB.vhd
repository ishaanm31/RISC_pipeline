library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
-- write the Flipflops packege declaration
entity MEMWB is
port (
    clk: in std_logic;
    WR_EN: in std_logic;
    OP_in: in std_logic_vector(3 downto 0);
    RS1_in: in std_logic_vector(2 downto 0);
    RS2_in: in std_logic_vector(2 downto 0);
    RD_in: in std_logic_vector(2 downto 0);
    RF_wr_in,CN_in: in std_logic;
    Data_out_WB_in: in std_logic_vector(15 downto 0);
    Imm_in: in std_logic_vector(15 downto 0);
    PC_in: in std_logic_vector(15 downto 0);
    D3_MUX_in: in std_logic_vector(1 downto 0);
    ALU3_C_in: in std_logic_vector(15 downto 0);
    OP_out: out std_logic_vector(3 downto 0);
    RS1_out: out std_logic_vector(2 downto 0);
    RS2_out: out std_logic_vector(2 downto 0);
    RD_out: out std_logic_vector(2 downto 0);
    RF_wr_out,CN_out: out std_logic;
    Data_out_WB_out: out std_logic_vector(15 downto 0);
    Imm_out: out std_logic_vector(15 downto 0);
    PC_out: out std_logic_vector(15 downto 0);
    D3_MUX_out: out std_logic_vector(1 downto 0);
    ALU3_C_out: out std_logic_vector(15 downto 0)
);
end entity;

architecture MEMWB_arch of MEMWB is
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

    component Register_4bit is
        port (DataIn:in std_logic_vector(3 downto 0); 
        clock,Write_Enable:in std_logic;
        DataOut:out std_logic_vector(3 downto 0));
    end component Register_4bit;
    
begin
    OP: Register_4bit port map(OP_in,clk,WR_EN,OP_out);
    RS1: Register_3bit port map(RS1_in,clk,WR_EN,RS1_out);
    RS2: Register_3bit port map(RS2_in,clk,WR_EN,RS2_out);
    RD: Register_3bit port map(RD_in,clk,WR_EN,RD_out);
    RF_wr: Register_1bit port map(RF_wr_in,clk,WR_EN,RF_wr_out);
    Data_out_WB: Register_16bit port map(Data_out_WB_in,clk,WR_EN,Data_out_WB_out);
    Imm: Register_16bit port map(Imm_in,clk,WR_EN,Imm_out);
    PC: Register_16bit port map(PC_in,clk,WR_EN,PC_out);
    D3_MUX: Register_2bit port map(D3_MUX_in,clk,WR_EN,D3_MUX_out);
    ALU3_C: Register_16bit port map(ALU3_C_in,clk,WR_EN,ALU3_C_out);
    CN: Register_1bit port map(CN_in,clk,WR_EN,CN_out);
end MEMWB_arch;
