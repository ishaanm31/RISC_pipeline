library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
-- write the Flipflops packege declaration
entity ROM is
port (Mem_Add: in std_logic_vector(15 downto 0 );
Mem_Data_Out:out std_logic_vector(15 downto 0));

end entity ROM;

architecture struct of ROM is
    type mem_word   is array (0 to 1000) of std_logic_vector(15 downto 0);
	 signal Data : mem_word:=("0001010011100000",others=>(others=>'1'));

begin
------------------------------------- Read Instruction---------------------------
read_process : process(Mem_Add,Data)
begin
  Mem_Data_Out <= Data(To_integer(unsigned(Mem_Add)));
----------------------------------------------------------------------
end process;
end struct;