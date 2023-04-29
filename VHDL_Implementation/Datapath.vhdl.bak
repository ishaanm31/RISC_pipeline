library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Datapath is
	port(
        --Inputs
        clock, reset:in std_logic;

        --Input from FSM, basically Control Variables
        alu_sel:in std_logic_vector(1 downto 0);    
        A1_sel : in std_logic_vector(1 downto 0);
        A3_sel : in std_logic_vector(2 downto 0);
        D3_sel : in std_logic_vector(2 downto 0);
        Reg_file_EN, mem_WR_Internal: in std_logic;
        C_ctrl, Z_ctrl: in std_logic;
        T1_WR,T2_WR,T3_WR,T4_WR,loop_count_WR: in std_logic;        
        ALU_A_sel: in std_logic_vector(2 downto 0);
        ALU_B_sel: in std_logic_vector(1 downto 0);
        T3_sel, Mem_Add_Sel, Mem_In_Sel: in std_logic;
        
        --Outputs to FSM
        Z_flag, C_flag: out std_logic;
        T1_out,T2_out ,T3_out: buffer std_logic_vector(15 downto 0);
        loop_count:buffer std_logic_vector(2 downto 0)
        --External Memory Updating Pins
        Mem_Ext_WR:in std_logic;
        Mem_Ext_Data_in,Mem_Ext_Add : in std_logic_vector(15 downto 0);
		);
end Datapath;

architecture Struct of Datapath is
    --1. ALU
    component ALU is
        port( sel: in std_logic_vector(1 downto 0); 
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
    
    --4. Temporary Register
    component Register_16bit is
        port (DataIn:in std_logic_vector(15 downto 0);
        clock,Write_Enable:in std_logic;
        DataOut:out std_logic_vector(15 downto 0));
        end component;
    
    --5. Register_File
    component Register_file is
        port (A1, A2, A3: in std_logic_vector(2 downto 0 );
              D3: in std_logic_vector(15 downto 0);
              clock,Write_Enable:in std_logic;
              D1, D2: out std_logic_vector(15 downto 0));
        end component;
    
    --6. Signed Extension 7(SE7)
    component SE7 is
        port (Raw: in std_logic_vector(8 downto 0 );
            Outp:out std_logic_vector(15 downto 0));
    end component;    
    --7.Shifter 7 (7SE)
    component Shifter7 is
        port (Raw: in std_logic_vector(8 downto 0 );
            Outp:out std_logic_vector(15 downto 0));
    end component Shifter7;
    --8.Signed Extension 10 (SE19)
    component SE10 is
        port (Raw: in std_logic_vector(5 downto 0 );
            Output:out std_logic_vector(15 downto 0));
    end component SE10;

    --9. D-flipflop with enable
    component dff_en is
        port(
           clk: in std_logic;
           reset: in std_logic;
           en: in std_logic;
           d: in std_logic;
           q: out std_logic
        );
     end component;
    
    --10. Memory of device
    component Memory is
        port (Mem_Add: in std_logic_vector(15 downto 0);
        Mem_Data_In:in std_logic_vector(15 downto 0);
        clock,Write_Enable:in std_logic;
        Mem_Data_Out:out std_logic_vector(15 downto 0));
    end component;

    --11. 3 bit Muxes
    component Mux3_8x1 is
        port(A0: in std_logic_vector(2 downto 0);
             A1: in std_logic_vector(2 downto 0);
             A2: in std_logic_vector(2 downto 0);
             A3: in std_logic_vector(2 downto 0);
             A4: in std_logic_vector(2 downto 0);
             A5: in std_logic_vector(2 downto 0);
             A6: in std_logic_vector(2 downto 0);
             A7: in std_logic_vector(2 downto 0);        
             sel:in std_logic_vector(2 downto 0);
             F: out std_logic_vector(2 downto 0));
    end component;

    component Mux3_4x1 is
        port(A0: in std_logic_vector(2 downto 0);
             A1: in std_logic_vector(2 downto 0);
             A2: in std_logic_vector(2 downto 0);
             A3: in std_logic_vector(2 downto 0);
             sel: in std_logic_vector(1 downto 0);
             F: out std_logic_vector(2 downto 0));
    end component;
    --12. 16 bit 8x1 mux
    component Mux16_8x1 is
        port(A0: in std_logic_vector(15 downto 0);
             A1: in std_logic_vector(15 downto 0);
             A2: in std_logic_vector(15 downto 0);
             A3: in std_logic_vector(15 downto 0);
             A4: in std_logic_vector(15 downto 0);
             A5: in std_logic_vector(15 downto 0);
             A6: in std_logic_vector(15 downto 0);
             A7: in std_logic_vector(15 downto 0);        
             sel:in std_logic_vector(2 downto 0);
             F: out std_logic_vector(15 downto 0));
    end component;
    --13. 3 Bit register for Loop Counter
    component Register_3bit is
        port (DataIn:in std_logic_vector(2 downto 0);
        clock,Write_Enable:in std_logic;
        DataOut:out std_logic_vector(2 downto 0));
    end component Register_3bit;

    --Signals required for ALU:
    signal alu_a, alu_b, alu_c: std_logic_vector(15 downto 0);
    signal carry_dff_inp, zero_dff_inp: std_logic;
    signal alu_sel1: std_logic_vector(1 downto 0);    
    
    --Signals for Register File:
    signal D1,D2,D3: std_logic_vector(15 downto 0);
    signal A1,A2,A3: std_logic_vector(2 downto 0);
    
    --Signals for temporary Registers.
    signal T3_in: std_logic_vector(15 downto 0);
    signal T4_out: std_logic_vector(15 downto 0);
    signal loop_count_IN,loop_count : std_logic_vector(2 downto 0);
    
    --Sig_Extended Signals
    signal T2_SE7_out: std_logic_vector(15 downto 0);
    signal T2_SE10_out: std_logic_vector(15 downto 0);
    signal T2_7Shift_out: std_logic_vector(15 downto 0);

    --Signals for memory:
    signal mem_add,mem_WR_Internal,mem_out,mem_in: std_logic_vector(15 downto 0);
    signal mem_WR: std_logic;
    
begin
-- Temporary registers and Loop Count register Instantiate
    T1: Register_16bit port map(DataIn => D1, clock => clock, Write_Enable => T1_WR, DataOut => T1_out);
    T2: Register_16bit port map(DataIn => mem_out, clock => clock, Write_Enable => T2_WR, DataOut => T2_out);
    T3: Register_16bit port map(DataIn => T3_in, clock => clock, Write_Enable => T3_WR, DataOut => T3_out);
    T4: Register_16bit port map(DataIn => D2, clock => clock, Write_Enable => T4_WR, DataOut => T4_out);
    loop_register : Register_3bit port map (DataIn => ALU_C, clock => clock, Write_Enable => loop_count_WR, DataOut => loop_count);
--Mux for T3 from 00->D1, 01-> ALU_C    
    T3_Mux: MUX16_2x1 port map(A0=> D1,A1=> alu_c, sel =>T3_sel, F=>T3_in);

--Register File Instantiate
    Reg_File: Register_file port map (A1, A2, A3, D3, clock, Reg_file_EN, D1, D2);
--A2 needs no Mux, it has only one input
    A2 <= T2_out(8 downto 6);

--Muxes for input to Register File

    A1_Mux: Mux3_4x1 port map(loop_count, "111",T2_out(11 downto 9) ,"000",A1_sel, A1);
    -- 00-> Loop Counter. Used for LM and SM Instruction
    -- 01-> Gives out Program Counter (R7) to RF_D1
    -- 10-> Gives out RA
    -- 11-> Don't Care condition
    A3_Mux: Mux3_8x1 port map (T2_out(5 downto 3),T2_out(8 downto 6),T2_out(11 downto 9),loop_count,
                               "111","111","111","111",A3_sel,A3);
    -- 00-> Gives rb to RF_D2
    -- 01-> Gives out Program Counter (R7) to RF_D1
    -- 10-> Gives out RA
    -- 11-> Don't Care condition
    D3_Mux: Mux16_8x1 port map(T1_out,T4_out,mem_out,T3_out,T2_SE7_out,
                                alu_c,"0000000000000000","0000000000000000",D3_sel,D3);
--Signed Extended signals of intructio(T2)
    T2_SE7  : SE7 port map(T2_out(8 downto 0),T2_SE7_out(15 downto 0))  ;
    T2_SE10 : SE10 port map(T2_out(5 downto 0),T2_SE10_out(15 downto 0));
    T2_shift: Shifter7 port map(T2_out(8 downto 0),T2_7Shift_out(15 downto 0));
--Components for ALU
    alu1 : ALU port map (ALU_A => alu_a, ALU_B => alu_b, ALU_C => alu_c, C_F => carry_dff_inp, Z_F => zero_dff_inp, sel => alu_sel);
    
    ALU_A_Mux : Mux16_8x1 port map(A0 => T1_out, A1 => T3_out, A2 => T4_out,A3 => T2_SE10_out,
                            A4=>loop_count,A5=>"0000000000000000",A6=>"0000000000000000",
                            A7=>"0000000000000000", sel => ALU_A_sel, F => alu_a);
    ALU_B_Mux : Mux16_4x1 port map(A0 => T3_out, A1 => T2_SE7_out, A2 => "0000000000000001", A3 => "0000000000000000", sel => ALU_B_sel, F => alu_b); 
    
    carry_dff: dff_en port map(clk => clock, reset => reset, en => C_ctrl, d => carry_dff_inp, q => C_flag);
    zero_dff: dff_en port map(clk => clock, reset => reset, en => Z_ctrl, d => zero_dff_inp, q => Z_flag);
    
    mem : Memory port map(Mem_Add => mem_add, Mem_Data_In => mem_in,Write_Enable => mem_WR,clock => clock, Mem_Data_Out => mem_out);
    Mem_Add_Mux_Internal : Mux16_2x1 port map(A0 => D1, A1 =>T3_out, sel =>Mem_Add_Sel,F =>mem_add_internal);
    Mem_In_Mux_Internal : Mux16_2x1 port map(A0 =>T4_out, A1 => D1, sel =>Mem_In_Sel,F =>mem_in_internal);

    --Memory External Muxes
    Mem_Add_Mux : Mux16_2x1 port map(A0 => mem_add_internal, A1 =>Mem_Ext_Add, sel =>Mem_Ext_WR,F =>mem_add);
    Mem_In_Mux : Mux16_2x1 port map(A0 =>mem_in_internal, A1 => Mem_Ext_Data_in, sel =>Mem_Ext_WR,F =>mem_in);
    mem_WR<= Mem_Ext_WR or ((not Mem_Ext_WR) and mem_WR_Internal);
--
end Struct;
    