library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
-- write the Flipflops packege declaration
entity Register_int is
port (DataIn:in integer;
clock,Write_Enable:in std_logic;
DataOut:out integer);
end entity Register_int;

architecture struct of Register_int is
    shared variable Data : integer;
begin
-----------------------------------------ARRAY of Registers--------------------------------------
write_process : process(clock) 

  begin
  if (clock'event and (clock='1')) then
    if(Write_Enable='1') then  
      Data:= DataIn;
	 end if;
  end if;
end process;
------------------------------------- Read A1 D1---------------------------
read_process : process(clock)
begin
 DataOut<= Data;
  ----------------------------------------------------------------------
end process;
end struct;