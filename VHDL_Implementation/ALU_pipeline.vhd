library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ALU is
	port( sel: in std_logic_vector(1 downto 0); 
			ALU_A: in std_logic_vector(15 downto 0);
			ALU_B: in std_logic_vector(15 downto 0);
			C_in: in std_logic;
			Carry_sel: in std_logic;
			ALU_c: out std_logic_vector(15 downto 0);
			C_F: out std_logic;
			Z_F: out std_logic
		);
end ALU;

architecture behave of ALU is
-------ADD-SUM-------------------------------------------------------------
   function add_sum( a,b : in std_logic_vector(15 downto 0);
		     M : in std_logic
					)
		return std_logic_vector is
			variable sum :  std_logic_vector(16 downto 0); 
			variable carry: std_logic_vector(15 downto 0);
		begin
			loop1 : for i in 0 to 15 loop
					if i=0 then
				       		 sum(i) := a(i) xor (b(i) xor M) xor M;
					         carry(i) := (a(i) and (b(i) xor M)) or (M and ( a(i) or (b(i) xor M)));
					else 
						sum(i) := a(i) xor (b(i) xor M) xor carry(i-1);
						carry(i) := (a(i) and (b(i) xor M)) or (carry(i-1) and ( a(i) or (b(i) xor M)));
					end if;
			end loop loop1;
			sum(16) := carry(15);
		return sum;
    end add_sum;

-------BIT-WISE-NAND-----------------------------------------------------	
	function bit_nand(a: in std_logic_vector(15 downto 0);
			  b: in std_logic_vector(15 downto 0))
		return std_logic_vector is
			variable S : std_logic_vector(15 downto 0);
		begin
			loop3 : for i in 0 to 15 loop
		               S(i) :=(a(i) nand b(i));
			end loop loop3;
		return S;
	end bit_nand ;
	
	begin
		alu : process(ALU_A, ALU_B,sel,Carry_sel,C_in)
		variable temp : std_logic_vector(16 downto 0);

			begin
------ALU_C AND CARRY FLAG-------------------------------------------------
				if (sel = "00") then		
						if ( Carry_sel = '1') then
							temp := add_sum(ALU_A,ALU_B,'0');
							C_F <= temp(16);
							temp := add_sum(temp(15 downto 0),"000000000000000" & C_in,'0');
							ALU_C <= temp(15 downto 0);							
						else 
							temp := add_sum(ALU_A,ALU_B,'0');
							ALU_C <= temp(15 downto 0);
							C_F <= temp(16);
						end if;
				
				elsif (sel = "01") then
							temp := add_sum(ALU_A,ALU_B,'1');
							ALU_C <= temp(15 downto 0);
							C_F <=  not temp(16);
						
				else 
						temp := '0' & bit_nand(ALU_A,ALU_B);
						ALU_C <= temp(15 downto 0);
						C_F <= temp(16);
							
				end if;
				
---------------------ZERO FLAG----------------------------------------------
				if( temp(15 downto 0) = "0000000000000000") then
					Z_F <= '1';
				else 
					Z_F <= '0';
				end if;
				
	
	end process;
end behave;