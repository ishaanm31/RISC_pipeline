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
    type mem_word   is array (0 to 65535) of std_logic_vector(7 downto 0);
	 signal Data : mem_word:=("00110010","00000101","00110100","00001100","00010010","10011000","00000110","11001110",others=>"00000000");

begin
------------------------------------- Read Instruction---------------------------
read_process : process(Mem_Add,Data)
begin
  Mem_Data_Out <= Data(To_integer(unsigned(Mem_Add))) & Data(To_integer(unsigned(Mem_Add))+1);
----------------------------------------------------------------------
end process;
end struct;