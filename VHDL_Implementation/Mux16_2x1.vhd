library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity Mux16_2x1 is
    port(A0: in std_logic_vector(15 downto 0);
         A1: in std_logic_vector(15 downto 0);
         sel:in std_logic;
         F: out std_logic_vector(15 downto 0));
end Mux16_2x1;
architecture Dataflow of Mux16_2x1 is
begin
mux : process(sel, A0, A1)
begin
   case (sel) is   
      when '0' =>
         F <= A0;
      when '1' =>
         F <= A1;
      when others =>
         F <= "0000000000000000";
	end case;
end process;
end Dataflow;