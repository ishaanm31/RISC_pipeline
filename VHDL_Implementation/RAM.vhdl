library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
-- write the Flipflops packege declaration
entity Memory is
port (Mem_Add: in std_logic_vector(15 downto 0 );
Mem_Data_In:in std_logic_vector(15 downto 0);
clock,Write_Enable:in std_logic;
Mem_Data_Out:out std_logic_vector(15 downto 0));

end entity Memory;

architecture struct of Memory is
  type mem_word   is array (0 to 65535) of std_logic_vector(7 downto 0);
	signal Data : mem_word:=("00000000","00000001","00000000","00000001",others=>"00000000");

begin
-----------------------------------------Write in Memory--------------------------------------
write_process : process(Mem_Add, Mem_Data_In, Write_Enable, clock, Data) 

  begin
  if (clock'event and (clock='1')) then
    if(Write_Enable='1') then  
      Data(To_integer(unsigned(Mem_Add))) <= Mem_Data_In( 15 downto 8)  ;
		Data(To_integer(unsigned(Mem_Add))+1) <= Mem_Data_In( 7 downto 0)  ;
    end if;
  end if;
end process;
------------------------------------- Read Memory---------------------------
read_process : process(Mem_Add,Data)
	
begin

  Mem_Data_Out <= Data(To_integer(unsigned(Mem_Add))) &  Data(To_integer(unsigned(Mem_Add))+1);
  ----------------------------------------------------------------------
end process;
end struct;