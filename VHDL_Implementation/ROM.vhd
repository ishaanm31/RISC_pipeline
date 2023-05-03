library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
-- write the Flipflops packege declaration
entity ROM is
port (Mem_Add: in std_logic_vector(15 downto 0 );
Mem_Data_Out:out std_logic_vector(15 downto 0));

end entity ROM;

architecture struct of ROM is
    type mem_word   is array (0 to 65536) of std_logic_vector(7 downto 0);
	 signal Data : mem_word:=("00010010","10011001","00010010","10011100","00100010","10011100","01001111","10000001","01011011","00000001","11000110","00000001",others=>(others=>'1'));

begin
------------------------------------- Read Instruction---------------------------
read_process : process(Mem_Add,Data)
begin
  Mem_Data_Out <= Data(To_integer(unsigned(Mem_Add))) & Data(To_integer(unsigned(Mem_Add)+1));
----------------------------------------------------------------------
end process;
end struct;