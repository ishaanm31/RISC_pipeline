library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity Mux3_8x1 is
    port(A0: in std_logic_vector(2 downto 0);
         A1: in std_logic_vector(2 downto 0);
         A2: in std_logic_vector(2 downto 0);
         A3: in std_logic_vector(2 downto 0);
         A4: in std_logic_vector(2 downto 0);
         A5: in std_logic_vector(2 downto 0);
         A6: in std_logic_vector(2 downto 0);
         A7: in std_logic_vector(2 downto 0);        
         sel:in std_logic_vector(2 downto 0);
         F: out std_logic_vector(2 downto 0));
end Mux3_8x1;
architecture Dataflow of Mux3_8x1 is
begin
process_Mux3_8x1 :process(A0,A1,A2,A3,A4,A5,A6,A7,sel)
begin

   case sel is
      when "000" => 
         F <= A0;
      when "001" => 
         F <= A1;
      when "010" => 
         F <= A2;
      when "011" => 
         F <= A3;
      when "100" => 
         F <= A4;
      when "101" => 
         F <= A5;
      when "110" => 
         F <= A6;
      when "111" => 
         F <= A7; 
      when others =>
         F <= "000";
   end case;
end process process_Mux3_8x1;
end Dataflow;