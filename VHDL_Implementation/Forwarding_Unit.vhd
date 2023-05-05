library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
-- write the Flipflops packege declaration
entity Forwarding_Unit is
port (
    RegC_EX,RegC_Mem,RegC_WB,RegA_RR, RegB_RR: in std_logic_vector(2 downto 0);
    RF_WR_EX, RF_WR_Mem, RF_WR_WB:in std_logic;    
    MuxA,MuxB: out std_logic_vector(1 downto 0);
	 Opcode_Ex: in std_logic_vector(3 downto 0)
);
end entity Forwarding_Unit;

architecture struct of Forwarding_Unit is
    
begin
----------------------Register of 16 bits----------------------------------------------
forwarding : process(RegC_EX,RegC_Mem,RegC_WB,RegA_RR, RegB_RR,RF_WR_EX , RF_WR_Mem, RF_WR_WB, Opcode_Ex)
    begin
		  if((RegA_RR=RegC_Mem) and (RF_WR_Mem='1')and (Opcode_Ex="0100")) then
				MuxA<="10";
        elsif((RegA_RR=RegC_EX)and (RF_WR_EX='1')) then
            MuxA<="01";
        elsif((RegA_RR=RegC_Mem) and (RF_WR_Mem='1'))  then
            MuxA<="10";
        elsif((RegA_RR=RegC_WB) and (RF_WR_WB='1'))  then
            MuxA<="11";
        else
            MuxA<="00";
        end if;
			
		  if((RegB_RR=RegC_Mem) and (RF_WR_Mem='1')and (Opcode_Ex="0100")) then
				MuxB<="10";
		  elsif((RegB_RR=RegC_EX) and (RF_WR_EX='1'))  then
            MuxB<="01";
        elsif((RegB_RR=RegC_Mem) and (RF_WR_Mem='1'))  then
            MuxB<="10";
        elsif((RegB_RR=RegC_WB) and (RF_WR_WB='1'))  then
            MuxB<="11";
        else 
            MuxB<="00";
        end if;
    end process;
end struct;