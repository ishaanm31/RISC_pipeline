library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity instr_decode is
    port
    (
        PC : in std_logic_vector(15 downto 0);
        Instruction : in std_logic_vector(15 downto 0);
        i_in : in integer;
        history_bit_in : in std_logic;
        Ra,Rb,Rc,Alu_sel : out std_logic_vector(2 downto 0) := "000";
        Imm_out : out std_logic_vector(15 downto 0);
        i_out : out integer;
        history_bit_out, rf_wr, PCR, c_modify, z_modify, mem_wr, mem_mux, imm_mux : out std_logic := '0';
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
signal Imm6_out.Imm9_out : std_logic_vector(15 downto 0) := "0000000000000000";

begin
Ra <= PC(11 downto 9);
Rb <= PC(8 downto 6);
Rc <= PC(5 downto 3);
Sign_6 : SE10 port map(PC(5 downto 0),Imm6_out);
Sign_9 : SE7 port map(PC(8 downto 0),Imm9_out);
Imm_out <= "0000000000000000";
if(PC(15 downto 12) = "0000")
    Imm_out <= Imm6_out;
    c_modify <= '1';
    z_modify <= '1';
    rf_wr <= '1';
    Alu_sel <= "000"; //add ka 000
    PCr <= '1';
    i_out := i_in
    history_bit_out <= history_bit_in;
    memwr <= '0';
    mem_mux <= '0';
    imm_mux <= '1';

else if(PC(15 downto 12) = "0001")
    c_modify <= '1';
    z_modify <= '1';
    rf_wr <= '1';
    Alu_sel(1 downto 0) <= "00"; //add ka 000
    Alu_sel(2) <= PC(2)
    PCr <= '1';
    i_out := i_in
    history_bit_out <= history_bit_in;
    memwr <= '0';
    mem_mux <= '0';
    imm_mux <= '0';

else if(PC(15 downto 12) = "0010")
    c_modify <= '1';
    z_modify <= '1';
    rf_wr <= '1';
    Alu_sel(1 downto 0) <= "01"; //nand_ka 001
    Alu_sel(2) <= PC(2)
    PCr <= '1';
    i_out := i_in
    history_bit_out <= history_bit_in;
    memwr <= '0';
    mem_mux <= '0';
    imm_mux <= '0';

else if(PC(15 downto 12) = "0011" or PC(15 downto 12) = "0100")
    if(PC(15 downto 12) = "0011")
        Imm_out <= Imm9_out;
    else
        Imm_out <= Imm6_out;
    end if
    z_modify <= PC(14)
    rf_wr <= '1';
    PCr <= '1';
    i_out := i_in
    history_bit_out <= history_bit_in;
    memwr <= '0';
    mem_mux <= '1';
    imm_mux <= '1';  

else if(PC(15 downto 12) = "0101")
    rf_wr <= '0';
    PCr <= '1';
    i_out := i_in
    history_bit_out <= history_bit_in;
    memwr <= '1';
    imm_mux <= '1'; 

else if(PC(15 downto 12) = "0101" or PC(15 downto 12) = "0111")
    rf_wr <= '0';
    PCr <= '1';
    i_out := i_in
    history_bit_out <= history_bit_in;
    memwr <= '1';
    imm_mux <= '1'; 

else if(PC(15 downto 12) = "0110")
    rf_wr <= '1';
    PCr <= '1';
    i_out := i_in
    history_bit_out <= history_bit_in;
    mem_mux <= '1';
    imm_mux <= '1';

else if(PC(15 downto 12) = "1000" or PC(15 downto 12) = "1001" PC(15 downto 12) = "1010")
    rf_wr <= '1';
    PCr <= '1';
    ALU_sel <= "010" //sub ka 010
    i_out := i_in
    history_bit_out <= history_bit_in;
    mem_mux <= '0';
    imm_mux <= '1';

else if(PC(15 downto 12) = "1000" or PC(15 downto 12) = "1001" PC(15 downto 12) = "1010")
    rf_wr <= '1';
    PCr <= '1';
    ALU_sel <= "010" //sub ka 010
    i_out := i_in
    history_bit_out <= history_bit_in;
    mem_mux <= '0';
    imm_mux <= '1';

else if(PC(15 downto 12) = "1100")
    rf_wr <= '1';
    PCr <= '1';
    i_out := i_in
    history_bit_out <= history_bit_in;
    imm_mux <= '0';

else if(PC(15 downto 12) = "1101")
    rf_wr <= '1';
    Alu_sel <= "000"; //add ka 000
    PCr <= '1';
    i_out := i_in
    history_bit_out <= history_bit_in;
    memwr <= '0';
    mem_mux <= '0';
    imm_mux <= '1';

