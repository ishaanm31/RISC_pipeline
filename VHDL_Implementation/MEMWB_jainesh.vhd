library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
-- write the Flipflops packege declaration
entity MEMWB is
port (
    clk: in std_logic;
    WR_EN: in std_logic;
    Rf_D2_in : in std_logic_vector(15 downto 0);
    RegC_in : in std_logic_vector(2 downto 0);
    Rf_wr_in : in std_logic;
    RegA_in : in std_logic_vector(15 downto 0);
    RegB_in : in std_logic_vector(15 downto 0);
    Rf_D2_out : out std_logic_vector(15 downto 0);
    RegC_out : out std_logic_vector(2 downto 0);
    Rf_wr_out : out std_logic;
    RegA_out : out std_logic_vector(15 downto 0);
    RegB_out : out std_logic_vector(15 downto 0);

    cancelin:in std_logic;
    cancelout: out std_logic;
    OpCode_in:in std_logic_vector(3 downto 0);
    OpCode_out: out std_logic_vector(3 downto 0)
);
end entity;

architecture MEMWb_arch of MEMWB is
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
        port (DataIn:in std_logic_vector(1 downto 0); 
        clock,Write_Enable:in std_logic;
        DataOut:out std_logic_vector(1 downto 0));
    end component Register_4bit;

begin
Rf_D2 : Register_16bit port map(Rf_D2_in,clk,WR_EN,Rf_D2_out);
RegC : Register_3bit port map(RegC_in,clk,WR_EN,RegC_out);
Rf_wr : Register_1bit port map(Rf_wr_in,clk,WR_EN,Rf_wr_out);
RegA : Register_16bit port map(RegA_in,clk,WR_EN,RegA_out);
RegB : Register_16bit port map(RegB_in,clk,WR_EN,RegB_out);
Canc : Register_1bit port map(cancelin,clk, WR_EN, cancelout);
OP   : Register_4bit port map(OpCode_in,clk,WR_EN, OpCode_out);

end MEMWB_arch;