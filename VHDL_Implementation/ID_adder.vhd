library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
entity ID_adder is
	port(   PC,Imm9: in std_logic_vector(15 downto 0);
			    BranchedPC: out std_logic_vector(15 downto 0)
		);
end ID_adder;

architecture behave of ID_adder is
begin
al2u : process(PC)
			begin
				BranchedPC<= PC + Imm9;           
			end process;
 
end behave;
