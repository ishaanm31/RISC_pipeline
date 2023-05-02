library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
-- write the Flipflops packege declaration
entity Hazard_EX_Branch is
port (
    HazEX:out std_logic;
    Cancel:out std_logic;
);
end entity Hazard_EX_Branch;

architecture struct of Hazard_EX_Branch is
begin

Lookup_Search : process(PC_IF)
    begin
        for i in 0 to 63 loop
            if(PC_arr(i)=PC_IF)
                History_bit_op<=history(i);
                if(history(i)='1')
                    PC_PredictedIF<=BTA(i);
                else
                    PC_PredictedIF<=PC_IF;
                end if;
            else
                PC_PredictedIF <= PC_IF;
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
        PC_New<= PC_Predicted_IF;

        if((Instruc_op_EX="1111") and (History_bit_EX='0'))----New JRI instruction
            PC_arr(i):=PC_EX;
            BTA(i)   :=PC_New_EX;
            history(i):='1';
            i:=i+1;
            JRI_Haz<='1';
            PC_New <=PC_New_Ex;

        else if((Instruc_op_EX="1000"))----BEQ in EX stage
            if((history_bit='1') and (Z_Flag= '0'))
                history(index_EX)<='0';
                BEQ_Haz<='1';
                PC_New <=PC_EX;

            else if((history_bit='0') and (Z_Flag= '1'))
                history(index_EX)<='1';
                BEQ_Haz<='1';
                PC_New <=PC_New_Ex;
            end if;
        
        else if((Instruc_op_EX="1001"))----BLT in EX stage
            if((history_bit='1') and (Z_Flag= '0'))
                history(index_EX)<='0';
                BLT_Haz<='1';
                PC_New <=PC_EX;

            else if((history_bit='0') and (Z_Flag= '1'))
                history(index_EX)<='1';
                BLT_Haz<='1';
                PC_New <=PC_New_Ex;
            end if;

        else if((Instruc_op_RR="1101") and (History_bit_RR='0'))----New JLR instruction
            PC_arr(i):=PC_RR;
            BTA(i):=    PC_New_RR;
            history(i):='1';
            i:=i+1;
            JLR_Haz<='1';
            PC_New <=PC_New_RR; 

        else if((Instruc_op_ID="1100") and (History_bit_ID='0'))----New JAL instruction
            PC_arr(i) :=PC_ID;
            BTA(i)    :=PC_New_ID;
            history(i):='1';
            i:=i+1;
            JAL_Haz<='1';
            PC_New <=PC_New_ID;
        else
            null;
        end if;

    end process;
end struct;