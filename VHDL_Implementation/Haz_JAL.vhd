library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
-- Detects Harazrds due to JAL
entity Haz_JAL is
port (
    Instruc_OPCode_ID:in std_logic_vector(3 downto 0);
	 cancel:std_logic;
    H_Jal:out std_logic
);
end entity Haz_JAL;

architecture struct of Haz_JAL is
begin
    process(Instruc_OPCode_ID,cancel)

        begin
				if(cancel='1') then
					H_Jal<='0';
            elsif((Instruc_OPCode_ID="1100")) then
                H_Jal<='1';
            else    
                H_Jal<='0';
            end if;
        end process;
end struct;