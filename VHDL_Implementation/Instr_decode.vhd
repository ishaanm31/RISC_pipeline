library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity instr_decode is
    port
    (
        PC_in : in std_logic_vector(15 downto 0);
        Instruction : in std_logic_vector(15 downto 0);
        Ra,Rb,Rc,Alu_sel : out std_logic_vector(2 downto 0) := "000";
        Imm_out : out std_logic_vector(15 downto 0);
        rf_wr, c_modify, z_modify, mem_wr, mem_mux, imm_mux : out std_logic := '0';
        opcode : out std_logic_vector(3 downto 0);
        Last2 : out std_logic_vector(1 downto 0);
        PC_BP : out std_logic_vector(15 downto 0);
        LM_SM_hazard : out std_logic;
        counter_out : out std_logic_vector(2 downto 0)
    );

architecture instr_decode_arch of instr_decode is
component SE7 is
port (Raw: in std_logic_vector(8 downto 0 );
    Outp:out std_logic_vector(15 downto 0):="0000000000000000");
end component SE7;

component SE10 is
port (Raw: in std_logic_vector(5 downto 0 );
    Output:out std_logic_vector(15 downto 0):="0000000000000000");
end component SE10;

component Register_3bit is
    port (DataIn:in std_logic_vector(2 downto 0);
    clock,Write_Enable:in std_logic;
    DataOut:out std_logic_vector(2 downto 0));
end component Register_3bit;

component adder is




signal Imm6_out.Imm9_out : std_logic_vector(15 downto 0) := "0000000000000000";
signal counter_in : std_logic_vector(2 downto 0) := "000";
signal count : integer := 0;
begin 
instr : process(clk)
Last2 <= Instruction(1 downto 0);
opcode <= Instruction(15 downto 12);
Ra <= Instruction(11 downto 9);
Rb <= Instruction(8 downto 6);
Rc <= Instruction(5 downto 3);
counter(counter_in,clk,'1',)
Sign_6 : SE10 port map(PC(5 downto 0),Imm6_out);
Sign_9 : SE7 port map(PC(8 downto 0),Imm9_out);
Adder : adder port map(PC,Imm9_out,PC_BP);
Imm_out <= "0000000000000000";
begin 
if(Instruction(15 downto 12) = "0000")
    Imm_out <= Imm6_out;
    c_modify <= '1';
    z_modify <= '1';
    rf_wr <= '1';
    Alu_sel <= "000"; //add ka 000
    memwr <= '0';
    mem_mux <= '0';
    imm_mux <= '1';

else if(Instruction(15 downto 12) = "0001")
    c_modify <= '1';
    z_modify <= '1';
    rf_wr <= '1';
    Alu_sel(1 downto 0) <= "00"; //add ka 000
    Alu_sel(2) <= PC(2)
    memwr <= '0';
    mem_mux <= '0';
    imm_mux <= '0';

else if(Instruction(15 downto 12) = "0010")
    c_modify <= '1';
    z_modify <= '1';
    rf_wr <= '1';
    Alu_sel(1 downto 0) <= "01"; //nand_ka 001
    Alu_sel(2) <= PC(2)
    PCr <= '1';
    memwr <= '0';
    mem_mux <= '0';
    imm_mux <= '0';

else if(Instruction(15 downto 12) = "0011" or Instruction(15 downto 12) = "0100")
    if(PC(15 downto 12) = "0011")
        Imm_out <= Imm9_out;
    else
        Imm_out <= Imm6_out;
    end if
    z_modify <= Instruction(14)
    rf_wr <= '1';
    memwr <= '0';
    mem_mux <= '1';
    imm_mux <= '1';  

else if(Instruction(15 downto 12) = "0101")
	 Imm_out <= Imm6_out;
    rf_wr <= '0';
    memwr <= '1';
    imm_mux <= '1'; 



else if(Instruction(15 downto 12) = "0110")
    rf_wr <= '1';
    mem_mux <= '1';
    imm_mux <= '1';
    if  (counter_in = "000")
        counter_in <= "001";
        LM_SM_hazard <= '1';
        opcode <= "0100";
        RegB <= Instruction(12 downto 9);
        RegA <= "111";
        if(Instruction(0) = '1') 
            count = count + 1; 
        end if;
    else if (counter_in = "001")
        counter_in <= "010";
        LM_SM_hazard <= '1';
        opcode <= "0100";
        RegB <= Instruction(12 downto 9);
        RegA <= "110";
        if(Instruction(1) = '1') 
            count = count + 1; 
        end if;
    else if (counter_in = "010")
        counter_in <= "011";
        LM_SM_hazard <= '1';
        opcode <= "0100";
        RegB <= Instruction(12 downto 9);
        RegA <= "101";
        if(Instruction(2) = '1') 
            count = count + 1; 
        end if;
    else if (counter_in = "011")
        counter_in <= "100";
        LM_SM_hazard <= '1';
        opcode <= "0100";
        RegB <= Instruction(12 downto 9);
        RegA <= "100";
        if(Instruction(3) = '1') 
            count = count + 1;
        end if;
    else if (counter_in = "100")
        counter_in <= "101";
        LM_SM_hazard <= '1';
        opcode <= "0100";
        RegB <= Instruction(12 downto 9);
        RegA <= "100";
        if(Instruction(4) = '1') 
            count = count + 1;
        end if;
    else if (counter_in = "101")
        counter_in <= "110";
        LM_SM_hazard <= '1';
        opcode <= "0100";
        RegB <= Instruction(12 downto 9);
        RegA <= "011";
        if(Instruction(5) = '1') 
            count = count + 1;
        end if;
    else if (counter_in = "110")
        counter_in <= "111";
        LM_SM_hazard <= '1';
        opcode <= "0100";
        RegB <= Instruction(12 downto 9);
        RegA <= "010";
        if(Instruction(6) = '1') 
            count = count + 1;
        end if;
    else if (counter_in = "111")
        counter_in <= "000";
        LM_SM_hazard <= '0';
        opcode <= "0100";
        RegB <= Instruction(12 downto 9);
        RegA <= "010";
        if(Instruction(7) = '1') 
            count = count + 1;
        end if;
    end if;
    if(count = 0)
        Imm_out <= "0000000000000000";
    else if(count = 1)
        Imm_out <= "0000000000000010";
    else if(count = 2)
        Imm_out <= "0000000000000100";
    else if(count = 3)
        Imm_out <= "0000000000000110";
    else if(count = 4)
        Imm_out <= "0000000000001000";
    else if(count = 5)
        Imm_out <= "0000000000001010";
    else if(count = 6)
        Imm_out <= "0000000000001100";
    else if(count = 7)
        Imm_out <= "0000000000001110";
    else if(count = 8)
        Imm_out <= "0000000000010000";
    end if;

else if(Instruction(15 downto 12) = "0111")
    rf_wr <= '1';
    mem_mux <= '1';
    imm_mux <= '1';
    if  (counter_in = "000")
        counter_in <= "001";
        LM_SM_hazard <= '1';
        opcode <= "0101";
        RegB <= Instruction(12 downto 9);
        RegA <= "111";
        if(Instruction(0) = '1') 
            count = count + 1; 
        end if;
    else if (counter_in = "001")
        counter_in <= "010";
        LM_SM_hazard <= '1';
        opcode <= "0101";
        RegB <= Instruction(12 downto 9);
        RegA <= "110";
        if(Instruction(1) = '1') 
            count = count + 1; 
        end if;
    else if (counter_in = "010")
        counter_in <= "011";
        LM_SM_hazard <= '1';
        opcode <= "0101";
        RegB <= Instruction(12 downto 9);
        RegA <= "101";
        if(Instruction(2) = '1') 
            count = count + 1; 
        end if;
    else if (counter_in = "011")
        counter_in <= "100";
        LM_SM_hazard <= '1';
        opcode <= "0101";
        RegB <= Instruction(12 downto 9);
        RegA <= "100";
        if(Instruction(3) = '1') 
            count = count + 1;
        end if;
    else if (counter_in = "100")
        counter_in <= "101";
        LM_SM_hazard <= '1';
        opcode <= "0101";
        RegB <= Instruction(12 downto 9);
        RegA <= "100";
        if(Instruction(4) = '1') 
            count = count + 1;
        end if;
    else if (counter_in = "101")
        counter_in <= "110";
        LM_SM_hazard <= '1';
        opcode <= "0101";
        RegB <= Instruction(12 downto 9);
        RegA <= "011";
        if(Instruction(5) = '1') 
            count = count + 1;
        end if;
    else if (counter_in = "110")
        counter_in <= "111";
        LM_SM_hazard <= '1';
        opcode <= "0101";
        RegB <= Instruction(12 downto 9);
        RegA <= "010";
        if(Instruction(6) = '1') 
            count = count + 1;
        end if;
    else if (counter_in = "111")
        counter_in <= "000";
        LM_SM_hazard <= '0';
        opcode <= "0101";
        RegB <= Instruction(12 downto 9);
        RegA <= "010";
        if(Instruction(7) = '1') 
            count = count + 1;
        end if;
    end if;
    if(count = 0)
        Imm_out <= "0000000000000000";
    else if(count = 1)
        Imm_out <= "0000000000000010";
    else if(count = 2)
        Imm_out <= "0000000000000100";
    else if(count = 3)
        Imm_out <= "0000000000000110";
    else if(count = 4)
        Imm_out <= "0000000000001000";
    else if(count = 5)
        Imm_out <= "0000000000001010";
    else if(count = 6)
        Imm_out <= "0000000000001100";
    else if(count = 7)
        Imm_out <= "0000000000001110";
    else if(count = 8)
        Imm_out <= "0000000000010000";
    end if;

else if(Instruction(15 downto 12) = "1000" or Instruction(15 downto 12) = "1001" or Instruction(15 downto 12) = "1010")
	Imm_out <= Imm6_out;
    rf_wr <= '1';
    ALU_sel <= "010" //sub ka 010
    mem_mux <= '0';
    imm_mux <= '1';


else if(Instruction(15 downto 12) = "1100")
	 Imm_out <= Imm9_out;
    rf_wr <= '1';
    imm_mux <= '0';

else if(Instruction(15 downto 12) = "1101")
    rf_wr <= '1';
    Alu_sel <= "000"; //add ka 000
    memwr <= '0';
    mem_mux <= '0';
    imm_mux <= '1';

else if(Instruction(15 downto 12) = "1111")
    rf_wr <= '1';
    mem_mux <= '0';
    imm_mux <= '1'; 
end if;
end process;
end instr_decode_arch;