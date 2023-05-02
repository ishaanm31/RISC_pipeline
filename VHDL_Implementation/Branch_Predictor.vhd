library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
-- write the Flipflops packege declaration
entity Branch_Predictor is
port (
    PC_IF, PC_Branched:  in std_logic_vector(15 downto 0 );
    Z_Flag, C_Flag:in std_logic;
    index_EX: in integer;
    clk: in std_logic;

    Instruc_op_ID,Instruc_op_EX, Instruc_op_RR:std_logic_vector(3 downto 0); 
	 PC_ID, PC_New_ID, PC_EX, PC_New_EX, PC_RR, PC_New_RR: in std_logic_vector(15 downto 0 );
    History_bit_ID,History_bit_EX, History_bit_RR: in std_logic;

    JAL_Haz, JRI_Haz, JLR_Haz, BEQ_Haz, BLT_Haz, BLE_Haz: out std_logic;
    PC_New: out std_logic_vector(15 downto 0);
    LUT_index_op:out integer;
    History_bit_op: out std_logic
);
end entity Branch_Predictor;

architecture struct of Branch_Predictor is
    type bit16arr   is array (0 to 63) of std_logic_vector(15 downto 0);
    type bitarray  is array (0 to 63) of std_logic;
	 signal PC_arr,BTA: bit16arr;
	 signal history:bitarray;
    signal i : integer :=0;
    signal PC_PredictedIF:std_logic_vector(15 downto 0);
begin

Lookup_Search : process(PC_IF,PC_arr,history,BTA)
    begin
        for j in 0 to 63 loop
            if(PC_arr(j) = PC_IF) then
                History_bit_op<=history(j);
					 LUT_index_op<=j;
                if(history(j)='1') then
                    PC_PredictedIF<=BTA(j);
                else
                    PC_PredictedIF<=PC_IF;
                end if;
            else
                PC_PredictedIF <= PC_IF;
                History_bit_op <='0';
					 LUT_index_op<=0;
            end if;
			end loop;
    end process;

Entry_Update : process(clk,Instruc_op_ID,PC_New_ID,PC_ID,History_bit_ID,PC_PredictedIF,Instruc_op_EX,History_bit_EX,PC_EX,i,PC_New_EX,PC_New_Ex,Z_Flag,index_EX,Instruc_op_RR,History_bit_RR,PC_RR,PC_New_RR)
    begin   
        JAL_Haz<='0';
        JLR_Haz<='0';
        JRI_Haz<='0';
        BEQ_Haz<='0';
        BLT_Haz<='0';
        BLE_Haz<='0';
        PC_New<= PC_PredictedIF;

        if((Instruc_op_EX="1111") and (History_bit_EX='0')) then----New JRI instruction
            PC_arr(i)<=PC_EX;
            BTA(i)   <=PC_New_EX;
            history(i)<='1';
            i<=i+1;
            JRI_Haz<='1';
            PC_New <=PC_New_Ex;
				
				
        elsif((Instruc_op_EX="1000")) then----BEQ in EX stage
            if((History_bit_EX='1') and (Z_Flag= '0')) then
                history(index_EX)<='0';
                BEQ_Haz<='1';
                PC_New <=PC_EX;

            elsif((History_bit_EX='0') and (Z_Flag= '1')) then
                history(index_EX)<='1';
                BEQ_Haz<='1';
                PC_New <=PC_New_Ex;
            end if;
        
        elsif((Instruc_op_EX="1001")) then----BLT in EX stage
            if((History_bit_EX='1') and (Z_Flag= '0')) then
                history(index_EX)<='0';
                BLT_Haz<='1';
                PC_New <=PC_EX;

            elsif((History_bit_EX='0') and (Z_Flag= '1')) then
                history(index_EX)<='1';
                BLT_Haz<='1';
                PC_New <=PC_New_Ex;
            end if;

        elsif((Instruc_op_RR="1101") and (History_bit_RR='0')) then----New JLR instruction
            PC_arr(i)<=PC_RR;
            BTA(i)<=    PC_New_RR;
            history(i)<='1';
            i<=i+1;
            JLR_Haz<='1';
            PC_New <=PC_New_RR; 

        elsif((Instruc_op_ID="1100") and (History_bit_ID='0')) then----New JAL instruction
            PC_arr(i) <=PC_ID;
            BTA(i)    <=PC_New_ID;
            history(i)<='1';
            i<=i+1;
            JAL_Haz<='1';
            PC_New <=PC_New_ID;
        else
            null;
        end if;

    end process;
end struct;