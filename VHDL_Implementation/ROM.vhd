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
	 signal Data : mem_word:=("00010110","10001000","00010111","00001000","00010010","11010000",others=>"10111010");

begin
------------------------------------- Read Instruction---------------------------
read_process : process(Mem_Add,Data)
begin
  Mem_Data_Out <= Data(To_integer(unsigned(Mem_Add))) & Data(To_integer(unsigned(Mem_Add))+1);
----------------------------------------------------------------------
end process;
end struct;