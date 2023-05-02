library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
-- write the Flipflops packege declaration
entity Haz_JAL is
port (
    Instruc_OPCode_ID:in std_logic_vector(3 downto 0);
    Hist_ID: in std_logic;
    H_Jal:out std_logic
);
end entity Haz_JAL;

architecture struct of Haz_JAL is
begin
    process(Instruc_OPCode_ID,Hist_ID)

        begin
            if((Instruc_OPCode_ID="1100") and(Hist_ID='0')) then
                H_Jal<='1';
            else    
                H_Jal<='0';
            end if;
        end process;
end struct;