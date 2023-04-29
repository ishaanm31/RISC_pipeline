library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity FSM is
	port(clock, reset, Z_flag, C_flag :in std_logic;
        T2_out :in std_logic_vector(15 downto 0);
        loop_count:in std_logic_vector(15 downto 0);
        alu_sel:out std_logic_vector(1 downto 0);    
        A1_sel : out std_logic_vector(1 downto 0);
        A3_sel : out std_logic_vector(2 downto 0);
        D3_sel : out std_logic_vector(2 downto 0);
        Reg_file_EN, mem_WR_Internal: out std_logic;
        C_ctrl, Z_ctrl: out std_logic;
        T1_WR,T2_WR,T3_WR,T4_WR,loop_count_WR: out std_logic;
        ALU_A_sel: out std_logic_vector(2 downto 0);
        ALU_B_sel, Mem_Add_Sel, Mem_In_Sel: out std_logic_vector(1 downto 0);
        T3_sel,T4_sel: out std_logic;
        loop_sel:out std_logic;
        instruc:in std_logic_vector(15 downto 0)
		);
end FSM;


architecture behave of FSM is
    --Defining States which we will be using
    type FSM_States   is (S0,S1,S2,S3,S4,S5,S6,S7,S8,S9);
    --initializing to S3 as it will directly go to S0 and our machine will start from S0
    signal State : FSM_States:=S3;
    --Using one hot encoding as we only have 10 States and will use only 10 DFF(i.e. less)
    --And our State transition will have less logic gates saving power, hardware and delay              (P.S. I googled how to do one hot encoding in vhdl)
    attribute enum_encoding : string;
    attribute enum_encoding of FSM_States : type is "one-hot";  -- encoding style of the enumerated type
	signal Flag: std_logic;
    --Flag signal which checks the condition for CZ of Intruction and C and Z flags
    --If Flag is 1 then only the operation(ADD and NAND) will be executed


begin
    
State_Transition : process(reset,State,clock)
    --process variables which will be assigned to the actual ones at the end.
    --If we use our orginal signal then it might get changed multiple times during the process
    variable next_state: FSM_States;
    variable v_alu_sel: std_logic_vector(1 downto 0);    
    variable v_loop_count_WR,v_loop_sel: std_logic;
    variable v_A1_sel : std_logic_vector(1 downto 0);
    variable v_A3_sel : std_logic_vector(2 downto 0);
    variable v_D3_sel : std_logic_vector(2 downto 0);
    variable v_Reg_file_EN, v_mem_WR_Internal: std_logic;
    variable v_C_ctrl, v_Z_ctrl: std_logic;
    variable v_T1_WR,v_T2_WR,v_T3_WR,v_T4_WR: std_logic;
    variable v_ALU_A_sel: std_logic_vector(2 downto 0);
    variable v_ALU_B_sel, v_Mem_Add_Sel, v_Mem_In_Sel: std_logic_vector(1 downto 0);
    variable v_T3_sel,v_T4_sel: std_logic;
    variable OP_code,OP_code1 :std_logic_vector(3 downto 0);
    variable v_LMSM_Imm :std_logic_vector(7 downto 0);
    begin   
        --Assigning all zeros and according to the state, it will be changed to a non zero value 
        --Most states only require some control variables, so defining them for every state is boring
        v_loop_count_WR := '0';
        v_alu_sel:="00";
        v_A1_sel:="00"; v_A3_sel:="000"; v_D3_sel:="000";
        v_T3_sel:='0';
        v_Reg_file_EN:='0';
        v_mem_WR_Internal:='0';
        v_C_ctrl:='0'; 
        v_Z_ctrl:='0';
        v_T1_WR:='0';v_T2_WR:='0';v_T3_WR:='0';v_T4_WR:='0';
        v_ALU_A_sel:="000";v_ALU_B_sel:="00";
        v_T4_sel:='0';
        v_Mem_Add_Sel:="00";
        v_Mem_In_Sel:="00";
        OP_code1:= Instruc(15 downto 12);
        OP_code:= T2_out(15 downto 12);
        v_LMSM_Imm:=T2_out(7 downto 0);
        v_loop_sel:='0';
        --Boolean Expression for Flag. T2(1) is C and T2(0) is Z form the instruction
        Flag<= (((not (T2_out(1))) and (not(T2_out(0)))) or (T2_out(1)and C_flag) or (T2_out(0)and Z_flag));

case State is --  making cases for states 
 
--------------------------		    
    when S0 =>
        v_A1_sel:="01";
        v_T1_WR:='1' ;
        v_Mem_Add_Sel:="00";
        v_T2_WR:='1';

        if(OP_code1="0011") then
            next_state:=S8;
        else next_state:= S1;
        end if;
    
-----------------------------------				    
    when S1 =>
        v_A1_sel:="10";
        v_T3_sel:='0';
        v_T3_WR:='1';
        v_T4_WR:='1';

        if(OP_code="0000") then
            if(Flag = '1') then
                next_state := S2;
            else next_state := S3;
            end if;
        elsif (OP_code="0001") then
            next_state := S2;

        elsif(OP_code="0010") then
            if(Flag = '1') then
                next_state := S2;
            else next_state := S3;
            end if;
            
        elsif(OP_code="0100") then
            next_state := S2;

        elsif(OP_code="0101") then
             next_state := S2;
        elsif(OP_code="0110") then
            next_state := S6;

        elsif(OP_code="0111") then
            next_state := S9;

        elsif(OP_code="1100") then
            next_state := S2;
            
        elsif(OP_code="1000") then
            v_D3_sel := "000";
            v_A3_sel := "010";
            v_Reg_file_EN := '1';
            next_state := S3;

        elsif(OP_code="1001") then
            v_D3_sel := "000";
            v_A3_sel := "010";
            v_Reg_file_EN := '1';
            next_state := S8;
    
        else 
            next_state:=S0;
        end if;
-----------------------------------		 
    when S2 =>
        if(OP_code="0000") then
            v_ALU_A_sel:="001";
            v_ALU_B_sel:="11";
            v_alu_sel:="00";
            v_Z_ctrl:='1';
            v_C_ctrl:='1';
	         v_T3_sel:='1';
            v_T3_WR:='1';
            next_state := S8;

        elsif (OP_code="0001") then
			   v_T3_sel:='1';
            v_T3_WR:='1';
            v_ALU_A_sel:="001";
            v_ALU_B_sel:="00";
            v_alu_sel:="00";
            v_Z_ctrl:='1';
            v_C_ctrl:='1';
            next_state:= S8;

        elsif(OP_code="0010") then
		      v_T3_sel:='1';
            v_T3_WR:='1';
            v_ALU_A_sel:="001";
            v_ALU_B_sel:="11";
            v_alu_sel:="01";
            v_Z_ctrl:='1';
            next_state := S8 ; 

        elsif(OP_code="0100") then
            v_ALU_A_sel:="011";
            v_ALU_B_sel:="11";
            v_alu_sel:="00";
				v_T4_sel:='1';
            v_T4_WR:='1';
            next_state:= S4;

        elsif(OP_code="0101") then
            v_ALU_A_sel:="011";
            v_ALU_B_sel:="11";
            v_alu_sel:="00";
				v_T4_sel:='1';
            v_T4_WR:='1';
            next_state:= S5;

        elsif(OP_code="1100") then
		      v_T3_sel:='1';
            v_T3_WR:='1';
            v_ALU_A_sel:="001";
            v_ALU_B_sel:="11";
            v_alu_sel:="10";
            v_Z_ctrl:='1';
            next_state := S3;

        else 
            next_state:=S0;

        end if;
-----------------------------------		
    when S3 =>
        v_ALU_A_sel:="000";
        v_alu_sel:="00";
        v_D3_sel:="101";
        v_A3_sel:="111";
        v_Reg_file_EN:='1';   
        if(OP_code="0000") then
            v_ALU_B_sel:= "10";
            next_state:=S0; 

        elsif (OP_code="0001") then
            v_ALU_B_sel:= "10";
            next_state:=S0; 
            
        elsif(OP_code="0010") then
            v_ALU_B_sel:= "10";
            next_state:=S0;
             
        elsif(OP_code="0011") then
            v_ALU_B_sel:= "10";
            next_state:=S0;
             
        elsif(OP_code="0100") then
            v_ALU_B_sel:= "10";
            next_state:=S0; 

        elsif(OP_code="0101") then
            v_ALU_B_sel:= "10";
            next_state:=S0; 
            
        elsif(OP_code="0110") then
            v_ALU_B_sel:= "10";
            next_state:=S0; 

        elsif(OP_code="0111") then
            v_ALU_B_sel:= "10";
            next_state:=S0;             

        elsif(OP_code="1100") then
            if(Z_flag='1') then
                v_ALU_B_sel:= "00";
            else 
				v_ALU_B_sel:= "10";
				end if;
			next_state:= S0;
        elsif(OP_code="1000") then
            v_ALU_B_sel:= "01";
            next_state:= S0;
        else 
            next_state:=S0;
        end if;
-----------------------------------

    when S4 => 
        v_Mem_Add_Sel := "01";
        v_D3_sel := "010";
        v_Reg_file_EN := '1';
        v_A3_sel := "010";
        next_state:=S3;

-----------------------------------
    when S5 =>
        v_Mem_Add_Sel := "10";
        v_Mem_In_Sel := "10";
        v_mem_WR_Internal := '1';
        next_state:=S3;

-------------------------------------

when S6 =>
        v_Mem_Add_Sel:="01";
        v_D3_sel:="010";
        v_A3_sel:="011";
        v_Reg_file_EN := v_LMSM_Imm(7-to_integer(unsigned(loop_count)));
        v_ALU_A_sel:="100";
        v_ALU_B_sel:="10";
        v_alu_sel:="00";
        v_loop_count_WR:='1';
        if(to_integer(unsigned(loop_count))<7) then
            next_state:=S7;
        else 
            v_loop_sel:='1';
            next_state:=S3; 
        end if;
---------------
    when S7 =>
        v_ALU_A_sel:="001";
        v_ALU_B_sel:="10";
        v_T3_WR:='1';
        v_T3_sel:='1';
        v_alu_sel:="00";
        next_state:=S6;
		  if(OP_code="0110") then
				 next_state:=S6;
			else
				 next_state:=S9;
			end if;
---------
    when S8 =>
        v_Reg_file_EN := '1';   
            if(OP_code="0000") then
                v_D3_sel:="011";
                v_A3_sel:="000";
                next_state:=S3;
            elsif (OP_code="0001") then
                v_D3_sel:="011";
                v_A3_sel:="001";
                next_state:=S3;
            elsif(OP_code="0010") then
                v_D3_sel:="011";
                v_A3_sel:="000";
                next_state:=S3;
            elsif(OP_code="0011") then
                v_D3_sel:="110";
                v_A3_sel:="010";
                next_state:=S3;
                        
            elsif(OP_code="1001") then
                v_D3_sel:="001";
                v_A3_sel:="101";
                next_state:=S0;
            else 
                next_state:=S0;
            end if;

    

    when S9 =>
        v_Mem_Add_Sel:="01";
        v_Mem_In_Sel:="01";
        v_A1_sel:="00";
        v_mem_WR_Internal := v_LMSM_Imm(7-to_integer(unsigned(loop_count)));
        v_ALU_A_sel:="100";
        v_ALU_B_sel:="10";
        v_alu_sel:="00";
        v_loop_count_WR:='1';
        if(to_integer(unsigned(loop_count))<7) then
            next_state:=S7;
        else 
            v_loop_sel:='1';
            next_state:=S3; 
        end if;
    
-----------------------------------
    when others =>  
        next_state:=S0;
end case;
    
    --clock_transistion.
    if(clock='1' and clock' event) then
        if(reset = '1') then  
		    state <= S0; 
		else
			state <= next_state; 
		end if;
	end if;
    --mapping to actual signal
    alu_sel<=v_alu_sel;
    loop_count_WR<=v_loop_count_WR;
    A1_sel<=v_A1_sel; A3_sel<=v_A3_sel; D3_sel<=v_D3_sel;
    T3_sel<=v_T3_sel;
    Reg_file_EN<=v_Reg_file_EN;
    mem_WR_Internal<=v_mem_WR_Internal;
    C_ctrl<=v_C_ctrl; 
    Z_ctrl<=v_Z_ctrl;
    T1_WR<=v_T1_WR; T2_WR<=v_T2_WR; T3_WR<=v_T3_WR ; T4_WR<=v_T4_WR;
    ALU_A_sel<=v_ALU_A_sel;ALU_B_sel<=v_ALU_B_sel;
	 T4_sel<=v_T4_sel;
    Mem_Add_Sel<=v_Mem_Add_Sel;
    Mem_In_Sel<=v_Mem_In_Sel;
	 loop_sel<= v_loop_sel;

    end process;
end behave;
    