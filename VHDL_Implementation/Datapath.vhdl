library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Datapath is
	port(
        --Inputs
        clock, reset:in std_logic;
		);
end Datapath;

architecture Struct of Datapath is
    --1. ALU
    component ALU_pipeline is
        port( sel: in std_logic_vector(2 downto 0); 
                ALU_A: in std_logic_vector(15 downto 0);
                ALU_B: in std_logic_vector(15 downto 0);
                ALU_c: out std_logic_vector(15 downto 0);
                C_F: out std_logic;
                Z_F: out std_logic
            );
    end component;

    --2. 16 bit 2x1 Mux
    component Mux16_2x1 is
        port(A0: in std_logic_vector(15 downto 0);
             A1: in std_logic_vector(15 downto 0);
             sel:in std_logic;
             F: out std_logic_vector(15 downto 0));

    end component;

    --3. 16 bit 4x1 Mux
    component Mux16_4x1 is
        port(A0: in std_logic_vector(15 downto 0);
            A1: in std_logic_vector(15 downto 0);
            A2: in std_logic_vector(15 downto 0);
            A3: in std_logic_vector(15 downto 0);
            sel: in std_logic_vector(1 downto 0);
            F: out std_logic_vector(15 downto 0));
    end component;
    
    --4. IFID
    component IF_ID is
        port (
            Instruc_in,PC_in: in std_logic_vector(15 downto 0 );
            LUT_index_in:in integer;
            History_bit_in: in std_logic;
        
            clk: in std_logic;
            WR_EN: in std_logic;
            cancelin: in std_logic;
            cancelout:out std_logic;
            Instruc_op,PC_op: out std_logic_vector(15 downto 0 );
            LUT_index_op:out integer;
            History_bit_op: out std_logic
        );
    end component;
    -----Instruction Decode
    component instr_decode is
        port
        (
            Inst : in std_logic_vector(15 downto 0);
            PC_in: in std_logic_vector(15 downto 0);
            RS1,RS2,RD : out std_logic_vector(2 downto 0);
            ALU_sel,D3_MUX,CZ,ALU3_MUX : out std_logic_vector(1 downto 0);
            Imm : out std_logic_vector(15 downto 0);
            RF_wr, C_modified, Z_modified, Mem_wr,Carry_sel,CPL,WB_MUX: out std_logic;
            OP : out std_logic_vector(3 downto 0);
            PC_ID : out std_logic_vector(15 downto 0);
            LM_SM_hazard : out std_logic;
            clk: in std_logic
        );
    end component;
    --5.IDRR
    component IDRR is
        port (
            clk: in std_logic;
            WR_EN: in std_logic;
            OP_in: in std_logic_vector(3 downto 0);
            RS1_in: in std_logic_vector(2 downto 0);
            RS2_in: in std_logic_vector(2 downto 0);
            RD_in: in std_logic_vector(2 downto 0);
            RF_wr_in: in std_logic;
            ALU_sel_in: in std_logic_vector(1 downto 0);
            Carry_sel_in: in std_logic;
            C_modified_in: in std_logic;
            Z_modified_in: in std_logic;
            Mem_wr_in: in std_logic;
            Imm_in: in std_logic_vector(15 downto 0);
            PC_in: in std_logic_vector(15 downto 0);
            D3_MUX_in: in std_logic_vector(1 downto 0);
            CPL_in: in std_logic;
            CN_in: in std_logic;
            WB_MUX_in: in std_logic;
            CZ_in: in std_logic_vector(1 downto 0);
            ALU3_MUX_in: in std_logic_vector(1 downto 0);
            OP_out: out std_logic_vector(3 downto 0);
            RS1_out: out std_logic_vector(2 downto 0);
            RS2_out: out std_logic_vector(2 downto 0);
            RD_out: out std_logic_vector(2 downto 0);
            RF_wr_out: out std_logic;
            ALU_sel_out: out std_logic_vector(1 downto 0);
            Carry_sel_out: out std_logic;
            C_modified_out: out std_logic;
            Z_modified_out: out std_logic;
            Mem_wr_out: out std_logic;
            Imm_out: out std_logic_vector(15 downto 0);
            PC_out: out std_logic_vector(15 downto 0);
            D3_MUX_out: out std_logic_vector(1 downto 0);
            CPL_out: out std_logic;
            CN_out: out std_logic;
            WB_MUX_out: out std_logic;
            CZ_out: out std_logic_vector(1 downto 0);
            ALU3_MUX_out: out std_logic_vector(1 downto 0));
        end component;

    --6. RREX
    component RREX is
        port(
            clk: in std_logic;
            WR_EN: in std_logic;
            OP_in: in std_logic_vector(3 downto 0);
            RS1_in: in std_logic_vector(2 downto 0);
            RS2_in: in std_logic_vector(2 downto 0);
            RD_in: in std_logic_vector(2 downto 0);
            RF_D1_in: in std_logic_vector(15 downto 0);
            RF_D2_in: in std_logic_vector( 15 downto 0);
            RF_wr_in: in std_logic;
            ALU_sel_in: in std_logic_vector(1 downto 0);
            Carry_sel_in: in std_logic;
            C_modified_in: in std_logic;
            Z_modified_in: in std_logic;
            Mem_wr_in: in std_logic;
            Imm_in: in std_logic_vector(15 downto 0);
            PC_in: in std_logic_vector(15 downto 0);
            D3_MUX_in: in std_logic_vector(1 downto 0);
            CPL_in: in std_logic;
            CN_in: in std_logic;
            WB_MUX_in: in std_logic;
            CZ_in: in std_logic_vector(1 downto 0);
            ALU3_MUX_in: in std_logic_vector(1 downto 0);
            OP_out: out std_logic_vector(3 downto 0);
            RS1_out: out std_logic_vector(2 downto 0);
            RS2_out: out std_logic_vector(2 downto 0);
            RD_out: out std_logic_vector(2 downto 0);
            RF_D1_out: out std_logic_vector(15 downto 0);
            RF_D2_out: out std_logic_vector( 15 downto 0);
            RF_wr_out: out std_logic;
            ALU_sel_out: out std_logic_vector(1 downto 0);
            Carry_sel_out: out std_logic;
            C_modified_out: out std_logic;
            Z_modified_out: out std_logic;
            Mem_wr_out: out std_logic;
            Imm_out: out std_logic_vector(15 downto 0);
            PC_out: out std_logic_vector(15 downto 0);
            D3_MUX_out: out std_logic_vector(1 downto 0);
            CPL_out: out std_logic;
            CN_out: out std_logic;
            WB_MUX_out: out std_logic;
            CZ_out: out std_logic_vector(1 downto 0);
            ALU3_MUX_out: out std_logic_vector(1 downto 0)
            );
        end component;
    --7. EX_MEM
    component EXMEM is
        port (
            clk: in std_logic;
            WR_EN: in std_logic;
            OP_in: in std_logic_vector(3 downto 0);
            RS1_in: in std_logic_vector(2 downto 0);
            RS2_in: in std_logic_vector(2 downto 0);
            RD_in: in std_logic_vector(2 downto 0);
            RF_D1_in: in std_logic_vector(15 downto 0);
            RF_D2_in: in std_logic_vector( 15 downto 0);
            RF_wr_in: in std_logic;
            ALU_sel_in: in std_logic_vector(1 downto 0);
            Carry_sel_in: in std_logic;
            C_modified_in: in std_logic;
            Z_modified_in: in std_logic;
            Mem_wr_in: in std_logic;
            Imm_in: in std_logic_vector(15 downto 0);
            PC_in: in std_logic_vector(15 downto 0);
            D3_MUX_in: in std_logic_vector(1 downto 0);
            CPL_in: in std_logic;
            CN_in: in std_logic;
            ALU1_C_in: in std_logic_vector(15 downto 0);
            ALU3_C_in: in std_logic_vector(15 downto 0);
            WB_MUX_in: in std_logic;
            CZ_in: in std_logic_vector(1 downto 0);
            ALU3_MUX_in: in std_logic_vector(1 downto 0);
            OP_out: out std_logic_vector(3 downto 0);
            RS1_out: out std_logic_vector(2 downto 0);
            RS2_out: out std_logic_vector(2 downto 0);
            RD_out: out std_logic_vector(2 downto 0);
            RF_D1_out: out std_logic_vector(15 downto 0);
            RF_D2_out: out std_logic_vector( 15 downto 0);
            RF_wr_out: out std_logic;
            ALU_sel_out: out std_logic_vector(1 downto 0);
            Carry_sel_out: out std_logic;
            C_modified_out: out std_logic;
            Z_modified_out: out std_logic;
            Mem_wr_out: out std_logic;
            Imm_out: out std_logic_vector(15 downto 0);
            PC_out: out std_logic_vector(15 downto 0);
            D3_MUX_out: out std_logic_vector(1 downto 0);
            CPL_out: out std_logic;
            CN_out: out std_logic;
            ALU1_C_out: out std_logic_vector(15 downto 0);
            ALU3_C_out: out std_logic_vector(15 downto 0);
            WB_MUX_out: out std_logic;
            CZ_out: out std_logic_vector(1 downto 0)
        
        );
    end component;
        
    --8. MEMWB
    component MEMWB is
        port (
            clk: in std_logic;
            WR_EN: in std_logic;
            OP_in: in std_logic_vector(3 downto 0);
            RS1_in: in std_logic_vector(2 downto 0);
            RS2_in: in std_logic_vector(2 downto 0);
            RD_in: in std_logic_vector(2 downto 0);
            RF_wr_in,CN_in: in std_logic;
            Data_out_WB_in: in std_logic_vector(15 downto 0);
            Imm_in: in std_logic_vector(15 downto 0);
            PC_in: in std_logic_vector(15 downto 0);
            D3_MUX_in: in std_logic_vector(1 downto 0);
            ALU3_C_in: in std_logic_vector(15 downto 0);
            OP_out: out std_logic_vector(3 downto 0);
            RS1_out: out std_logic_vector(2 downto 0);
            RS2_out: out std_logic_vector(2 downto 0);
            RD_out: out std_logic_vector(2 downto 0);
            RF_wr_out,CN_out: out std_logic;
            Data_out_WB_out: out std_logic_vector(15 downto 0);
            Imm_out: out std_logic_vector(15 downto 0);
            PC_out: out std_logic_vector(15 downto 0);
            D3_MUX_out: out std_logic_vector(1 downto 0);
            ALU3_C_out: out std_logic_vector(15 downto 0)
        );
    end component;
    --9. Register_File
    component Register_file is
        port (
        A1, A2, A3: in std_logic_vector(2 downto 0 );
        D3:in std_logic_vector(15 downto 0);
        RF_D_PC_WR: in std_logic_vector(15 downto 0);
      
        clock,Write_Enable,PC_WR:in std_logic;
      
        RF_D_PC_R:out std_logic_vector(15 downto 0):=(others=>'0');
        D1, D2:out std_logic_vector(15 downto 0)
        );
    end component Register_file;
    
    --10. D-flipflop with enable
    component dff_en is
        port(
           clk: in std_logic;
           reset: in std_logic;
           en: in std_logic;
           d: in std_logic;
           q: out std_logic
        );
     end component;
    
    --10. ROM
    component ROM is
        port (Mem_Add: in std_logic_vector(15 downto 0 );
        Mem_Data_Out:out std_logic_vector(15 downto 0));
        
    end component ROM;

    --11. RAM
    component Memory is
        port (Mem_Add: in std_logic_vector(15 downto 0 );
        Mem_Data_In:in std_logic_vector(15 downto 0);
        PC_Add:in std_logic_vector(15 downto 0);
        clock,Write_Enable:in std_logic;
        Mem_Data_Out:out std_logic_vector(15 downto 0));    
    end component Memory;

    --12. adder
    component adder is
        port( 
            Inp1,Inp2: in std_logic_vector(15 downto 0);
            Outp: out std_logic_vector(15 downto 0)
            );
    end component;

    component Haz_PC_controller is
        port (
            PC_IF,PC_ID,PC_RR,PC_EX: in std_logic_vector(15 downto 0);
            LMSM, H_JLR,H_JAL, H_BEX, LMSM_Haz: in std_logic;
        
            PC_New: out std_logic_vector(15 downto 0);
            PC_WR,IF_ID_flush,ID_RR_flush,RR_EX_flush, IF_ID_WR,ID_RR_WR,RR_EX_WR, EX_MEM_WR, MEM_WB_WR : out std_logic
            
        );
    end component Haz_PC_controller;

    component Haz_JLR is
        port (
            Instruc_OPCode_RR:in std_logic_vector(3 downto 0);
            Hist_RR: in std_logic;
            H_JLR:out std_logic
        );
    end component Haz_JLR;

    component Haz_JAL is
        port (
            Instruc_OPCode_ID:in std_logic_vector(3 downto 0);
            Hist_ID: in std_logic;
            H_Jal:out std_logic
        );
    end component Haz_JAL;

    component Haz_BEX is
        port (
            Instruc_OPCode_EX:in std_logic_vector(3 downto 0);
            Hist_EX: in std_logic;
            ZFlag,CFlag:in std_logic;
        
            H_BEX:out std_logic;
            HType:out std_logic_vector(1 downto 0)
            --0->BEQ
            --1->BLT
            --2->BLE
            --3->JRI
        );
    end component Haz_BEX;
    ---Forwarding Unit
    component Forwarding_Unit is
        port (
            RegC_EX,RegC_Mem,RegC_WB,RegA_RR, RegB_RR: in std_logic_vector(2 downto 0);
            RF_WR_EX, RF_WR_Mem, RF_WR_WB:in std_logic;    
            MuxA,MuxB: out std_logic_vector(1 downto 0)
        );
    end component Forwarding_Unit;
    
    --Signal cancelling
    signal CN_IFID,CN_IDRR,CN_RREX,CN_EXMEM,CN_MEMWB : std_logic;
    --WR_EN signals
    signal WREN_IFID,WREN_IDRR,WREN_RREX,WREN_EXMEM,WREN_MEMWB : std_logic;

    --Signals required for IF
    signal Instruc, PC_IF : std_logic_vector(15 downto 0);
    --Signals for ID:
    signal PC_1 : std_logic_vector(15 downto 0);
    signal Instruc_ID : std_logic_vector(15 downto 0);
    signal CNpass1 : std_logic;
    signal OP_ID: std_logic_vector(3 downto 0);
    signal RS1_ID: std_logic_vector(2 downto 0);
    signal RS2_ID: std_logic_vector(2 downto 0);
    signal RD_ID: std_logic_vector(2 downto 0);
    signal RF_wr_ID: std_logic;
    signal ALU_sel_ID: std_logic_vector(1 downto 0);
    signal Carry_sel_ID: std_logic;
    signal C_modified_ID: std_logic;
    signal Z_modified_ID: std_logic;
    signal Mem_wr_ID: std_logic;
    signal Imm_ID: std_logic_vector(15 downto 0);
    signal PC_ID: std_logic_vector(15 downto 0);
    signal D3_MUX_ID: std_logic_vector(1 downto 0);
    signal CPL_ID: std_logic;
    signal CN_ID: std_logic;
    signal WB_MUX_ID: std_logic;
    signal CZ_ID: std_logic_vector(1 downto 0);
    signal ALU3_MUX_ID: std_logic_vector(1 downto 0);
    -----Signals for RR
    signal muxA,muxB : std_logic_vector(2 downto 0);
    signal OP_RR: std_logic_vector(3 downto 0);
    signal RS1_RR,RS2_RR:std_logic_vector(2 downto 0);
    signal RD_RR: std_logic_vector(2 downto 0);
    signal RF_wr_RR:std_logic;
    signal ALU_sel_RR: std_logic_vector(1 downto 0);
    signal Carry_sel_RR: std_logic;
    signal C_modified_RR: std_logic;
    signal Z_modified_RR: std_logic;
    signal Mem_wr_RR: std_logic;
    signal Imm_RR,rf_d1_RR,rf_d2_RR: std_logic_vector(15 downto 0);
    signal PC_RR: std_logic_vector(15 downto 0);
    signal D3_MUX_RR:  std_logic_vector(1 downto 0);
    signal CPL_RR:  std_logic;
    signal CN_Pass2,CN_RREX:  std_logic;
    signal WB_MUX_RR:  std_logic;
    signal CZ_RR: std_logic_vector(1 downto 0);
    signal ALU3_MUX_RR:  std_logic(1 downto 0);  
    --Signals for EX
    signal OP_EX: std_logic_vector(3 downto 0);
    signal RS1_EX,RS2_EX:std_logic_vector(2 downto 0);
    signal RD_EX: std_logic_vector(2 downto 0);
    signal RF_wr_EX:std_logic;
    signal ALU_sel_EX: std_logic_vector(1 downto 0);
    signal Carry_sel_EX: std_logic;
    signal C_modified_EX: std_logic;
    signal Z_modified_EX: std_logic;
    signal Mem_wr_EX: std_logic;
    signal Imm_EX,rf_d1_EX,rf_d2_EX: std_logic_vector(15 downto 0);
    signal PC_EX: std_logic_vector(15 downto 0);
    signal D3_MUX_EX:  std_logic_vector(1 downto 0);
    signal CPL_EX:  std_logic;
    signal CN_EX:  std_logic;
    signal WB_MUX_EX:  std_logic;
    signal CZ_EX: std_logic_vector(1 downto 0);
    signal ALU3_MUX_EX:  std_logic(1 downto 0);  

    --Signals for MEM:
    signal mem_add,mem_add_internal,mem_in_internal,mem_out,mem_in : std_logic_vector(15 downto 0);
    signal mem_WR: std_logic;

    --Signals for WB
    signal Rd_WB:std_logic_vector(2 downto 0);
    signal WB_Mux_data: std_logic_vector(15 downto 0);

    --Signals for Branch Predictor

        signal PC_IF: std_logic_vector(15 downto 0 );
        signal Z_Flag, C_Flag,History_bit_EX : std_logic;
        signal index_EX: integer;
    
        signal Instruc_op_ID,Instruc_op_EX, Instruc_op_RR, PC_ID, 
        PC_New_ID, PC_EX, PC_New_EX, PC_RR: std_logic_vector(15 downto 0 );
        signal History_bit_ID,History_bit_EX: std_logic;
    
        signal JAL_Haz, JRI_Haz, JLR_Haz, BEQ_Haz, BLT_Haz, BLE_Haz:  std_logic;
        signal PC_New:  std_logic_vector(15 downto 0);
        signal LUT_index_op: integer;
        signal History_bit_op: std_logic;

    --All Write Enables----
    signal IF_ID_WR,ID_RR_WR, RR_EX_WR, EX_MEM_WR, MEM_WB_WR: std_logic;

    --Cancel Signals for each stage
    signal cancel_IF, cancel_ID, cancel_RR, cancel_EX,cancel_MEM, cancel_WB:std_logic;
    --Signals with Haz and Branch Controller
    signal PC_New,PC_next: std_logic_vector(15 downto 0);
    signal LMSM_Haz:std_logic;
begin
------------------IF component----------------------------
    MyROM: ROM port map( Mem_Add => PC_New , Mem_Data_Out=>Instruc);
    IF_add: ID_adder port map(PC_new,"0000000000000010",PC_IF);
-------------- IF_ID Pipeline Register-------------------------------------------
    IF_ID_Pipepline_Reg : IF_ID port map(
        Instruc_in<=Instruc,
        PC_in<=PC_new,
        clk<=clock,
        WR_EN<=WREN_IFID,
        CN_in<=CN_IFID,
        CN_out<=CNpass1,
        Instruc_op<=Instruc_ID,
        PC_op<=PC_1
    );
--------------------Instruc Decode-----------------------------------------------------
    Jainesh_instruc:instr_decode port map
    (
        Inst<=Instruc_ID,
        PC_in<=PC_1,
        RS1<=RS1_ID,
        RS2<=RS2_ID,
        RD <=RD_ID ,
        ALU_sel<=ALU_sel_ID ,
        D3_MUX<= D3_MUX_ID,CZ<= CZ_ID,ALU3_MUX<=ALU3_MUX_ID ,
        Imm <= Imm_ID,
        RF_wr<=RF_wr_ID, C_modified<=C_modified_ID, Z_modified<=Z_modified_ID ,
        Mem_wr<=Mem_wr_ID,Carry_sel<=Carry_sel_ID,CPL<=CPL_ID,WB_MUX<=WB_MUX_ID,
        OP<=OP_ID,
        PC_ID<= PC_ID,
        LM_SM_hazard<=LMSM_Haz,
        clk<=clock
    );

---------------------ID_RR_pipeline------------------
ID_RR_pipeline : IDRR port map
(
    clk <= clock,
    OP_in<=OP_ID,
    RS1_in<=RS1_ID,
    RS2_in<=RS2_ID,
    RD_in<=RD_ID,
    RF_wr_in<=RF_wr_ID,
    ALU_sel_in <= ALU_sel_ID,
    Carry_sel_in <=Carry_sel_ID,
    C_modified_in <=C_modified_ID,
    Z_modified_in <=Z_modified_ID,
    Mem_wr_in<=Mem_wr_ID,
    Imm_in<=Imm_ID,
    PC_in<=PC_ID,
    D3_MUX_in<=D3_MUX_ID,
    CPL_in<=CPL_ID,
    CN_in<=(CNpass1 or CN_IDRR),
    WB_MUX_in<=WB_MUX_ID,
    CZ_in<=CZ_ID,
    OP_out <= OP_RR,
    RS1_out<=RS1_RR,
    RS2_out<=RS2_RR,
    RD_out<=RD_RR,
    RF_wr_out<=RF_wr_RR,
    ALU_sel_out<=ALU_sel_RR,
    Carry_sel_out<=Carry_sel_RR,
    ALU3_MUX_out<=ALU3_MUX_ID,
    C_modified_out<=C_modified_RR,
    Z_modified_out<= Z_modified_RR,
    Mem_wr_out<=Mem_wr_RR,
    Imm_out<=Imm_RR,
    PC_out <=PC_RR,
    D3_MUX_out<=D3_MUX_RR,
    CPL_out<=CPL_RR,
    CN_out<=CNpass2,
    WB_MUX_out<=WB_MUX_RR,
    CZ_out<=CZ_RR,
    ALU3_MUX_out<=ALU3_MUX_RR  
);  
---------------RR-------------
RF : Regsiter_file port map(A1<=RS1_RR, A2<=RS2_RR, A3<=Rd_WB,
                            D3<=WB_Mux_data,
                            RF_D_PC_WR<= PC_next,

                            clock<=clock,Write_Enable <= ,PC_WR<= ,

                            RF_D_PC_R<= PC_New,
                            D1<=rf_d1_RR , D2<=rf_d2_RR);

MuxA:
MuxB:



--------------------branch predictor-----------
--------------------------Forwarding Unit-------------------------------
MovingFWD: Forwarding_Unit port map (
        RegC_EX<= ,RegC_Mem<=  ,RegC_WB<= ,RegA_RR<= , RegB_RR<= ,
        RF_WR_EX<= , RF_WR_Mem<=  , RF_WR_WB<=,    
        MuxA<= ,MuxB<=
    );




------------------Execution component----------------------------
ALU1 : ALU port map()
end Struct;
    