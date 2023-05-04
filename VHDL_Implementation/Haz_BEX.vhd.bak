library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
-- write the Flipflops packege declaration
entity Haz_BEX is
port (
    Instruc_OPCode_EX:in std_logic_vector(3 downto 0);
    ZFlag,CFlag:in std_logic;

    H_BEX:out std_logic;
    HType:out std_logic_vector(1 downto 0)
    --0->BEQ
    --1->BLT
    --2->BLE
    --3->JRI
);
end entity Haz_BEX;

architecture struct of Haz_BEX is
begin
    process(Instruc_OPCode_EX,ZFlag,CFlag)

        begin
            H_BEX<= '0';
			HType<="00";
            ---------JRI
            if((Instruc_OPCode_EX = "1111")) then
                H_BEX<= '1';
                HType<= "11";
            ---BEQ
            elsif(((Instruc_OPCode_EX  = "1000") and (ZFlag = '1')))    then
                H_BEX<= '1';
                HType<= "00";
            -----BLE
            elsif ((Instruc_OPCode_EX  =  "1010")and (CFlag = '1'))    then
                H_BEX <=  '1';
                HType <=  "10";  
            -----BLT
            elsif ((Instruc_OPCode_EX = "1001") and (CFlag = '1') and (ZFlag = '0'))    then
                H_BEX <=  '1';
                HType <=  "01";  
            else
                H_BEX<='0';
                HType<="00";
            end if;
        end process;
end struct;