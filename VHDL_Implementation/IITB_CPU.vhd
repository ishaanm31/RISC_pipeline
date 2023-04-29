library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity IITB_CPU is
    port (
        --Clock and reset
        clock,Reset: in std_logic;
        --Input for External Memory Update
        Mem_Ext_WR:in std_logic;
        Mem_Ext_Data_in,Mem_Ext_Add : in std_logic_vector(15 downto 0)
    );
end entity;

architecture arch of IITB_CPU is
--Initiating FSM and Datapaths
    component FSM is
        port(clock, reset, 
            --OutPuts from the Datapath
            Z_flag, C_flag :in std_logic;
            T2_out :in std_logic_vector(15 downto 0);
            loop_count:in std_logic_vector(15 downto 0);

            --Inputs to the Datapath
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
    end component;

    component Datapath is
        port(
            --Inputs
            clock, reset:in std_logic;
    
            --Outputs from FSM, basically Control Variables
            alu_sel:in std_logic_vector(1 downto 0);    
            A1_sel : in std_logic_vector(1 downto 0);
            A3_sel : in std_logic_vector(2 downto 0);
            D3_sel : in std_logic_vector(2 downto 0);
            Reg_file_EN, mem_WR_Internal: in std_logic;
            C_ctrl, Z_ctrl: in std_logic;
            T1_WR,T2_WR,T3_WR,T4_WR,loop_count_WR: in std_logic;        
            ALU_A_sel: in std_logic_vector(2 downto 0);
            ALU_B_sel, Mem_Add_Sel, Mem_In_Sel: in std_logic_vector(1 downto 0);
            T3_sel,T4_sel: in std_logic;
            loop_sel:in std_logic;
            --Inputs for the FSM
            Z_flag, C_flag: out std_logic;
            T2_out : buffer std_logic_vector(15 downto 0);
            loop_count:buffer std_logic_vector(15 downto 0);
            --External Memory Control
            Mem_Ext_WR:in std_logic;
            Mem_Ext_Data_in,Mem_Ext_Add : in std_logic_vector(15 downto 0);
            instruc:out std_logic_vector(15 downto 0)
            );
    end component;
--Initiating Signals to connect FSM to Datapath and mapping Input outputs of the whole machine
    --Outs from FSM and Ins to Datapath
        --Mux select lines
            signal S_alu_sel: std_logic_vector(1 downto 0);    
            signal S_A1_sel :  std_logic_vector(1 downto 0);
            signal S_A3_sel :  std_logic_vector(2 downto 0);
            signal S_D3_sel :  std_logic_vector(2 downto 0);      
            signal S_ALU_A_sel:  std_logic_vector(2 downto 0);
            signal S_ALU_B_sel, S_Mem_Add_Sel, S_Mem_In_Sel:  std_logic_vector(1 downto 0);
            signal S_T3_sel,S_T4_sel:  std_logic;
        --Write Enable Signals 
            signal S_Reg_file_EN, S_mem_WR_Internal:  std_logic;
            signal S_C_ctrl, S_Z_ctrl:  std_logic;
            signal S_T1_WR, S_T2_WR, S_T3_WR, S_T4_WR, S_loop_count_WR:  std_logic;  
    --Outs from Datapath and Ins to FSM
        --Carry and Zero Flags
            signal S_Z_flag, S_C_flag:  std_logic;
        --Register T2(Instructions) and Loop Counter for LM and SM
            signal  S_T2_out : std_logic_vector(15 downto 0);
            signal S_loop_count: std_logic_vector(15 downto 0);
    --Test Vector Output of the Machine
        signal S_T1_out,S_instruc:  std_logic_vector(15 downto 0);
        signal S_loop_sel:std_logic;
        
begin
    My_FSM: FSM port map(
        clock=>clock, reset=>reset, 
        --OutPuts from the Datapath
        Z_flag=> S_Z_flag, C_flag =>S_C_flag,
        T2_out=>S_T2_out,
        loop_count=>S_loop_count ,
        loop_sel=>S_loop_sel,
        --Inputs to the Datapath
        alu_sel=>S_alu_sel,   
        A1_sel => S_A1_sel,
        A3_sel =>S_A3_sel,
        D3_sel =>S_D3_sel,
        Reg_file_EN => S_Reg_file_EN, mem_WR_Internal=> S_mem_WR_Internal,
        C_ctrl=> S_C_ctrl, Z_ctrl=>S_Z_ctrl,
        T1_WR=> S_T1_WR,T2_WR=> S_T2_WR ,
        T3_WR => S_T3_WR,T4_WR => S_T4_WR,
        loop_count_WR=> S_loop_count_WR,
        ALU_A_sel=> S_ALU_A_sel,
        ALU_B_sel=> S_ALU_B_sel,
        T3_sel=>S_T3_sel ,T4_sel=>S_T4_sel , Mem_Add_Sel=> S_Mem_Add_Sel, Mem_In_Sel=>S_Mem_In_Sel,
        instruc=>S_instruc
    );

    
    My_Datapath: Datapath port map(
        clock=>clock, reset=>reset, 
        --OutPuts from the Datapath
        Z_flag=> S_Z_flag, C_flag =>S_C_flag,
        T2_out=>S_T2_out,
        loop_count=>S_loop_count,

        --Inputs to the Datapath
        alu_sel=>S_alu_sel,   
        A1_sel => S_A1_sel,
        A3_sel =>S_A3_sel,
        D3_sel =>S_D3_sel,
        Reg_file_EN => S_Reg_file_EN, mem_WR_Internal=> S_mem_WR_Internal,
        C_ctrl=> S_C_ctrl, Z_ctrl=>S_Z_ctrl,
        T1_WR=> S_T1_WR,T2_WR=> S_T2_WR ,
        T3_WR => S_T3_WR,T4_WR => S_T4_WR,
        loop_count_WR=> S_loop_count_WR,
        ALU_A_sel=> S_ALU_A_sel,
        ALU_B_sel=> S_ALU_B_sel,
        T3_sel=>S_T3_sel ,T4_sel=>S_T4_sel, Mem_Add_Sel=> S_Mem_Add_Sel, Mem_In_Sel=>S_Mem_In_Sel,
        --Outputs for testing
        --Input pins for memory control
        Mem_Ext_WR=>Mem_Ext_WR,
        Mem_Ext_Data_in=> Mem_Ext_Data_in,
        Mem_Ext_Add =>Mem_Ext_Add,
        loop_sel=>S_loop_sel,
        instruc=>S_instruc
    );
end architecture arch;