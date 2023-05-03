library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
-- write the Flipflops packege declaration
entity Haz_PC_controller is
port (
    PC_IF,PC_ID,PC_RR,PC_EX: in std_logic_vector(15 downto 0);
    H_JLR,H_JAL, H_BEX, LMSM_Haz: in std_logic;

    PC_New: out std_logic_vector(15 downto 0);
    PC_WR,IF_ID_flush,ID_RR_flush,RR_EX_flush, IF_ID_WR,ID_RR_WR,RR_EX_WR, EX_MEM_WR, MEM_WB_WR : out std_logic
    
);
end entity Haz_PC_controller;

architecture struct of Haz_PC_controller is
    
begin

Maalvika_KI_MAA_KI_CHUTTTT : process( PC_IF,PC_ID,PC_RR,PC_EX,
                                    LMSM, H_JLR,H_JAL, H_BEX, LMSM_Haz)

        variable f_ifid,f_idrr,f_rrex,w_ifid,w_idrr,w_rrex,w_exmem, w_memwb,w_PC:std_logic;
        variable PC_naya:std_logic_vector(15 downto 0);
        begin
            f_ifid:='0';
            f_idrr:='0';
            f_rrex:='0';
            w_ifid:='1';
            w_idrr:='1';
            w_rrex:='1';
            w_exmem:='1';
            w_memwb:='1';
            PC_naya:=PC_IF;
            w_PC:='1';
            if(H_BEX='1') then  
                PC_naya:=PC_EX;
                f_ifid:='1';
                f_idrr:='1';
                f_rrex:='1';
            elsif(H_JLR='1') then
                PC_naya:=PC_RR;
                f_ifid:='1';
                f_idrr:='1';
            elsif(H_JAL='1') then
                PC_naya:=PC_ID;
                f_ifid:='1';
            elsif(LMSM_Haz='1') then
                w_PC:='0';
                w_ifid:='0';
            else 
                null;
            end if;
            IF_ID_flush <= f_ifid;
            ID_RR_flush<=f_idrr;
            RR_EX_flush<=f_rrex;
            IF_ID_WR<=w_ifid;
            ID_RR_WR<=w_idrr;
            RR_EX_WR<=w_rrex;
            EX_MEM_WR<=w_exmem;
            MEM_WB_WR<=w_memwb;
            PC_New<=PC_naya;
            PC_WR<=w_PC;
        end process;
end struct;