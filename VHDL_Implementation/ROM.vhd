library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
-- write the Flipflops packege declaration
entity ROM is
port (Mem_Add: in std_logic_vector(15 downto 0 );
Mem_Data_Out:out std_logic_vector(15 downto 0));

end entity ROM;

architecture struct of ROM is
    type mem_word   is array (0 to 1024) of std_logic_vector(7 downto 0);
	 signal Data : mem_word:=("00110010","00000011","00110101","11001110","00110111","01010011","00111001","11111110","00111010","00010001","00111101","10000000","00111110","10101011",others=>"00000000");

begin
------------------------------------- Read Instruction---------------------------
read_process : process(Mem_Add,Data)
begin
  Mem_Data_Out <= Data(To_integer(unsigned(Mem_Add))) & Data(To_integer(unsigned(Mem_Add))+1);
----------------------------------------------------------------------
end process;
end struct;