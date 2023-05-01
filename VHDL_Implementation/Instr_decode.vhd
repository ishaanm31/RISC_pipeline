library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity instr_decode is
    port
    (
        PC_in : in std_logic_vector(15 downto 0);
        Instruction : in std_logic_vector(15 downto 0);
        Ra,Rb,Rc ,Alu_sel : out std_logic_vector(2 downto 0) := "000";
        Imm_out : out std_logic_vector(15 downto 0);
        rf_wr, c_modify, z_modify, mem_wr, mem_mux, imm_mux : out std_logic := '0';
        opcode : out std_logic_vector(3 downto 0);
        Last2: out std_logic_vector(1 downto 0);
        PC_BP : out std_logic_vector(15 downto 0);
        LM_SM_hazard : out std_logic;
        counter_out : out std_logic_vector(2 downto 0);
		mera_mux : out std_logic_vector(1 downto 0);
		  clk: in std_logic
    );
end entity;

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

		component ID_adder is
			port(   PC,Imm9: in std_logic_vector(15 downto 0);
						 BranchedPC: out std_logic_vector(15 downto 0)
				);
		end component;
	component Mux16_4x1 is
    port(A0: in std_logic_vector(15 downto 0);
         A1: in std_logic_vector(15 downto 0);
         A2: in std_logic_vector(15 downto 0);
         A3: in std_logic_vector(15 downto 0);
         sel: in std_logic_vector(1 downto 0);
         F: out std_logic_vector(15 downto 0));
	end component;


		signal Imm6_out,Imm9_out : std_logic_vector(15 downto 0) := "0000000000000000";
		signal counter_in : std_logic_vector(2 downto 0) := "000";
		signal count : integer := 0;
		
	begin 

		Sign_6 : SE10 port map(Instruction(5 downto 0),Imm6_out);
		Sign_9 : SE7 port map(Instruction(8 downto 0),Imm9_out);
		ad: ID_adder port map(PC_in,Imm9_out,PC_BP);
		counter: Register_3bit port map(counter_in,clk,'1',counter_out);
		
		instr : process(clk)
		
			begin 
			mera_mux <= "00";
			Last2 <= Instruction(1 downto 0);
			opcode <= Instruction(15 downto 12);
			Ra <= Instruction(11 downto 9);
			Rb <= Instruction(8 downto 6);
			Rc <= Instruction(5 downto 3);
			
			Imm_out <= "0000000000000000";
			
-----------------ADI--------------------------------
			if(Instruction(15 downto 12) = "0000") then   
				 Imm_out <= Imm6_out;
				 c_modify <= '1';
				 z_modify <= '1';
				 rf_wr <= '1';
				 Alu_sel <= "000";--add ka 000
				 mem_wr <= '0';
				 mem_mux <= '0';
				 imm_mux <= '1';
 -----------ADD ke baki saare-----------------------
			elsif(Instruction(15 downto 12) = "0001") then
				mera_mux <= Instruction(1 downto 0);
				 c_modify <= '1';
				 z_modify <= '1';
				 rf_wr <= '1';
				 Alu_sel(1 downto 0) <= "00"; --add ka 000
				 Alu_sel(2) <= Instruction (2);
				 mem_wr <= '0';
				 mem_mux <= '0';
				 imm_mux <= '0';

			elsif(Instruction(15 downto 12) = "0010") then
				mera_mux <= Instruction(1 downto 0);
				 c_modify <= '1';
				 z_modify <= '1';
				 rf_wr <= '1';
				 Alu_sel(1 downto 0) <= "01"; --nand_ka 001
				 Alu_sel(2) <= PC(2);
				 PCr <= '1';
				 mem_wr <= '0';
				 mem_mux <= '0';
				 imm_mux <= '0';

			elsif(Instruction(15 downto 12) = "0011" or Instruction(15 downto 12) = "0100") then
				 z_modify <= Instruction(14);
				 rf_wr <= '1';
				 mem_wr <= '0';
				 mem_mux <= '1';
				 imm_mux <= '1'; 
				 if(PC(15 downto 12) = "0011") then
					  Imm_out <= Imm9_out;
				 else
					  Imm_out <= Imm6_out;
				 end if;  

			elsif(Instruction(15 downto 12) = "0101") then
				 Imm_out <= Imm6_out;
				 rf_wr <= '0';
				 mem_wr <= '1';
				 imm_mux <= '1'; 



			elsif(Instruction(15 downto 12) = "0110") then
				 rf_wr <= '1';
				 mem_mux <= '1';
				 imm_mux <= '1';
				 if  (counter_in = "000") then
					  counter_in <= "001";
					  LM_SM_hazard <= '1';
					  opcode <= "0100";
					  RegB <= Instruction(12 downto 9);
					  RegA <= "111";
					
							count := count + 1; 
					
				 elsif (counter_in = "001") then
					  counter_in <= "010";
					  LM_SM_hazard <= '1';
					  opcode <= "0100";
					  RegB <= Instruction(12 downto 9);
					  RegA <= "110";
					 
							count := count + 1; 
					
				 elsif (counter_in = "010") then
					  counter_in <= "011";
					  LM_SM_hazard <= '1';
					  opcode <= "0100";
					  RegB <= Instruction(12 downto 9);
					  RegA <= "101";
					  
							count := count + 1; 
					
				 elsif (counter_in = "011") then
					  counter_in <= "100";
					  LM_SM_hazard <= '1';
					  opcode <= "0100";
					  RegB <= Instruction(12 downto 9);
					  RegA <= "100";
					  
							count := count + 1;
				
				 elsif (counter_in = "100") then
					  counter_in <= "101";
					  LM_SM_hazard <= '1';
					  opcode <= "0100";
					  RegB <= Instruction(12 downto 9);
					  RegA <= "100";
					 
							count := count + 1;
					
				 elsif (counter_in = "101") then
					  counter_in <= "110";
					  LM_SM_hazard <= '1';
					  opcode <= "0100";
					  RegB <= Instruction(12 downto 9);
					  RegA <= "011";
					 
							count := count + 1;
					
				 elsif (counter_in = "110") then
					  counter_in <= "111";
					  LM_SM_hazard <= '1';
					  opcode <= "0100";
					  RegB <= Instruction(12 downto 9);
					  RegA <= "010";
					 
							count := count + 1;
				
				 elsif (counter_in = "111") then
					  counter_in <= "000";
					  LM_SM_hazard <= '0';
					  opcode <= "0100";
					  RegB <= Instruction(12 downto 9);
					  RegA <= "010";
					 
							count := count + 1;
					
				 end if;
				 
				 case count is
					when 0 =>
						Imm_out<="0000000000000000";
					when 1 =>
						Imm_out<="0000000000000010";
					when 2 =>
						Imm_out<="0000000000000100";
					when 3 =>
						Imm_out<="0000000000000110";
					when 4 =>
						Imm_out<="0000000000001000";
					when 5 =>
						Imm_out<="0000000000001010";
					when 6 =>
						Imm_out<="0000000000001100";
					when others =>
						Imm_out<="0000000000001110";
					end case;
						

			elsif (Instruction(15 downto 12) = "0111") then
				 rf_wr <= '1';
				 mem_mux <= '1';
				 imm_mux <= '1';
				 if (counter_in = "000") then
					  counter_in <= "001";
					  LM_SM_hazard <= '1';
					  opcode <= "0101";
					  RegB <= Instruction(12 downto 9);
					  RegA <= "111";
					 
							count := count + 1; 
				
				 elsif (counter_in = "001") then
					  counter_in <= "010";
					  LM_SM_hazard <= '1';
					  opcode <= "0101";
					  RegB <= Instruction(12 downto 9);
					  RegA <= "110";
					 
							count := count + 1; 
					
				 elsif (counter_in = "010") then
					  counter_in <= "011";
					  LM_SM_hazard <= '1';
					  opcode <= "0101";
					  RegB <= Instruction(12 downto 9);
					  RegA <= "101";
					  
							count := count + 1; 
					
				 elsif (counter_in = "011") then
					  counter_in <= "100";
					  LM_SM_hazard <= '1';
					  opcode <= "0101";
					  RegB <= Instruction(12 downto 9);
					  RegA <= "100";
					 
							count := count + 1;
				
				 elsif (counter_in = "100") then
					  counter_in <= "101";
					  LM_SM_hazard <= '1';
					  opcode <= "0101";
					  RegB <= Instruction(12 downto 9);
					  RegA <= "100";
					  
							count := count + 1;
				
				 elsif (counter_in = "101") then
					  counter_in <= "110";
					  LM_SM_hazard <= '1';
					  opcode <= "0101";
					  RegB <= Instruction(12 downto 9);
					  RegA <= "011";
					  
							count := count + 1;
					  end if;
				 elsif (counter_in = "110") then
					  counter_in <= "111";
					  LM_SM_hazard <= '1';
					  opcode <= "0101";
					  RegB <= Instruction(12 downto 9);
					  RegA <= "010";
					  
							count := count + 1;
					
				 elsif (counter_in = "111") then
					  counter_in <= "000";
					  LM_SM_hazard <= '0';
					  opcode <= "0101";
					  RegB <= Instruction(12 downto 9);
					  RegA <= "010";
					
							count := count + 1;
				
				 end if;
				case count is
					when 0 =>
						Imm_out<="0000000000000000";
					when 1 =>
						Imm_out<="0000000000000010";
					when 2 =>
						Imm_out<="0000000000000100";
					when 3 =>
						Imm_out<="0000000000000110";
					when 4 =>
						Imm_out<="0000000000001000";
					when 5 =>
						Imm_out<="0000000000001010";
					when 6 =>
						Imm_out<="0000000000001100";
					when others =>
						Imm_out<="0000000000001110";
					end case;

			elsif(Instruction(15 downto 12) = "1000" or Instruction(15 downto 12) = "1001" or Instruction(15 downto 12) = "1010") then
				Imm_out <= Imm6_out;
				 rf_wr <= '1';
				 ALU_sel <= "010"; --sub ka 010
				 mem_mux <= '0';
				 imm_mux <= '1';


			elsif(Instruction(15 downto 12) = "1100") then
				 Imm_out <= Imm9_out;
				 rf_wr <= '1';
				 imm_mux <= '0';

			elsif(Instruction(15 downto 12) = "1101") then
				 rf_wr <= '1';
				 Alu_sel <= "000"; --add ka 000
				 mem_wr <= '0';
				 mem_mux <= '0';
				 imm_mux <= '1';

			elsif(Instruction(15 downto 12) = "1111") then
				 rf_wr <= '1';
				 mem_mux <= '0';
				 imm_mux <= '1'; 
			end if;
			end process;
end architecture;