library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
-- write the Flipflops packege declaration
entity Haz_load is
port (
    Instruc_OPCode_EX,Instruc_OPCode_Mem:in std_logic_vector(3 downto 0);
    Ra_RR,Rb_RR,Rc_Ex: in std_logic_vector(2 downto 0);
    Load_Imm:out std_logic
);
end entity Haz_load;

architecture struct of Haz_load is
begin
    process(Instruc_OPCode_EX,Instruc_OPCode_Mem,Ra_RR,Rb_RR,Rc_Ex)
		variable var: std_logic;
        begin
			if((Instruc_OPCode_EX="0100") and (Instruc_OPCode_Mem/="0100")and((Ra_RR=Rc_EX) or (Rb_RR=Rc_EX))) then
                var:='1';
         else    
                var:='0';
			end if;
			Load_Imm<=var;
        end process;
end struct;