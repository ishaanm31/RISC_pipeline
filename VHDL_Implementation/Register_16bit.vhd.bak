library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
-- write the Flipflops packege declaration
entity Register_16bit is
port (DataIn:in std_logic_vector(15 downto 0);
clock,Write_Enable:in std_logic;
DataOut:out std_logic_vector(15 downto 0));
end entity Register_16bit;

architecture struct of Register_16bit is
    shared variable Data : std_logic_vector(15 downto 0):="0000000000000000";
begin
-----------------------------------------ARRAY of Registers--------------------------------------
write_process : process(clock) 

  begin
  if (clock'event and (clock='1')) then
    if(Write_Enable='1') then  
      Data(15 downto 0):= DataIn(15 downto 0);
	 end if;
  end if;
end process;
------------------------------------- Read A1 D1---------------------------
read_process : process(clock)
begin
  if (clock'event and (clock='1')) then
    DataOut(15 downto 0) <= Data(15 downto 0);
  end if;
  ----------------------------------------------------------------------
end process;
end struct;