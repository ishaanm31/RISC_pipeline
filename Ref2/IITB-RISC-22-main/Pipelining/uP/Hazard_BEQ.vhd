library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Hazard_BEQ is
	port(
		match, exmem_z: in std_logic;
		indexout: in integer;
		EXMEM_opcode: in std_logic_vector(3 downto 0);
		
		history, haz_BEQ: out std_logic;
		indexin: out integer
		);
end Hazard_BEQ;

architecture h_beq of Hazard_BEQ is
begin
	process(match, exmem_z, EXMEM_opcode)
	begin
		if EXMEM_opcode="1000" then
			if (match='1' and exmem_z='1') then
				history<='1';
				haz_BEQ<='0';
			elsif (match='1' and exmem_z='0') then
				history<='0';
				haz_BEQ<='1';
			elsif (match='0' and exmem_z='1') then
				history<='1';
				haz_BEQ<='1';
			else
				history<='0';
				haz_BEQ<='0';
			end if;
		end if;
	end process;
	indexin<=indexout;
end h_beq;