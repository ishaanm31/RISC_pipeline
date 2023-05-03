library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity Mux1_4x1 is
    port(A,B,C,D: in std_logic;
         Sel: in std_logic_vector(1 downto 0);
         F:out std_logic);
end Mux3_8x1;
architecture Dataflow of Mux3_8x1 is
begin
process_Mux-1 :process(A0,A1,A2,A3,A4,A5,A6,A7,sel)
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