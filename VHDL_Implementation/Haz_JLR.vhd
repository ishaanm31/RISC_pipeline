library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
-- write the Flipflops packege declaration
entity Haz_JLR is
port (
    Instruc_OPCode_RR:in std_logic_vector(3 downto 0);
    H_JLR:out std_logic
);
end entity Haz_JLR;

architecture struct of Haz_JLR is
begin
    process(Instruc_OPCode_RR)

        begin
            if((Instruc_OPCode_RR="1101")) then
                H_JLR<='1';
            else    
                H_JLR<='0';
            end if;
        end process;
end struct;