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
        port(
            clk: in std_logic;
            WR_EN: in std_logic;
            RegA_in, RegB_in, RegC_in : in std_logic_vector(2 downto 0);
            Imm_in,PC_in: in std_logic_vector(15 downto 0);
            Rf_wr_in, history_bit_in, c_modify_in, z_modify_in, mem_wr_in mem_mux_in, imm_mux_in : in std_logic
            Alu_sel_in : in std_logic_vector(1 downto 0);
            i_in : in integer;
            RegA_out, RegB_out, RegC_out : in std_logic_vector(2 downto 0);
            Imm_out, PC_out : in std_logic_vector(15 downto 0);
            Rf_wr_out, history_bit_out, c_modify_out, z_modify_out, mem_wr_out mem_mux_out, imm_mux_out: in std_logic
            Alu_sel_out : in std_logic_vector(1 downto 0);
            i_out : out integer;
        
            cancelin: in std_logic;
            cancelout: out std_logic;
            
            OpCode_in:in std_logic_vector(3 downto 0);
            OpCode_out: out std_logic_vector(3 downto 0);
        
            Last2_in : in std_logic_vector(1 downto 0);
            Last2_out : out std_logic_vector(1 downto 0)
        );
    end component;

    --6. RREX
    component RREX_reg is
        port(
            clk: in std_logic;
            WR_EN: in std_logic;
            Alu1_A_in : in std_logic_vector(15 downto 0);
            Alu1_B_in : in std_logic_vector(15 downto 0);
            Rf_D2_in : in std_logic_vector(15 downto 0);
            PC_in : in std_logic_vector(15 downto 0);
            Imm9_in : in std_logic_vector(15 downto 0);
            RegC_in : in std_logic_vector(2 downto 0);
            Rf_wr_in, c_modify_in, z_modify_in,history_bit_in, mem_wr_in, mem_mux_in : in std_logic;
            ALU_sel_in : in std_logic_vector(1 downto 0);
            i_in : in integer;
            Alu1_A_out : out std_logic_vector(15 downto 0);
            Alu1_B_out : out std_logic_vector(15 downto 0);
            Rf_D2_out : out std_logic_vector(15 downto 0);
            PC_out : out std_logic_vector(15 downto 0);
            Imm9_out : out std_logic_vector(15 downto 0);
            RegC_out : out std_logic_vector(2 downto 0);
            Rf_wr_out, c_modify_out, z_modify_out,history_bit_out, mem_wr_out, mem_mux_out : out std_logic;
            ALU_sel_out : out std_logic_vector(1 downto 0);
            i_out : out integer;
        
            cancelin:in std_logic;
            cancelout: out std_logic;
        
            OpCode_in:in std_logic_vector(3 downto 0);
            OpCode_out: out std_logic_vector(3 downto 0);
            
            Last2_in : in std_logic_vector(1 downto 0);
            Last2_out : out std_logic_vector(1 downto 0)
            );
        end component;
    --7. EX_MEM
    component EXMEM is
        port (
            clk: in std_logic;
            WR_EN: in std_logic;
            Alu1_C_in : in std_logic_vector(15 downto 0);
            Rf_D2_in : in std_logic_vector(15 downto 0);
            RegC_in : in std_logic_vector(2 donwto 0);
            Rf_wr_in,mem_wr_in,mem_mux_in : in std_logic;
            Alu1_C_out : out std_logic_vector(15 downto 0);
            Rf_D2_out : out std_logic_vector(15 downto 0);
            RegC_out : out std_logic_vector(2 downto 0);
            Rf_wr_out,mem_wr_out,mem_mux_out : out std_logic;
        
            cancelin:in std_logic;
            cancelout: out std_logic;
            OpCode_in:in std_logic_vector(3 downto 0);
            OpCode_out: out std_logic_vector(3 downto 0);
        
        );
    end component;
        
    --8. MEMWB
    component MEMWB is
        port (
            clk: in std_logic;
            WR_EN: in std_logic;
            Rf_D2_in : in std_logic_vector(15 downto 0);
            RegC_in : in std_logic_vector(2 downto 0);
            Rf_wr_in : in std_logic;
            RegA_in : in std_logic_vector(15 downto 0);
            RegB_in : in std_logic_vector(15 downto 0);
            Rf_D2_out : out std_logic_vector(15 downto 0);
            RegC_out : out std_logic_vector(2 downto 0);
            Rf_wr_out : out std_logic;
            RegA_out : out std_logic_vector(15 downto 0);
            RegB_out : out std_logic_vector(15 downto 0);
        
            cancelin:in std_logic;
            cancelout: out std_logic;
            OpCode_in:in std_logic_vector(3 downto 0);
            OpCode_out: out std_logic_vector(3 downto 0);
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

    --Signals required for IF
    signal Intruc, PCplus2, PC : std_logic_vector(15 downto 0);
    
    
    --Signals for ID:
    
    --Signals for RR.

    --Signals for EX


    --Signals for MEM:
    signal mem_add,mem_add_internal,mem_in_internal,mem_out,mem_in : std_logic_vector(15 downto 0);
    signal mem_WR: std_logic;

    --Signals for WB
    
begin
    MyROM: ROM port map( Mem_Add => PC , Mem_Data_Out=>Instruc);
    IF_add: ID_adder port map(PC,"0000000000000010",PCplus2);

    IF_RR_Pipepline_Reg : IF_RR port map();

end Struct;
    