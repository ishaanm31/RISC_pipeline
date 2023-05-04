library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity test is
	port( Cpl: in std_logic; 
			Inp: in std_logic_vector(15 downto 0);
			Outp: out std_logic_vector(15 downto 0));
end test;

architecture behave of test is
-------COMPLEMENT-----------------------------------------------------	
	function bit_cpl(a: in std_logic_vector(15 downto 0))
		return std_logic_vector is
			variable S : std_logic_vector(15 downto 0);
		begin
			loop3 : for i in 0 to 15 loop
		               S(i) :=( not a(i));
			end loop loop3;
		return S;
	end bit_cpl ;
	
	begin
		alu : process(Inp,Cpl)
		variable temp : std_logic_vector(15 downto 0);

			begin
			if ( Cpl = '1') then
				temp := bit_cpl(Inp);
			else 
				temp := Inp;
			end if;
			
			Outp <= temp;	
	end process;
end behave;
