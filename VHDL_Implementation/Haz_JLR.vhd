library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
-- Detects hazards due to JLR and JRI
entity Haz_JLR is
port (
    Instruc_OPCode_RR:in std_logic_vector(3 downto 0);
	 cancel:std_logic;
    H_JLR:out std_logic
);
end entity Haz_JLR;

architecture struct of Haz_JLR is
begin
    process(Instruc_OPCode_RR,cancel)

        begin
				if(cancel='1') then
					H_JLR<='0';
				elsif((Instruc_OPCode_RR = "1111")) then
                H_JLR<= '1';
            elsif((Instruc_OPCode_RR="1101")) then
                H_JLR<='1';
            else    
                H_JLR<='0';
            end if;
        end process;
end struct;