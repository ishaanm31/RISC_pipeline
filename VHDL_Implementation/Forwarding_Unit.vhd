library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
-- write the Flipflops packege declaration
entity Forwarding_Unit is
port (
    RegC_EX,RegC_Mem,RegC_WB,RegA_RR, RegB_RR: in std_logic_vector(2 downto 0);
    ID_RR_OpCode: in std_logic_vector(3 downto 0);
    
    MuxA,MuxB: out std_logic_vector(1 downto 0)
);
end entity Forwarding_Unit;

architecture struct of Forwarding_Unit is
    
begin
----------------------Register of 16 bits----------------------------------------------
forwarding : process(RegC_EX,RegC_Mem,RegC_WB,RegA_RR, RegB_RR,ID_RR_OpCode)
    begin
    --Only for            ADD                      NAND
        if((ID_RR_OpCode="0001") or (ID_RR_OpCode="0010"))
            if(RegA_RR=RegC_EX)
                MuxA<="01";
            else if(RegA_RR=RegC_Mem)
                MuxA<="10";
            else if(RegA_RR=RegC_WB)
                MuxA<="11";
            else
                MuxA<="00";
            end if

            if(RegB_RR=RegC_EX)
                MuxB<="01";
            else if(RegB_RR=RegC_Mem)
                MuxB<="10";
            else if(RegB_RR=RegC_WB)
                MuxB<="11";
            else 
                MuxB<="00";
            end if
        else
            MuxA<="00";
            MuxB<="00";
        end if
    end process
end struct;