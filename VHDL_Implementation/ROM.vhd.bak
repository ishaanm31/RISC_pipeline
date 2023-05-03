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
	 signal Data : mem_word:=("0110011111000000","0000000001010000","0101010011000010","0001011011000001","1001110100000000","0000000000000000","0000000000000001",others=>"0000000000000000");

begin
------------------------------------- Read Instruction---------------------------
read_process : process(Mem_Add)
begin
  Mem_Data_Out <= Data(To_integer(unsigned(Mem_Add)));
----------------------------------------------------------------------
end process;
end struct;