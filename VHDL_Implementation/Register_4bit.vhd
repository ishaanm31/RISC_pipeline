library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity Register_4bit is
  port (DataIn:in std_logic_vector(3 downto 0);
  clock,Write_Enable:in std_logic;
  DataOut:out std_logic_vector(3 downto 0));
  end entity Register_4bit;
  
  architecture struct of Register_4bit is
      shared variable Data : std_logic_vector(3 downto 0):="0000";
  begin
  -----------------------------------------ARRAY of Registers--------------------------------------
  write_process : process(clock) 
  
    begin
	 if (clock'event and (clock='1')) then
      if(Write_Enable='1') then  
        Data(3 downto 0):= DataIn(3 downto 0);
      end if;
	 end if;
  end process;
  ------------------------------------- Read A1 D1---------------------------
  read_process : process(clock)
  begin
  if (clock'event and (clock='1')) then
    DataOut(3 downto 0) <= Data(3 downto 0);
  end if;
    ----------------------------------------------------------------------
  end process;
  end struct;