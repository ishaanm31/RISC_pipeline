library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
entity Chotu_Adder is
	port(   PC: in std_logic_vector(15 downto 0);
			PCplus2: out std_logic_vector(15 downto 0)
		);
end Chotu_Adder;

architecture behave of Chotu_Adder is
begin
al2u : process(PC)
			begin
				PCplus2<= PC + "0000000000000010";           
			end process;
 
end behave;
