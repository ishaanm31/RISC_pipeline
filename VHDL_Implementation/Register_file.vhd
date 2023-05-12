library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
-- write the Flipflops packege declaration
entity Register_file is
  port (
  A1, A2, A3: in std_logic_vector(2 downto 0 );
  D3:in std_logic_vector(15 downto 0);
  RF_D_PC_WR: in std_logic_vector(15 downto 0);
  Reg_data: out std_logic_vector(7 downto 0);
  clock,Write_Enable,PC_WR:in std_logic;
  RF_D_PC_R:out std_logic_vector(15 downto 0):=(others=>'0');
  D1, D2:out std_logic_vector(15 downto 0)
  );
end entity Register_file;

architecture struct of Register_File is
    type mem_word   is array (0 to 7) of std_logic_vector(15 downto 0);
    signal Data : mem_word :=("0000000000000000","0000000000000000","0000000000000000","0000000000000000","0000000000000000",others=>(others=>'0'));
begin
---Instruction
output_process: process(Data)
variable temp2 : std_logic_vector(15 downto 0);
	begin
	temp2 := Data(3);
	Reg_data <= temp2(7 downto 0);
	end process;
-----------------------------------------ARRAY of Registers--------------------------------------
write_process : process(A3,D3,clock) 

  begin
  if (clock'event and (clock='1')) then
      if(Write_Enable='1') then  
      Data(To_integer(unsigned(A3)))<= D3;
		else 
			null;
		end if;
		
		if(PC_WR='1') then
      Data(0)<= RF_D_PC_WR;
		else
			null;
		end if;
  end if;
end process;
------------------------------------- Read A1 D1---------------------------
read_process : process(A1, A2, Data)
  begin
    RF_D_PC_R(15 downto 0) <=Data(0);
    D1 <= Data(To_integer(unsigned(A1)));
    D2 <= Data(To_integer(unsigned(A2)));
------------------------------------------------------------------------
end process;
end struct;