library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity SE7 is
port (Raw: in std_logic_vector(8 downto 0 );
    Outp:out std_logic_vector(15 downto 0):="0000000000000000");
end entity SE7;

architecture struct of SE7 is
begin
SE_process : process(Raw) 
  begin
    Outp(8 downto 0) <= Raw(8 downto 0);
    Outp(15 downto 9) <= "0000000";
end process;
end struct;