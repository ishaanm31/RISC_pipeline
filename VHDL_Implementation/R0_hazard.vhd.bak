library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
-- write the Flipflops packege declaration
entity Haz_R0 is
port (
    Rd_Mem:in std_logic_vector(2 downto 0);
    H_R0:out std_logic
);
end entity Haz_R0;

architecture struct of Haz_R0 is
begin
    process(Rd_Mem)

        begin
		    if((Rd_Mem = "000")) then
                H_R0<= '1';
            else    
                H_R0<='0';
            end if;
        end process;
end struct;