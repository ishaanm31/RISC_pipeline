library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity instr_decode is
    port
    (
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
		  clk: in std_logic
    );
end entity;

architecture instr_decode_arch of instr_decode is
		shared variable count : integer := 0;
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
	port( 
	    Inp1,Inp2: in std_logic_vector(15 downto 0);
		Outp: out std_logic_vector(15 downto 0)
		);
end component adder;
	component Mux16_4x1 is
    port(A0: in std_logic_vector(15 downto 0);
         A1: in std_logic_vector(15 downto 0);
         A2: in std_logic_vector(15 downto 0);
         A3: in std_logic_vector(15 downto 0);
         sel: in std_logic_vector(1 downto 0);
         F: out std_logic_vector(15 downto 0));
	end component;


		signal Imm6_out,Imm9_out : std_logic_vector(15 downto 0) := "0000000000000000";
		signal counter_in,counter_out : std_logic_vector(3 downto 0) := "0000";
		
	begin 

		Sign_6 : SE10 port map(Instruction(5 downto 0),Imm6_out);
		Sign_9 : SE7 port map(Instruction(8 downto 0),Imm9_out);
		ad: adder port map(PC_in,Imm9_out,PC_BP);
		counter: Register_4bit port map(counter_in,clk,'1',counter_out);
		
		instr : process(clk,Instruction,Imm6_out,Imm9_out,counter_in) 
			variable RegA : std_logic_vector(2 downto 0);
			variable RegB : std_logic_vector(2 downto 0);
			variable RegC : std_logic_vector(2 downto 0);
			variable Alu_sel : std_logic_vector(2 downto 0);
         variable Imm_out : std_logic_vector(15 downto 0);
         variable rf_wr, c_modify, z_modify, mem_wr, mem_mux, imm_mux : std_logic;
        variable opcode : std_logic_vector(3 downto 0);
        variable Last2: std_logic_vector(1 downto 0);
        variable LM_SM_hazard : std_logic;
		  variable mera_mux : std_logic_vector(1 downto 0);
		  begin
			rf_wr := '0';
			c_modify := '0';
			z_modify := '0';
			mem_wr := '0';
			mem_mux := '0';
			imm_mux := '0';
			mera_mux := "00";
			Last2 := Instruction(1 downto 0);
			opcode := Instruction(15 downto 12);
			RegA := Instruction(11 downto 9);
			RegB := Instruction(8 downto 6);
			RegC := Instruction(5 downto 3);
			Alu_sel := "000";
			Imm_out := "0000000000000000";
			LM_SM_hazard := '0';
-----------------ADI--------------------------------
			if(Instruction(15 downto 12) = "0000") then   
				 Imm_out := Imm6_out;
				 c_modify := '1';
				 z_modify := '1';
				 rf_wr := '1';
				 Alu_sel := "000";--add ka 000
				 mem_wr := '0';
				 mem_mux := '0';
				 imm_mux := '1';
 -----------ADD ke baki saare-----------------------
			elsif(Instruction(15 downto 12) = "0001") then
				mera_mux := Instruction(1 downto 0);
				 c_modify := '1';
				 z_modify := '1';
				 rf_wr := '1';
				 Alu_sel(1 downto 0) := "00"; --add ka 000
				 Alu_sel(2) := Instruction (2);
				 mem_wr := '0';
				 mem_mux := '0';
				 imm_mux := '0';

			elsif(Instruction(15 downto 12) = "0010") then
				mera_mux := Instruction(1 downto 0);
				 c_modify := '1';
				 z_modify := '1';
				 rf_wr := '1';
				 Alu_sel(1 downto 0) := "01"; --nand_ka 001
				 Alu_sel(2) := Instruction(2);
				 mem_wr := '0';
				 mem_mux := '0';
				 imm_mux := '0';

			elsif(Instruction(15 downto 12) = "0011" or Instruction(15 downto 12) = "0100") then
				 z_modify := Instruction(14);
				 rf_wr := '1';
				 mem_wr := '0';
				 mem_mux := '1';
				 imm_mux := '1'; 
				 if(Instruction(15 downto 12) = "0011") then
					  Imm_out := Imm9_out;
				 else
					  Imm_out := Imm6_out;
				 end if;  

			elsif(Instruction(15 downto 12) = "0101") then
				 Imm_out := Imm6_out;
				 rf_wr := '0';
				 mem_wr := '1';
				 imm_mux := '1'; 



			elsif(Instruction(15 downto 12) = "0110") then
				 rf_wr := '0';
				 mem_mux := '1';
				 imm_mux := '1';
				 if  (counter_out= "0000") then
					  counter_in <= "0001";
					  LM_SM_hazard := '1';
					  opcode := "0100";
					  RegB := Instruction(11 downto 9);
					  RegA := "111";
					  if(Instruction(0) = '1') then
							rf_wr := '1';
					  end if;
						
					  
				 elsif (counter_out = "0001") then
					  counter_in <= "0010";
					  LM_SM_hazard := '1';
					  opcode := "0100";
					  RegB := Instruction(11 downto 9);
					  RegA := "110";
					   if(Instruction(1) = '1') then
							rf_wr := '1';
					  end if;
					  
					
				 elsif (counter_out = "0010") then
					  counter_in <= "0011";
					  LM_SM_hazard := '1';
					  opcode := "0100";
					  RegB := Instruction(11 downto 9);
					  RegA := "101";
					   if(Instruction(2) = '1') then
							rf_wr := '1';
					  end if;
					
				 elsif (counter_out = "0011") then
					  counter_in <= "0100";
					  LM_SM_hazard := '1';
					  opcode := "0100";
					  RegB := Instruction(11 downto 9);
					  RegA := "100";
					   if(Instruction(3) = '1') then
							rf_wr := '1';
					  end if;
					  
	
				 elsif (counter_out = "0100") then
					  counter_in <= "0101";
					  LM_SM_hazard := '1';
					  opcode := "0100";
					  RegB := Instruction(11 downto 9);
					  RegA := "011";
					   if(Instruction(4) = '1') then
							rf_wr := '1';
					  end if;

					
				 elsif (counter_out = "0101") then
					  counter_in <= "0110";
					  LM_SM_hazard := '1';
					  opcode := "0100";
					  RegB := Instruction(11 downto 9);
					  RegA := "010";
					   if(Instruction(5) = '1') then
							rf_wr := '1';
					  end if;
	
					
				 elsif (counter_out = "0110") then
					  counter_in <= "0111";
					  LM_SM_hazard := '1';
					  opcode := "0100";
					  RegB := Instruction(11 downto 9);
					  RegA := "001";
					   if(Instruction(6) = '1') then
							rf_wr := '1';
					  end if;
				
				 elsif (counter_out = "0111") then
					  counter_in <= "0000";
					  LM_SM_hazard := '0';
					  opcode := "0100";
					  RegB := Instruction(11 downto 9);
					  RegA := "000";
					  if(Instruction(7) = '1') then
							rf_wr := '1';
					  end if;

				else
					counter_in <= "0000";
					opcode := Instruction(15 downto 12);
					RegA := Instruction(11 downto 9);
					RegB := Instruction(8 downto 6);
					RegC := Instruction(5 downto 3);

					
				 end if;
				 
				 case counter_out is
					when "0000" =>
						Imm_out:="0000000000000000";
					when "0001"=>
						Imm_out:="0000000000000010";
					when "0010"=>
						Imm_out:="0000000000000100";
					when "0011"=>
						Imm_out:="0000000000000110";
					when "0100"=>
						Imm_out:="0000000000001000";
					when "0101" =>
						Imm_out:="0000000000001010";
					when "0110" =>
						Imm_out:="0000000000001100";
					when "0111" =>
						Imm_out:="0000000000001110";
					when others =>
						Imm_out:=Imm9_out;
					end case;
						

			elsif (Instruction(15 downto 12) = "0111") then
				 mem_wr := '0';
				 mem_mux := '1';
				 imm_mux := '1';
				 if (counter_out = "0000") then
					  counter_in <= "0001";
					  LM_SM_hazard := '1';
					  opcode := "0101";
					  RegB := Instruction(11 downto 9);
					  RegA := "111";
					   if(Instruction(0) = '1') then
							mem_wr := '1';
					  end if;
					 
				 elsif (counter_out = "0001") then
					  counter_in <= "0010";
					  LM_SM_hazard := '1';
					  opcode := "0101";
					  RegB := Instruction(11 downto 9);
					  RegA := "110";
					  if(Instruction(1) = '1') then
							mem_wr := '1';
					  end if;
					 
					
					
				 elsif (counter_out = "0010") then
					  counter_in <= "0011";
					  LM_SM_hazard := '1';
					  opcode := "0101";
					  RegB := Instruction(11 downto 9);
					  RegA := "101";
					  if(Instruction(2) = '1') then
							mem_wr := '1';
					  end if;
				
					
				 elsif (counter_out = "0011") then
					  counter_in <= "0100";
					  LM_SM_hazard := '1';
					  opcode := "0101";
					  RegB := Instruction(11 downto 9);
					  RegA := "100";
					  if(Instruction(3) = '1') then
							mem_wr := '1';
					  end if;
				 elsif (counter_out = "0100") then
					  counter_in <= "0101";
					  LM_SM_hazard := '1';
					  opcode := "0101";
					  RegB := Instruction(11 downto 9);
					  RegA := "100";
				     if(Instruction(4) = '1') then
							mem_wr := '1';
					  end if;
				 elsif (counter_out = "0101") then
					  counter_in <= "0110";
					  LM_SM_hazard := '1';
					  opcode := "0101";
					  RegB := Instruction(11 downto 9);
					  RegA := "011";
					  if(Instruction(5) = '1') then
							mem_wr := '1';
					  end if;

				 elsif (counter_out = "0110") then
					  counter_in <= "0111";
					  LM_SM_hazard := '1';
					  opcode := "0101";
					  RegB := Instruction(11 downto 9);
					  RegA := "010";
					  if(Instruction(6) = '1') then
							mem_wr := '1';
					  end if;
					
				 elsif (counter_out = "0111") then
					  counter_in <= "0000";
					  LM_SM_hazard := '0';
					  opcode := "0101";
					  RegB := Instruction(11 downto 9);
					  RegA := "010";
				     if(Instruction(7) = '1') then
							mem_wr := '1';
					  end if;
				else
					counter_in <= "0000";
					opcode := Instruction(15 downto 12);
					RegA := Instruction(11 downto 9);
					RegB := Instruction(8 downto 6);
					RegC := Instruction(5 downto 3);

				
				 end if;
				case counter_out is
					when "0000" =>
						Imm_out:="0000000000000000";
					when "0001"=>
						Imm_out:="0000000000000010";
					when "0010"=>
						Imm_out:="0000000000000100";
					when "0011" =>
						Imm_out:="0000000000000110";
					when "0100"=>
						Imm_out:="0000000000001000";
					when "0101" =>
						Imm_out:="0000000000001010";
					when "0110" =>
						Imm_out:="0000000000001100";
					when "0111" =>
						Imm_out:="0000000000001110";
					when others=>
						Imm_out:= Imm9_out;
					end case;

			elsif(Instruction(15 downto 12) = "1000" or Instruction(15 downto 12) = "1001" or Instruction(15 downto 12) = "1010") then
				Imm_out := Imm6_out;
				 rf_wr := '1';
				 ALU_sel := "010"; --sub ka 010
				 mem_mux := '0';
				 imm_mux := '1';


			elsif(Instruction(15 downto 12) = "1100") then
				 Imm_out := Imm9_out;
				 rf_wr := '1';
				 imm_mux := '0';

			elsif(Instruction(15 downto 12) = "1101") then
				 rf_wr := '1';
				 Alu_sel := "000"; --add ka 000
				 mem_wr := '0';
				 mem_mux := '0';
				 imm_mux := '1';

			elsif(Instruction(15 downto 12) = "1111") then
				 rf_wr := '1';
				 mem_mux := '0';
				 imm_mux := '1'; 
			end if;
			out_rf_wr <= rf_wr;
			out_c_modify <= c_modify;
			out_z_modify <= z_modify;
			out_mem_wr <= mem_wr;
			out_mem_mux <= mem_mux;
			out_imm_mux <= imm_mux;
			out_mera_mux <= mera_mux;
			out_Last2 <= Last2;
			out_opcode <= opcode;
			out_RegA <= RegA;
			out_RegB <= RegB;
			out_RegC <= RegC;
			out_Alu_sel <= Alu_sel;
			out_Imm_out <= Imm_out;
			out_LM_SM_hazard <= LM_SM_hazard;
			end process;
end architecture;