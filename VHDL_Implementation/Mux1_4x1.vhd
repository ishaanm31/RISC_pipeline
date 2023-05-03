library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity Mux1_4x1 is
    port(A,B,C,D: in std_logic;
         Sel: in std_logic_vector(1 downto 0);
         F:out std_logic);
end Mux1_4x1;
architecture Dataflow of Mux1_4x1 is
begin
Mux1 :process(A,B,C,D,Sel)
begin

   case Sel is
      when "00" => 
         F <= A;
      when "01" => 
         F <= B;
      when "10" => 
         F <= C;
      when others => 
         F <= D;
      
   end case;
end process ;
end Dataflow;