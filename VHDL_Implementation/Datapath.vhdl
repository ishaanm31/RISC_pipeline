library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
entity Datapath is
	port(
        --Inputs
        clock, reset:in std_logic;
		  output_Reg : out std_logic_vector(7 downto 0) 
		);
end Datapath;

architecture Struct of Datapath is

    --1. ALU
    component ALU is
		port( sel: in std_logic_vector(1 downto 0); 
				ALU_A: in std_logic_vector(15 downto 0);
				ALU_B: in std_logic_vector(15 downto 0);
				C_in: in std_logic;
				Carry_sel: in std_logic;
				ALU_c: out std_logic_vector(15 downto 0);
				C_F: out std_logic;
				Z_F: out std_logic
			);
	 end component;
	 
	 --2. 1 bit 4x1 Mux 
	 component Mux1_4x1 is
    port(A,B,C,D: in std_logic;
         Sel: in std_logic_vector(1 downto 0);
         F:out std_logic);
    end component;
	 
    --3. 16 bit 2x1 Mux
    component Mux16_2x1 is
        port(A0: in std_logic_vector(15 downto 0);
             A1: in std_logic_vector(15 downto 0);
             sel:in std_logic;
             F: out std_logic_vector(15 downto 0));
	 end component;

    --4. 16 bit 4x1 Mux
    component Mux16_4x1 is
        port(A0: in std_logic_vector(15 downto 0);
            A1: in std_logic_vector(15 downto 0);
            A2: in std_logic_vector(15 downto 0);
            A3: in std_logic_vector(15 downto 0);
            sel: in std_logic_vector(1 downto 0);
            F: out std_logic_vector(15 downto 0));
    end component;
    
    --5. IFID
    component IF_ID is
        port (
             Instruc_in,PC_in: in std_logic_vector(15 downto 0 );
				 CN_in: in std_logic;
				 clk: in std_logic;
				 WR_EN: in std_logic;				 
				 CN_out:out std_logic;
				 Instruc_op,PC_op: out std_logic_vector(15 downto 0 )
        );
    end component;
	 
    --6. Instruction Decoder
    component instr_decode is
        port
        (
            Instruction : in std_logic_vector(15 downto 0);
            PC_in: in std_logic_vector(15 downto 0);
            RS1,RS2,RD : out std_logic_vector(2 downto 0);
            ALU_sel,D3_MUX,CZ : out std_logic_vector(1 downto 0);
            Imm : out std_logic_vector(15 downto 0);
            RF_wr, C_modified, Z_modified, Mem_wr,Carry_sel,CPL,WB_MUX,ALUA_MUX,ALUB_MUX: out std_logic;
            OP : out std_logic_vector(3 downto 0);
            PC_ID : out std_logic_vector(15 downto 0);
            LM_SM_hazard : out std_logic;
            clk: in std_logic
        );
    end component;
	 
    --7. IDRR
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
				ALUA_MUX_in: in std_logic;
				ALUB_MUX_in: in std_logic;
            CZ_in: in std_logic_vector(1 downto 0);
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
				ALUA_MUX_out: out std_logic;
				ALUB_MUX_out: out std_logic;
            CZ_out: out std_logic_vector(1 downto 0));
        end component;

    --8. RREX
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
				ALUA_MUX_in: in std_logic;
				ALUB_MUX_in: in std_logic;
            CZ_in: in std_logic_vector(1 downto 0);
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
				ALUA_MUX_out: out std_logic;
				ALUB_MUX_out: out std_logic;
            CZ_out: out std_logic_vector(1 downto 0)
            );
        end component;
		  
    --9. EX_MEM
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
        
    --9. MEMWB
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
	 
    --10. Register_File
    component Register_file is
        port (
			  A1, A2, A3: in std_logic_vector(2 downto 0 );
			  D3:in std_logic_vector(15 downto 0);
			  RF_D_PC_WR: in std_logic_vector(15 downto 0);
			  Reg_data: out std_logic_vector(7 downto 0);
			  clock,Write_Enable,PC_WR:in std_logic;
			  RF_D_PC_R:out std_logic_vector(15 downto 0):=(others=>'0');
			  D1, D2:out std_logic_vector(15 downto 0)
		  );
    end component Register_file;
    
    --11. D-flipflop with enable
    component dff_en is
        port(
           clk: in std_logic;
           reset: in std_logic;
           en: in std_logic;
           d: in std_logic;
           q: out std_logic
        );
     end component;
    
    --12. ROM
    component ROM is
        port (
				Mem_Add: in std_logic_vector(15 downto 0 );
            Mem_Data_Out:out std_logic_vector(15 downto 0)
		  );
    end component ROM;

    --13. RAM
    component Memory is
        port (
				Mem_Add: in std_logic_vector(15 downto 0 );
				Mem_Data_In:in std_logic_vector(15 downto 0);
				clock,Write_Enable:in std_logic;
				Mem_Data_Out:out std_logic_vector(15 downto 0)
		  );    
    end component Memory;

    --14. adder
    component adder is
        port( 
            Inp1,Inp2: in std_logic_vector(15 downto 0);
            Outp: out std_logic_vector(15 downto 0)
            );
    end component;
	 
	 --15. complementor
	 component complementor is
		  port( 
		      Cpl: in std_logic; 
			   Inp: in std_logic_vector(15 downto 0);
			   Outp: out std_logic_vector(15 downto 0));
	 end component; 
	 
-----Hazard Units: Used To Mitigate Data and Control Hazards(details in report)
-----PC Controller: for control Hazards 

    component Haz_PC_controller is
        port (
            PC_IF,PC_ID,PC_RR,PC_EX,PC_Mem: in std_logic_vector(15 downto 0);
            H_JLR,H_JAL, H_BEX, LMSM_Haz,H_Load_Imm,H_R0: in std_logic;        
            PC_New: out std_logic_vector(15 downto 0);
            PC_WR,IF_ID_flush,ID_RR_flush,RR_EX_flush,EX_Mem_flush, IF_ID_WR,ID_RR_WR,RR_EX_WR, EX_MEM_WR, MEM_WB_WR : out std_logic
            
        );
    end component Haz_PC_controller;

    component Haz_JLR is
        port (
            Instruc_OPCode_RR:in std_logic_vector(3 downto 0);
				cancel:in std_logic;
            H_JLR:out std_logic
        );
    end component Haz_JLR;

    component Haz_JAL is
        port (
            Instruc_OPCode_ID:in std_logic_vector(3 downto 0);
				cancel:in std_logic;
            H_Jal:out std_logic
        );
    end component Haz_JAL;

    component Haz_BEX is
        port (
            Instruc_OPCode_EX:in std_logic_vector(3 downto 0);
            ZFlag,CFlag:in std_logic;
				cancel:in std_logic;        
            H_BEX:out std_logic;
            HType:out std_logic_vector(1 downto 0)
            --0->BEQ
            --1->BLT
            --2->BLE
            --3->JRI
        );
    end component Haz_BEX;
	 
	 -- Hazard due to Load Instructions => 1 cycle stall
    component Haz_load is
        port (
            Instruc_OPCode_EX,Instruc_OPCode_Mem:in std_logic_vector(3 downto 0);
            Ra_RR,Rb_RR,Rc_Ex: in std_logic_vector(2 downto 0);
				cancel:in std_logic;
            Load_Imm:out std_logic
        );
    end component Haz_load;
	 
	 -- Hazard when Destination is R0
    component Haz_R0 is
        port (
            Rd_Mem:in std_logic_vector(2 downto 0);
				RF_WR_Mem:in std_logic;
				cancel:in std_logic;
            H_R0:out std_logic
        );
    end component Haz_R0;
	 
    ---Forwarding Unit => Data forwarding to mitigated data Hazards
    component Forwarding_Unit is
        port (
            RegC_EX,RegC_Mem,RegC_WB,RegA_RR, RegB_RR: in std_logic_vector(2 downto 0);
            RF_WR_EX, RF_WR_Mem, RF_WR_WB:in std_logic;    
            MuxA,MuxB: out std_logic_vector(1 downto 0);
				Opcode_Ex: in std_logic_vector(3 downto 0)
        );
    end component Forwarding_Unit;
    
    --Signal cancelling
    signal CN_IFID,CN_IDRR,CN_EXMEM,CN_MEMWB : std_logic;
	 
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
    signal WB_MUX_ID: std_logic;
	 signal ALUA_MUX_ID: std_logic;
	 signal ALUB_MUX_ID: std_logic;
    signal CZ_ID: std_logic_vector(1 downto 0);
	 
    -----Signals for RR
    signal muxA,muxB : std_logic_vector(2 downto 0);
    signal OP_RR: std_logic_vector(3 downto 0);
    signal RS1_RR,RS2_RR:std_logic_vector(2 downto 0);
    signal RD_RR: std_logic_vector(2 downto 0);
    signal RF_wr_RR,MUXRF_D1_sel,MUXRF_D2_sel:std_logic;
    signal ALU_sel_RR: std_logic_vector(1 downto 0);
    signal Carry_sel_RR: std_logic;
    signal C_modified_RR: std_logic;
    signal Z_modified_RR: std_logic;
    signal Mem_wr_RR: std_logic;
    signal Imm_RR,Imm2,rf_d1_RR1,rf_d2_RR1,rf_d1_RR2,rf_d2_RR2,rf_d1_RR3,rf_d2_RR3: std_logic_vector(15 downto 0);
    signal PC_RR1,PC_RR2: std_logic_vector(15 downto 0);
    signal D3_MUX_RR:  std_logic_vector(1 downto 0);
    signal CPL_RR:  std_logic;
    signal CNpass2,CN_RREX:  std_logic;
    signal WB_MUX_RR:  std_logic;
	 signal ALUA_MUX_RR: std_logic;
	 signal ALUB_MUX_RR: std_logic;
    signal CZ_RR: std_logic_vector(1 downto 0); 
	 
    --Signals for EX
    signal OP_EX: std_logic_vector(3 downto 0);
    signal RS1_EX,RS2_EX:std_logic_vector(2 downto 0);
    signal RD_EX: std_logic_vector(2 downto 0);
    signal RF_wr_EX1,RF_wr_EX:std_logic;
    signal ALU_sel_EX: std_logic_vector(1 downto 0);
    signal Carry_sel_EX: std_logic;
    signal C_modified,C_modified_EX: std_logic;
    signal Z_modified,Z_modified_EX: std_logic;
    signal Mem_wr_EX: std_logic;
    signal Imm_EX,Imm3,rf_d1_EX,rf_d2_EX,rf_d2_CPL,ALUA,ALUB,Alu1C_fw: std_logic_vector(15 downto 0);
    signal PC_EX,PCp2_EX: std_logic_vector(15 downto 0);
    signal D3_MUX_EX:  std_logic_vector(1 downto 0);
    signal CPL_EX:  std_logic;
    signal CN_EX,CN_EX1:  std_logic;
    signal WB_MUX_EX:  std_logic;
	 signal ALUA_MUX_EX: std_logic;
	 signal ALUB_MUX_EX: std_logic;
    signal CZ_EX: std_logic_vector(1 downto 0);
    signal Alu1C_EX,Alu3C_EX : std_logic_vector(15 downto 0);
    signal carry1,zero1,carry2,zero2 : std_logic:= '0';  

    --Signals for MEM:
    signal OP_MEM: std_logic_vector(3 downto 0);
    signal RS1_MEM,RS2_MEM:std_logic_vector(2 downto 0);
    signal RD_MEM: std_logic_vector(2 downto 0);
    signal RF_wr_MEM:std_logic;
    signal ALU_sel_MEM: std_logic_vector(1 downto 0);
    signal Carry_sel_MEM: std_logic;
    signal C_modified_MEM: std_logic;
    signal Z_modified_MEM: std_logic;
    signal Mem_wr_MEM: std_logic;
    signal Imm_MEM,rf_d1_MEM,rf_d2_MEM: std_logic_vector(15 downto 0);
    signal PC_MEM: std_logic_vector(15 downto 0);
    signal D3_MUX_MEM:  std_logic_vector(1 downto 0);
    signal CPL_MEM:  std_logic;
    signal CN_MEM:  std_logic;
    signal WB_MUX_MEM:  std_logic;
    signal CZ_MEM: std_logic_vector(1 downto 0);
    signal Alu1C_MEM,Alu3C_MEM : std_logic_vector(15 downto 0);
    signal Data_out,Data_out_MEM : std_logic_vector(15 downto 0);

    --Signals for WB
    signal OP_WB: std_logic_vector(3 downto 0);
    signal RS1_WB,RS2_WB:std_logic_vector(2 downto 0);
    signal RD_WB: std_logic_vector(2 downto 0);
    signal RF_wr_WB:std_logic;
    signal ALU_sel_WB: std_logic_vector(1 downto 0);
    signal Carry_sel_WB: std_logic;
    signal C_modified_WB: std_logic;
    signal Z_modified_WB: std_logic;
    signal WB_wr_WB: std_logic;
    signal Imm_WB,rf_d1_WB,rf_d2_WB: std_logic_vector(15 downto 0);
    signal PC_WB: std_logic_vector(15 downto 0);
    signal D3_MUX_WB:  std_logic_vector(1 downto 0);
    signal CPL_WB:  std_logic;
    signal CN_WB:  std_logic;
    signal WB_MUX_WB:  std_logic;
    signal CZ_WB: std_logic_vector(1 downto 0);
    signal Alu1C_WB,Alu3C_WB : std_logic_vector(15 downto 0);
    signal Data_out_WB : std_logic_vector(15 downto 0);
    signal D3 : std_logic_vector(15 downto 0);
    signal rf_d3 : std_logic_vector(15 downto 0);

    --Signals for Branch Predictor
        signal Z_Flag, C_Flag : std_logic;
        signal index_EX: integer;    
        signal Instruc_op_ID,Instruc_op_EX, Instruc_op_RR, 
        PC_New_ID, PC_New_EX: std_logic_vector(15 downto 0 );   
        signal JAL_Haz, JRI_Haz, JLR_Haz, BEQ_Haz, BLT_Haz, BLE_Haz, Load_Imm,H_R0:  std_logic;
        

    --All Write Enables----
    --signal IF_ID_WR,ID_RR_WR, RR_EX_WR, EX_MEM_WR, MEM_WB_WR: std_logic;

    --Cancel Signals for each stage
    --Signals with Haz and Branch Controller
    signal PC_New,PC_next: std_logic_vector(15 downto 0);
    signal LMSM_Haz,H_jal,H_jlr,H_bex,PC_WR,Ram_wr, RegF_wr,CFwr,ZFwr, Can_ID,Can_rr:std_logic;
    signal Fwd_Mux_selA,Fwd_Mux_selB, Htype:std_logic_vector(1 downto 0);

    
begin
------------------IF component----------------------------
    MyROM: ROM port map( Mem_Add => PC_New , Mem_Data_Out=>Instruc);
    IF_add: adder port map(PC_new,"0000000000000010",PC_IF);
-------------- IF_ID Pipeline Register--------------------
    IF_ID_Pipepline_Reg : IF_ID port map(
        Instruc_in=>Instruc,
        PC_in=>PC_new,
        clk=>clock,
        WR_EN=>WREN_IFID,
        CN_in=>CN_IFID,
        CN_out=>CNpass1,
        Instruc_op=>Instruc_ID,
        PC_op=>PC_1
    );
--------------------Instruc Decode-----------------------------------------------------
    instruc_decode:instr_decode port map(
        Instruction=>Instruc_ID,
        PC_in=>PC_1,
        RS1=>RS1_ID,
        RS2=>RS2_ID,
        RD =>RD_ID ,
        ALU_sel=>ALU_sel_ID ,
        D3_MUX=> D3_MUX_ID,CZ=> CZ_ID,
        Imm => Imm_ID,
        RF_wr=>RF_wr_ID, C_modified=>C_modified_ID, Z_modified=>Z_modified_ID ,
        Mem_wr=>Mem_wr_ID,Carry_sel=>Carry_sel_ID,CPL=>CPL_ID,WB_MUX=>WB_MUX_ID,
		  ALUA_MUX=>ALUA_MUX_ID,ALUB_MUX=>ALUB_MUX_ID,
        OP=>OP_ID,
        PC_ID=> PC_ID,
        LM_SM_hazard=>LMSM_Haz,
        clk=>clock
    );
	 Can_ID<=(CNpass1 or CN_IDRR);
---------------------ID_RR_pipeline----------------------------------------------------
	ID_RR_pipeline : IDRR port map
	(
		 clk => clock,
		 WR_EN=> WREN_IDRR,
		 OP_in=>OP_ID,
		 RS1_in=>RS1_ID,
		 RS2_in=>RS2_ID,
		 RD_in=>RD_ID,
		 RF_wr_in=>RF_wr_ID,
		 ALU_sel_in => ALU_sel_ID,
		 Carry_sel_in =>Carry_sel_ID,
		 C_modified_in =>C_modified_ID,
		 Z_modified_in =>Z_modified_ID,
		 Mem_wr_in=>Mem_wr_ID,
		 Imm_in=>Imm_ID,
		 PC_in=>PC_1,
		 D3_MUX_in=>D3_MUX_ID,
		 CPL_in=>CPL_ID,
		 CN_in=>Can_ID,
		 WB_MUX_in=>WB_MUX_ID,
		 ALUA_MUX_in=>ALUA_MUX_ID,ALUB_MUX_in=>ALUB_MUX_ID,
		 CZ_in=>CZ_ID,
		 OP_out => OP_RR,
		 RS1_out=>RS1_RR,
		 RS2_out=>RS2_RR,
		 RD_out=>RD_RR,
		 RF_wr_out=>RF_wr_RR,
		 ALU_sel_out=>ALU_sel_RR,
		 Carry_sel_out=>Carry_sel_RR,
		 C_modified_out=>C_modified_RR,
		 Z_modified_out=> Z_modified_RR,
		 Mem_wr_out=>Mem_wr_RR,
		 Imm_out=>Imm_RR,
		 PC_out =>PC_RR1,
		 D3_MUX_out=>D3_MUX_RR,
		 CPL_out=>CPL_RR,
		 CN_out=>CNpass2,
		 WB_MUX_out=>WB_MUX_RR,
		 ALUA_MUX_out=>ALUA_MUX_RR,ALUB_MUX_out=>ALUB_MUX_RR,
		 CZ_out=>CZ_RR
	);  
	---------------RR-----------------------------------------------------------------------------------
	RF : Register_file port map(A1=>RS1_RR, A2=>RS2_RR, A3=>RD_WB,
										 D3=>rf_d3,
										 RF_D_PC_WR=> PC_next,
										 clock=>clock,Write_Enable =>RegF_wr ,PC_WR=> PC_WR ,
										 RF_D_PC_R=> PC_New,
										 Reg_data => output_Reg,
										 D1=>rf_d1_RR1 , D2=>rf_d2_RR1);
	Imm2 <= Imm_RR + Imm_RR;
	MUXRF_D1_sel <= RS1_RR(2) or RS1_RR(1) or RS1_RR(0);
	MUXRF_D2_sel <= RS2_RR(2) or RS2_RR(1) or RS2_RR(0);
	MuxRF_D1 : Mux16_2x1 port map(PC_RR1,rf_d1_RR1,MUXRF_D1_sel,rf_d1_RR2);
	MuxRF_D2 : Mux16_2x1 port map(PC_RR1,rf_d2_RR1,MUXRF_D2_sel,rf_d2_RR2);
	MuxA1: Mux16_4x1 port map(rf_d1_RR2,Alu1C_fw,Data_out_MEM,rf_d3,Fwd_Mux_selA,rf_d1_RR3);
	MuxB1: Mux16_4x1 port map(rf_d2_RR2,Alu1C_fw,Data_out_MEM,rf_d3,Fwd_Mux_selB,rf_d2_RR3);
	Adder_RR : adder port map(Imm2,rf_d1_RR1,PC_RR2);
	RegF_wr<=(RF_wr_WB and(not(CN_WB)));
	Can_rr<=(CNpass2 or CN_RREX);
	--------------RR_EX pipeline------------------------------------------------------------------------
	RR_EX_pipeline : RREX port map(
		 clk => clock,
		 WR_EN => WREN_RREX,
		 OP_in=>OP_RR,
		 RS1_in=>RS1_RR,
		 RS2_in=>RS2_RR,
		 RD_in=>RD_RR,
		 RF_D1_in => rf_d1_RR3,
		 RF_D2_in => rf_d2_RR3,
		 RF_wr_in=>RF_wr_RR,
		 ALU_sel_in => ALU_sel_RR,
		 Carry_sel_in =>Carry_sel_RR,
		 C_modified_in =>C_modified_RR,
		 Z_modified_in =>Z_modified_RR,
		 Mem_wr_in=>Mem_wr_RR,
		 Imm_in=>Imm_RR,
		 PC_in=>PC_RR1,
		 D3_MUX_in=>D3_MUX_RR,
		 CPL_in=>CPL_RR,
		 CN_in=>Can_rr,
		 WB_MUX_in=>WB_MUX_RR,
		 ALUA_MUX_in=>ALUA_MUX_RR,ALUB_MUX_in=>ALUB_MUX_RR,
		 CZ_in=>CZ_RR,
		 OP_out => OP_EX,
		 RS1_out=>RS1_EX,
		 RS2_out=>RS2_EX,
		 RD_out=>RD_EX,
		 RF_D1_out => rf_d1_EX,
		 RF_D2_out => rf_d2_EX,
		 RF_wr_out=>RF_wr_EX1,
		 ALU_sel_out=>ALU_sel_EX,
		 Carry_sel_out=>Carry_sel_EX,
		 C_modified_out=>C_modified_EX,
		 Z_modified_out=> Z_modified_EX,
		 Mem_wr_out=>Mem_wr_EX,
		 Imm_out=>Imm_EX,
		 PC_out =>PC_EX,
		 D3_MUX_out=>D3_MUX_EX,
		 CPL_out=>CPL_EX,
		 CN_out=>CN_EX,
		 WB_MUX_out=>WB_MUX_EX,
		 ALUA_MUX_out=>ALUA_MUX_EX,ALUB_MUX_out=>ALUB_MUX_EX,
		 CZ_out=>CZ_EX
	);
	---------------Execution---------------------
	Imm3 <= Imm_EX + Imm_EX;
	PCp2_EX<=PC_EX+"0000000000000010";
	EX_MUX : Mux16_4x1 port map(Alu1C_EX,Imm_EX,Alu3C_EX,PCp2_EX,D3_MUX_EX,Alu1C_fw);
	COMPL : complementor port map(CPL_EX,rf_d2_EX,rf_d2_CPL);
	MUX_ALUA : Mux16_2x1 port map(rf_d1_EX,rf_d2_CPL,ALUA_MUX_EX,ALUA);
	MUX_ALUB : Mux16_2x1 port map(rf_d2_CPL,Imm_EX,ALUB_MUX_EX,ALUB);
	ALU1_EX :ALU port map(ALU_sel_EX,ALUA,ALUB,Carry_sel_EX,carry2,Alu1C_EX,carry1,zero1);
	ALU3_EX : adder port map(PC_EX,Imm3,ALU3C_EX);
	D_ff1 : dff_en port map(clock,reset,CFwr,carry1,carry2);
	D_ff2 : dff_en port map(clock,reset,ZFwr,zero1,zero2);
	MUX_C : Mux1_4x1 port map(C_modified_EX,carry2,zero2,'0',CZ_EX,C_modified);
	MUX_Z : Mux1_4x1 port map(Z_modified_EX,carry2,zero2,'0',CZ_EX,Z_modified);
	MUX_rfwr : Mux1_4x1 port map(RF_wr_EX1,zero2,carry2,'1',CZ_EX,RF_wr_EX);
	CFwr<=(C_modified and (not(CN_EX)));
	ZFwr<=(Z_modified and (not(CN_EX)));
	CN_EX1<=CN_EX or CN_EXMEM;
	-----------------EX_MEM pipeline----------
	EX_MEM_pipeline : EXMEM port map(
		 clk => clock,
		 WR_EN => WREN_EXMEM,
		 OP_in=>OP_EX,
		 RS1_in=>RS1_EX,
		 RS2_in=>RS2_EX,
		 RD_in=>RD_EX,
		 RF_D1_in => rf_d1_EX,
		 RF_D2_in => rf_d2_EX,
		 RF_wr_in=>RF_wr_EX,
		 ALU_sel_in => ALU_sel_EX,
		 Carry_sel_in =>Carry_sel_EX,
		 C_modified_in =>C_modified_EX,
		 Z_modified_in =>Z_modified_EX,
		 Mem_wr_in=>Mem_wr_EX,
		 Imm_in=>Imm_EX,
		 PC_in=>PC_EX,
		 D3_MUX_in=>D3_MUX_EX,
		 CPL_in=>CPL_EX,
		 CN_in=> CN_EX1,
		 WB_MUX_in=>WB_MUX_EX,
		 CZ_in=>CZ_EX,
		 ALU1_C_in => Alu1C_fw,
		 Alu3_C_in => Alu3C_EX,
		 OP_out => OP_MEM,
		 RS1_out=>RS1_MEM,
		 RS2_out=>RS2_MEM,
		 RD_out=>RD_MEM,
		 RF_D1_out => rf_d1_MEM,
		 RF_D2_out => rf_d2_MEM,
		 RF_wr_out=>RF_wr_MEM,
		 ALU_sel_out=>ALU_sel_MEM,
		 Carry_sel_out=>Carry_sel_MEM,
		 C_modified_out=>C_modified_MEM,
		 Z_modified_out=> Z_modified_MEM,
		 Mem_wr_out=>Mem_wr_MEM,
		 Imm_out=>Imm_MEM,
		 PC_out =>PC_MEM,
		 D3_MUX_out=>D3_MUX_MEM,
		 CPL_out=>CPL_MEM,
		 CN_out=>CN_MEM,
		 WB_MUX_out=>WB_MUX_MEM,
		 CZ_out=>CZ_MEM,
		 ALU1_C_out => Alu1C_MEM,
		 Alu3_C_out => Alu3C_MEM
	);
	--------------MEM--------------------------
	RAM_MEM : Memory port map(Alu1C_MEM,rf_d1_MEM,clock,RAM_wr,Data_out);
	WB_MUX_MEM1 : Mux16_2x1 port map(Alu1C_MEM,Data_out,WB_MUX_MEM,Data_out_MEM);
	Ram_wr<=(Mem_wr_MEM and (not(CN_MEM)));
	-----------MEM_WB pipeline-------------------------
	MEM_WB_pipeline : MEMWB port map(
		 clk => clock,
		 WR_EN => WREN_MEMWB,
		 OP_in=>OP_MEM,
		 RS1_in=>RS1_MEM,
		 RS2_in=>RS2_MEM,
		 RD_in=>RD_MEM,
		 RF_wr_in=>RF_wr_MEM,
		 Data_out_WB_in => Data_out_MEM,
		 Imm_in=>Imm_MEM,
		 PC_in=>PC_MEM,
		 D3_MUX_in=>D3_MUX_MEM,
		 CN_in=> CN_MEM,
		 Alu3_C_in => Alu3C_MEM,
		 OP_out => OP_WB,
		 RS1_out=>RS1_WB,
		 RS2_out=>RS2_WB,
		 RD_out=>RD_WB,
		 RF_wr_out=>RF_wr_WB,
		 Data_out_WB_out => rf_d3,
		 Imm_out=>Imm_WB,
		 PC_out =>PC_WB,
		 D3_MUX_out=>D3_MUX_WB,
		 CN_out=>CN_WB,
		 Alu3_C_out => Alu3C_WB
	);

	-----------WB--------------
	--------------------branch predictor-----------
	--------------------------Forwarding Unit-------------------------------
	MovingFWD: Forwarding_Unit port map (
			  RegC_EX=> RD_EX ,RegC_Mem=> RD_MEM ,RegC_WB=> RD_WB ,RegA_RR=>  RS1_RR, RegB_RR=> RS2_RR,
			  RF_WR_EX=>RF_wr_EX , RF_WR_Mem=>RF_wr_MEM  , RF_WR_WB=>RF_wr_WB ,    
			  MuxA=>Fwd_Mux_selA ,MuxB=>Fwd_Mux_selB,Opcode_Ex=>OP_EX
		 );
	----------------Hazard detection Units--------------------

	JLR: Haz_JLR port map (
			  Instruc_OPCode_RR=>OP_RR,
			  cancel=>Can_rr,
			  H_JLR=>H_jlr);

	Jal: Haz_JAL port map (
			  Instruc_OPCode_ID=>OP_ID,
			  cancel=>Can_ID,
			  H_Jal=>H_jal);

	BEX: Haz_BEX port map (
			  Instruc_OPCode_EX=>OP_EX,
			  ZFlag=>zero1,CFlag=>carry1,
			  cancel=>CN_EX1,
			  H_BEX=>H_bex,
			  HType=>Htype
			  --0->BEQ
			  --1->BLT
			  --2->BLE
			  --3->JRI
		 );
	Load: Haz_load port map(
					Instruc_OPCode_EX=>OP_EX,Instruc_OPCode_Mem=>OP_Mem,
					Ra_RR=>RS1_RR ,Rb_RR=>RS2_RR,Rc_Ex=>RD_EX,cancel=>CN_EX1,
					Load_Imm=>Load_Imm
			  );
	R0_bkl: Haz_R0 port map (
			  Rd_Mem=>RD_MEM,RF_WR_Mem=>RF_wr_MEM,cancel=>CN_MEM,
			  H_R0=>H_R0
		 );
	PC_hazard_ctrl:  Haz_PC_controller port map (
			  PC_IF=>PC_IF ,PC_ID => PC_ID ,PC_RR=>PC_RR2 ,PC_EX=>ALU3C_EX ,PC_Mem=>Data_out_MEM  ,
			  H_JLR=>H_jlr,H_JAL => H_jal, H_BEX =>H_bex , LMSM_Haz=> LMSM_Haz, H_Load_Imm=> Load_Imm, H_R0=>H_R0,
		 
			  PC_New=>PC_Next ,
			  PC_WR=>PC_WR ,IF_ID_flush=>CN_IFID ,ID_RR_flush=>CN_IDRR ,RR_EX_flush=>CN_RREX , EX_MEM_flush=>CN_EXMEM,
			  IF_ID_WR=> WREN_IFID,ID_RR_WR=>WREN_IDRR ,RR_EX_WR=> WREN_RREX , EX_MEM_WR=> WREN_EXMEM , 
			  MEM_WB_WR =>WREN_MEMWB
			  
		 );
	end Struct;
		 