library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
-- write the Flipflops packege declaration
entity Branch_Predictor is
port (
    PC_IF, PC_Branched:  in std_logic_vector(15 downto 0 );
    Z_Flag, C_Flag,History_bit_EX:in std_logic;
    index: in integer;
    clk: in std_logic;

    Instruc_op_ID,Instruc_op_EX, Instruc_op_RR, PC_ID, 
    PC_New_ID, PC_EX, PC_New_EX, PC_RR: in std_logic_vector(15 downto 0 );
    History_bit_ID,History_bit_EX: in std_logic;

    JAL_Haz, JRI_Haz, JLR_Haz, BEQ_Haz, BLT_Haz, BLE_Haz: out std_logic  ;
    PC_Predicted: out std_logic_vector(15 downto 0);
    LUT_index_op:out integer;
    History_bit_op: out std_logic;
);
end entity IF_ID;

architecture struct of IF_ID is
    type PC_arr   is array (0 to 63) of std_logic_vector(15 downto 0);
    type history  is array (0 to 63) of std_logic;
    type BTA      is array (0 to 63) of std_logic_vector(15 downto 0);
    signal i : integer := 0;
begin

Lookup_Search : process(PC_IF)
    begin
        for i in 0 to 63 loop
            if(PC_arr(i)=PC_IF)
                History_bit_op<=history(i);
                if(history(i)='1')
                    PC_Predicted<=BTA(i);
                else
                    PC_Predicted<=PC_IF;
                end if;
            else
                PC_Predicted   <= PC_IF;
                History_bit_op <='0';
            end if;
    end process;

Entry_Update : process(clk)
    begin   
        JAL_Haz<='0';
        JLR_Haz<='0';
        JRI_Haz<='0';
        BEQ_Haz<='0';
        BLT_Haz<='0';
        BLE_Haz<='0';
        if((Instruc_op_ID="1100") and (History_bit_ID='0'))----New JAL instruction
            PC_arr(i) :=PC_ID;
            BTA(i)    :=PC_New_ID;
            history(i):='1';
            i:=i+1;
            JAL_Haz<='1';
            
        if((Instruc_op_RR="1101") and (History_bit_RR='0'))----New JLR instruction
            PC_arr(i):=PC_RR;
            BTA(i):=    PC_New_RR;
            history(i):='1';
            i:=i+1;
            JLR_Haz<='1';

        if((Instruc_op_EX="1111") and (History_bit_EX='0'))----New JRI instruction
            PC_arr(i):=PC_EX;
            BTA(i):=    PC_New_EX;
            history(i):='1';
            i:=i+1;
            JRI_Haz<='1';

        if((Instruc_op_EX="1000"))----BEQ in EX stage
            if((history_bit='1') and Z_Flag= '0')
                
            end if;
        
        else
            null;
        end if;

    end process;
end struct;