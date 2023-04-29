library ieee;
use ieee.std_logic_1164.all;

entity bit7shift is
    port (
        A: in std_logic_vector(8 downto 0);
        Op: out std_logic_vector(15 downto 0)
    ) ;
	 
end bit7shift;

architecture a1 of bit7shift is
begin
	shifter : process(A)
	variable temp : std_logic_vector(15 downto 0);
	begin
		Op <= A&"0000000";
	end process ; 
end a1 ;
