library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
entity adder is
	port( 
	    Inp1,Inp2: in std_logic_vector(15 downto 0);
		Outp: out std_logic_vector(15 downto 0)
		);
end adder;

architecture behave of adder is
begin
al2u : process(Inp1,Inp2)
			begin
				Outp<= Inp1 + Inp2;           
			end process;
 
end behave;
