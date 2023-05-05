library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
-- This component Detects harzards that appears when R0 is the destination
entity Haz_R0 is
port (
    Rd_Mem:in std_logic_vector(2 downto 0);
	 RF_WR_Mem:in std_logic;
	 cancel: in std_logic;
    H_R0:out std_logic
);
end entity Haz_R0;

architecture struct of Haz_R0 is
begin
    process(Rd_Mem,RF_WR_Mem,cancel)

        begin
				if(cancel='1') then
					H_R0<='0';
				elsif((Rd_Mem = "000") and (RF_WR_Mem='1')) then
                H_R0<= '1';
            else    
                H_R0<='0';
            end if;
        end process;
end struct;