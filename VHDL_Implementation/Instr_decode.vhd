library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity instr_decode is
    port
    (
        Instruction : in std_logic_vector(15 downto 0);
		PC_in: in std_logic_vector(15 downto 0);
        RS1,RS2,RD : out std_logic_vector(2 downto 0);
		ALU_sel,D3_MUX,CZ: out std_logic_vector(1 downto 0);
        Imm : out std_logic_vector(15 downto 0);
        RF_wr, C_modified, Z_modified, Mem_wr,Carry_sel,CPL,WB_MUX,ALUA_MUX,ALUB_MUX : out std_logic;
        OP : out std_logic_vector(3 downto 0);
        PC_ID : out std_logic_vector(15 downto 0);
        LM_SM_hazard : out std_logic;
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

		component Register_2bit is
			port (DataIn:in std_logic_vector(1 downto 0);
			clock,Write_Enable:in std_logic;
			DataOut:out std_logic_vector(1 downto 0));
		end component Register_2bit;
		
		component Register_4bit is
		  port (DataIn:in std_logic_vector(3 downto 0);
		  clock,Write_Enable:in std_logic;
		  DataOut:out std_logic_vector(3 downto 0));
		 end component Register_4bit;

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


		signal Imm6_out,Imm9_out,sig_imm : std_logic_vector(15 downto 0) := "0000000000000000";
		signal counter_in,counter_out : std_logic_vector(3 downto 0);
		
	begin 

		Sign_6 : SE10 port map(Instruction(5 downto 0),Imm6_out);
		Sign_9 : SE7 port map(Instruction(8 downto 0),Imm9_out);
		ad: adder port map(PC_in,Imm9_out,sig_imm);
		ad2: adder port map(sig_imm,Imm9_out,PC_ID);
		counter: Register_4bit port map(counter_in,clk,'1',counter_out);
		
		Decode : process(clk,Instruction,Imm6_out,Imm9_out,counter_out) 
		variable var_RS1 : std_logic_vector(2 downto 0);
		variable var_RS2 : std_logic_vector(2 downto 0);
		variable var_RD : std_logic_vector(2 downto 0);
		variable var_ALU_sel,var_CZ, var_D3_MUX : std_logic_vector(1 downto 0);
        variable var_Imm : std_logic_vector(15 downto 0);
    	variable var_RF_wr, var_C_modified, var_Z_modified, var_Mem_wr,var_Carry_sel,var_CPL,var_WB_MUX,var_ALUA_MUX,var_ALUB_MUX: std_logic;
        variable var_OP : std_logic_vector(3 downto 0);
        variable var_LM_SM_hazard : std_logic;
		  begin
			var_RF_wr := '0';
			var_CZ := "00";
			var_D3_MUX := "00";
			var_Carry_sel := '0';
			var_CPL := '0';
			var_WB_MUX := '0';
			var_C_modified := '0';
			var_Z_modified := '0';
			var_Mem_wr := '0';
			var_OP := Instruction(15 downto 12);
			var_RS1 := Instruction(11 downto 9);
			var_RS2 := Instruction(8 downto 6);
			var_RD := Instruction(5 downto 3);
			var_ALU_sel := "00";
			var_Imm := "0000000000000000";
			var_LM_SM_hazard := '0';
			var_ALUA_MUX := '0';
			var_ALUB_MUX := '0';
			counter_in<="0000";
-----------------ADI--------------------------------
			if( Instruction="0000000000000000") then
				var_RF_wr := '0';
				
			elsif(Instruction(15 downto 12) = "0000") then   
				var_RF_wr := '1';
				var_ALUB_MUX := '1';
				var_C_modified := '1';
				var_Z_modified := '1';
				var_RS2 := Instruction(8 downto 6);
				var_RD := Instruction(8 downto 6);
				var_Imm := Imm6_out;
				
 -----------ADD and related-----------------------
			elsif(Instruction(15 downto 12) = "0001") then
				var_RF_wr := '1';
				var_CZ := Instruction(1 downto 0);
				var_Carry_sel := Instruction(0) and Instruction(1);
				var_CPL := Instruction(2);
				var_C_modified := '1';
				var_Z_modified := '1';

			
------------NAND and related-------------
			elsif(Instruction(15 downto 12) = "0010") then
				var_RF_wr := '1';
				var_ALU_sel := "11";
				var_CZ := Instruction(1 downto 0);
				var_CPL := Instruction(2);
				var_Z_modified := '1';
				
-----LLI and LW--------------------------
			elsif((Instruction(15 downto 12) = "0011") or (Instruction(15 downto 12) = "0100")) then
				var_RF_wr := '1';
				var_RS1 := Instruction(8 downto 6);
				var_RD := Instruction(11 downto 9);
				if ((Instruction(15 downto 12) = "0011")) then
					var_Imm := Imm9_out;
					var_D3_MUX := "01";
				else 
					var_Imm := Imm6_out+Imm6_out;
					var_WB_MUX := '1';
					var_ALUB_MUX := '1';
				end if;

----------------SW--------------------------
			elsif(Instruction(15 downto 12) = "0101") then
				var_Imm := Imm6_out+Imm6_out;
				var_Mem_wr := '1';
				var_ALUA_MUX := '1';
				var_ALUB_MUX := '1';
				var_RS1:=Instruction(11 downto 9);

----------LM------------
			elsif(Instruction(15 downto 12) = "0110") then
				 var_ALUB_MUX := '1';
				 var_WB_MUX := '1';
				
				 if  (counter_out= "0000") then
					  counter_in <= "0001";
					  var_LM_SM_hazard := '1';
					  var_OP := "0100";
					  var_RS1 := Instruction(11 downto 9);
					  var_RD := "111";
					  if(Instruction(0) = '1') then
							var_RF_wr := '1';
					  end if;
						
					  
				 elsif (counter_out = "0001") then
					  counter_in <= "0010";
					  var_LM_SM_hazard := '1';
					  var_OP := "0100";
					  var_RS1 := Instruction(11 downto 9);
					  var_RD := "110";
					   if(Instruction(1) = '1') then
							var_RF_wr := '1';
					  end if;
					  
					
				 elsif (counter_out = "0010") then
					  counter_in <= "0011";
					  var_LM_SM_hazard := '1';
					  var_OP := "0100";
					  var_RS1 := Instruction(11 downto 9);
					  var_RD := "101";
					   if(Instruction(2) = '1') then
							var_RF_wr := '1';
					  end if;
					
				 elsif (counter_out = "0011") then
					  counter_in <= "0100";
					  var_LM_SM_hazard := '1';
					  var_OP := "0100";
					  var_RS1 := Instruction(11 downto 9);
					  var_RD := "100";
					   if(Instruction(3) = '1') then
							var_rf_wr := '1';
					  end if;
					  
	
				 elsif (counter_out = "0100") then
					  counter_in <= "0101";
					  var_LM_SM_hazard := '1';
					  var_OP := "0100";
					  var_RS1 := Instruction(11 downto 9);
					  var_RD := "011";
					   if(Instruction(4) = '1') then
							var_RF_wr := '1';
					  end if;

					
				 elsif (counter_out = "0101") then
					  counter_in <= "0110";
					  var_LM_SM_hazard := '1';
					  var_OP := "0100";
					  var_RS1 := Instruction(11 downto 9);
					  var_RD := "010";
					   if(Instruction(5) = '1') then
							var_RF_wr := '1';
					  end if;
	
					
				 elsif (counter_out = "0110") then
					  counter_in <= "0111";
					  var_LM_SM_hazard := '1';
					  var_OP := "0100";
					  var_RS1 := Instruction(11 downto 9);
					  var_RD := "001";
					   if(Instruction(6) = '1') then
							var_RF_wr := '1';
					  end if;
				
				 elsif (counter_out = "0111") then
					  counter_in <= "0000";
					  var_LM_SM_hazard := '0';
					  var_OP := "0100";
					  var_RS1 := Instruction(11 downto 9);
					  var_RD := "000";
					  if(Instruction(7) = '1') then
							var_RF_wr := '1';
					  end if;

				else
					counter_in <= "0000";
					var_OP := Instruction(15 downto 12);
					var_RS1 := Instruction(11 downto 9);
					var_RS2 := Instruction(8 downto 6);
					var_RD := Instruction(5 downto 3);

					
				 end if;
				 
				 case counter_out is
					when "0000" =>
						var_Imm:="0000000000000000";
					when "0001"=>
						var_Imm:="0000000000000010";
					when "0010"=>
						var_Imm:="0000000000000100";
					when "0011" =>
						var_Imm:="0000000000000110";
					when "0100"=>
						var_Imm:="0000000000001000";
					when "0101" =>
						var_Imm:="0000000000001010";
					when "0110" =>
						var_Imm:="0000000000001100";
					when "0111" =>
						var_Imm:="0000000000001110";
					when others=>
						var_Imm:= Imm9_out;
					end case;
						

			elsif (Instruction(15 downto 12) = "0111") then
				 var_ALUB_MUX := '1';
				 var_ALUA_MUX := '1';
				
				
				 if (counter_out = "0000") then
					  counter_in <= "0001";
					  var_LM_SM_hazard := '1';
					  var_OP := "0101";
					  var_RS2 := Instruction(11 downto 9);
					  var_RS1 := "111";
					   if(Instruction(0) = '1') then
							var_Mem_wr := '1';
					  end if;
					 
				 elsif (counter_out = "0001") then
					  counter_in <= "0010";
					  var_LM_SM_hazard := '1';
					  var_OP := "0101";
					  var_RS2 := Instruction(11 downto 9);
					  var_RS1 := "110";
					  if(Instruction(1) = '1') then
							var_Mem_wr := '1';
					  end if;
					 
					
					
				 elsif (counter_out = "0010") then
					  counter_in <= "0011";
					  var_LM_SM_hazard := '1';
					  var_OP := "0101";
					  var_RS2 := Instruction(11 downto 9);
					  var_RS1 := "101";
					  if(Instruction(2) = '1') then
							var_Mem_wr := '1';
					  end if;
				
					
				 elsif (counter_out = "0011") then
					  counter_in <= "0100";
					  var_LM_SM_hazard := '1';
					  var_OP := "0101";
					  var_RS2 := Instruction(11 downto 9);
					  var_RS1 := "100";
					  if(Instruction(3) = '1') then
							var_Mem_wr := '1';
					  end if;
				 elsif (counter_out = "0100") then
					  counter_in <= "0101";
					  var_LM_SM_hazard := '1';
					  var_OP := "0101";
					  var_RS2 := Instruction(11 downto 9);
					  var_RS1 := "011";
				     if(Instruction(4) = '1') then
							var_Mem_wr := '1';
					  end if;
				 elsif (counter_out = "0101") then
					  counter_in <= "0110";
					  var_LM_SM_hazard := '1';
					  var_OP := "0101";
					  var_RS2 := Instruction(11 downto 9);
					  var_RS1 := "010";
					  if(Instruction(5) = '1') then
							var_Mem_wr := '1';
					  end if;

				 elsif (counter_out = "0110") then
					  counter_in <= "0111";
					  var_LM_SM_hazard := '1';
					  var_OP := "0101";
					  var_RS2 := Instruction(11 downto 9);
					  var_RS1 := "001";
					  if(Instruction(6) = '1') then
							var_Mem_wr := '1';
					  end if;
					
				 elsif (counter_out = "0111") then
					  counter_in <= "0000";
					  var_LM_SM_hazard := '0';
					  var_OP := "0101";
					  var_RS2 := Instruction(11 downto 9);
					  var_RS1 := "000";
				     if(Instruction(7) = '1') then
							var_Mem_wr := '1';
					  end if;
				else
					counter_in <= "0000";
					var_OP := Instruction(15 downto 12);
					var_RS1 := Instruction(11 downto 9);
					var_RS2 := Instruction(8 downto 6);
					var_RD := Instruction(5 downto 3);

				
				 end if;
				case counter_out is
					when "0000" =>
						var_Imm:="0000000000000000";
					when "0001"=>
						var_Imm:="0000000000000010";
					when "0010"=>
						var_Imm:="0000000000000100";
					when "0011" =>
						var_Imm:="0000000000000110";
					when "0100"=>
						var_Imm:="0000000000001000";
					when "0101" =>
						var_Imm:="0000000000001010";
					when "0110" =>
						var_Imm:="0000000000001100";
					when "0111" =>
						var_Imm:="0000000000001110";
					when others=>
						var_Imm:= Imm9_out;
					end case;

			elsif((Instruction(15 downto 12) = "1000") or (Instruction(15 downto 12) = "1001") or (Instruction(15 downto 12) = "1010")) then
				var_Imm := Imm6_out+Imm6_out;
				var_ALU_sel := "01";
			

			elsif(Instruction(15 downto 12) = "1100") then
				var_Imm := Imm9_out+Imm9_out;
				var_RF_wr := '1';
				var_RD := Instruction(11 downto 9);
				var_D3_MUX := "11";
				

			elsif(Instruction(15 downto 12) = "1101") then
				var_RF_wr := '1';
				var_RD := Instruction(11 downto 9);
				var_RS1 := Instruction(8 downto 6);
				var_D3_MUX := "11";

			elsif(Instruction(15 downto 12) = "1111") then
				var_Imm := Imm9_out+Imm9_out;
			elsif( Instruction="0000000000000000") then
				var_RF_wr := '0';
				
			else null;
				
				 
			end if;
			RF_wr <= var_RF_wr;
			C_modified <= var_C_modified;
			Z_modified <= var_Z_modified;
			Mem_wr <= var_Mem_wr;
			WB_MUX <= var_WB_MUX;
			CZ <= var_CZ;
			Carry_sel <= var_Carry_sel;
			CPL <= var_CPL;
			OP <= var_OP;
			RS1 <= var_RS1;
			RS2 <= var_RS2;
			RD <= var_RD;
			ALU_sel <= var_ALU_sel;
			Imm <= var_Imm;
			LM_SM_hazard <= var_LM_SM_hazard;
			ALUA_MUX <= var_ALUA_MUX;
			ALUB_MUX <= var_ALUB_MUX;
			D3_MUX <= var_D3_MUX;
			end process;
end architecture;