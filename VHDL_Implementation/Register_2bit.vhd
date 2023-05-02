library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity Register_2bit is
  port (DataIn:in std_logic_vector(1 downto 0);
  clock,Write_Enable:in std_logic;
  DataOut:out std_logic_vector(1 downto 0));
  end entity Register_2bit;
  
  architecture struct of Register_2bit is
      shared variable Data : std_logic_vector(1 downto 0):="00";
  begin
  -----------------------------------------ARRAY of Registers--------------------------------------
  write_process : process(clock) 
  
    begin
	 if (clock'event and (clock='1')) then
      if(Write_Enable='1') then  
        Data(1 downto 0):= DataIn(1 downto 0);
      end if;
	 end if;
  end process;
  ------------------------------------- Read A1 D1---------------------------
  read_process : process(clock)
  begin
  if (clock'event and (clock='1')) then
    DataOut(1 downto 0) <= Data(1 downto 0);
  end if;
    ----------------------------------------------------------------------
  end process;
  end struct;