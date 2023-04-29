library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity Mux3_4x1 is
    port(A0: in std_logic_vector(2 downto 0);
         A1: in std_logic_vector(2 downto 0);
         A2: in std_logic_vector(2 downto 0);
         A3: in std_logic_vector(2 downto 0);
         sel: in std_logic_vector(1 downto 0);
         F: out std_logic_vector(2 downto 0));
end Mux3_4x1;
architecture Dataflow1 of Mux3_4x1 is
begin
process_Mux3_4x1 :process(A0,A1,A2,A3,sel)
    begin
      case sel is
         when "00" => 
            F <= A0;
         when "01" => 
            F <= A1;
         when "10" => 
            F <= A2;
         when "11" => 
            F <= A3; 
         when others =>
            F <= "000";
      end case;
end process process_Mux3_4x1 ;		
    end Dataflow1;