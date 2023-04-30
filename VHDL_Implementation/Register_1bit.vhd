library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity Register_1bit is
  port (DataIn:in std_logic;
  clock,Write_Enable:in std_logic;
  DataOut:out std_logic);
 end entity Register_1bit;
  
  architecture struct of Register_1bit is
      shared variable Data : std_logic:='0';
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
  if (clock'event and (clock='1')) then
    DataOut <= Data;
  end if;
    ----------------------------------------------------------------------
  end process;
  end struct;