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

    --5.IDRR
    component IDRR_reg is
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
            ALU3_MUX_in: in std_logic;
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
            ALU3_MUX_out: out std_logic
        end component;

    --6. RREX
    component RREX_reg is
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
            ALU3_MUX_in: in std_logic;
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
            ALU3_MUX_out: out std_logic
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
            ALU3_MUX_in: in std_logic;
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
            CZ_out: out std_logic_vector(1 downto 0);
            ALU3_MUX_out: out std_logic
        
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

    component Branch_Predictor is
        port (
            PC_IF, PC_Branched:  in std_logic_vector(15 downto 0 );
            Z_Flag, C_Flag:in std_logic;
            index_EX: in integer;
            clk: in std_logic;
        
            Instruc_op_ID,Instruc_op_EX, Instruc_op_RR, PC_ID, 
            PC_New_ID, PC_EX, PC_New_EX, PC_RR, PC_New_RR: in std_logic_vector(15 downto 0 );
            History_bit_ID,History_bit_EX, History_bit_RR: in std_logic;
        
            JAL_Haz, JRI_Haz, JLR_Haz, BEQ_Haz, BLT_Haz, BLE_Haz: out std_logic;
            PC_New: out std_logic_vector(15 downto 0);
            LUT_index_op:out integer;
            History_bit_op: out std_logic
        );
    end component Branch_Predictor;
    
    --Signals required for IF
    signal Intruc, PCplus2, PC : std_logic_vector(15 downto 0);
    
    --Signals for ID:
    PC_in : in std_logic_vector(15 downto 0);
    Instruction : in std_logic_vector(15 downto 0);
    out_RegA,out_RegB,out_RegC ,out_Alu_sel : out std_logic_vector(2 downto 0);
    out_Imm_out : out std_logic_vector(15 downto 0);
    out_rf_wr, out_c_modify, out_z_modify, out_mem_wr, out_mem_mux, out_imm_mux : out std_logic;
    out_opcode : out std_logic_vector(3 downto 0);
    out_Last2: out std_logic_vector(1 downto 0);
    PC_BP : out std_logic_vector(15 downto 0);
    out_LM_SM_hazard : out std_logic;
    out_mera_mux : out std_logic_vector(1 downto 0);
    --Signals for RR.

    --Signals for EX
    signal 

    --Signals for MEM:
    signal mem_add,mem_add_internal,mem_in_internal,mem_out,mem_in : std_logic_vector(15 downto 0);
    signal mem_WR: std_logic;

    --Signals for WB

    --Signals for Branch Predictor

        signal PC_IF, PC_Branched: std_logic_vector(15 downto 0 );
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
    
begin
------------------IF component----------------------------
    MyROM: ROM port map( Mem_Add => PC , Mem_Data_Out=>Instruc);
    IF_add: ID_adder port map(PC,"0000000000000010",PCplus2);
-------------- IF_ID Pipeline Register-------------------------------------------
    IF_ID_Pipepline_Reg : IF_ID port map(
    Instruc_in=>Instruc,PC_in=> PCplus2,
    LUT_index_in=>LUT_index_op,
    History_bit_in=>History_bit_op,

    clk=>clock,
    WR_EN=>IF_ID_WR,
    cancelin=>( not(JAL_Haz) and not(JRI_Haz) and not(JLR_Haz) and not() and not(BEQ_Haz) 
                and not(BLT_Haz) and not(BLE_Haz)),
    cancelout=>cancel_IF,
    Instruc_op =>intruc_ID ,PC_op=PC_ID,
    LUT_index_op=index_ID,
    History_bit_op=>History_bit_ID);
-------------------------------------------------------------------------
    --------------------branch predictor-----------
    BP: Branch_Predictor port (
        PC_IF=>PCplus2, PC_Branched=>PC_Branched,
        Z_Flag=>ZFlag, C_Flag=>CFlag,History_bit_EX=>History_bit_EX,
        index_EX=>index_EX,
        clk=>clock,    
        Instruc_op_ID=>Instruc_op_ID ,Instruc_op_EX=>Instruc_op_EX, 
        Instruc_op_RR=>Instruc_op_RR, PC_ID=>PC_ID, 
        PC_New_ID=>PC_New_ID, PC_EX=>PC_EX, PC_New_EX=>PC_New_EX, PC_RR=>PC_RR,
        History_bit_ID=>History_bit_ID,History_bit_EX=>History_bit_EX,
    
        JAL_Haz=>JAL_Haz, JRI_Haz=>JRI_Haz, JLR_Haz=>JLR_Haz, BEQ_Haz=>BEQ_Haz,
        BLT_Haz=>BLT_Haz, BLE_Haz=>BLE_Haz,
        PC_New=>PC_New,
        LUT_index_op=>LUT_index_op,
        History_bit_op=>History_bit_op
    );
    ---------------------------------------------------------





------------------Execution component----------------------------
ALU1 : ALU port map()
end Struct;
    