library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
-- write the Flipflops packege declaration
entity IF_ID is
port (
    Instruc_in,PC_in: in std_logic_vector(15 downto 0 );
    CN_in: in std_logic;

    clk: in std_logic;
    WR_EN: in std_logic;

    
    CN_out:out std_logic;
    Instruc_op,PC_op: out std_logic_vector(15 downto 0 )
);
end entity IF_ID;

architecture struct of IF_ID             is
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
    
begin
----------------------Register of 16 bits----------------------------------------------
Instruction: Register_16bit port map(Instruc_in,clk,WR_EN,Instruc_op);
PC         : Register_16bit port map(PC_in,clk,WR_EN,PC_op);
------------------------------------------
Canc       : Register_1bit port map(CN_in,clk,WR_EN,CN_out);


end struct;