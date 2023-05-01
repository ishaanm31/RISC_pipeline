library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ALU_pipeline is
	port( sel: in std_logic_vector(2 downto 0); 
			ALU_A: in std_logic_vector(15 downto 0);
			ALU_B: in std_logic_vector(15 downto 0);
			ALU_c: out std_logic_vector(15 downto 0);
			C_F: out std_logic;
			Z_F: out std_logic
		);
end ALU_pipeline;

architecture behave of ALU_pipeline is
-------ADD-SUM-------------------------------------------------------------
   function add_sum( a,b : in std_logic_vector(15 downto 0);
		     M : in std_logic
					)
		return std_logic_vector is
			variable sum :  std_logic_vector(15 downto 0); 
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
		return sum;
    end add_sum;
---------ADD-CARRY-----------------------------------------------------------
    function add_carry( a,b : in std_logic_vector(15 downto 0);
		        M : in std_logic
					)
		return std_logic is
			variable sum :  std_logic_vector(15 downto 0); 
			variable carry: std_logic_vector(15 downto 0);
		begin
			loop2 : for i in 0 to 15 loop
				if i=0 then
					sum(i) := a(i) xor (b(i) xor M) xor M;
					carry(i) := (a(i) and (b(i) xor M)) or (M and ( a(i) or (b(i) xor M)));
				else 
					sum(i) := a(i) xor (b(i) xor M) xor carry(i-1);
					carry(i) := (a(i) and (b(i) xor M)) or (carry(i-1) and ( a(i) or (b(i) xor M)));
				end if;
			end loop loop2;
		return carry(15);
	end add_carry;	
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
-------COMPLEMENT------------------------------------------------
	function cpl(a: in std_logic_vector(15 downto 0))
	return std_logic_vector is
		variable S : std_logic_vector(15 downto 0);
	begin
		loop4 : for i in 0 to 15 loop
		     S(i) :=(not a(i));
		end loop loop4;
	return S;
	end cpl ;

	begin
		alu : process(ALU_A, ALU_B,sel)
			begin
			----------ALU_C and ZERO FLAG-----------
				if (sel= "000") then
						ALU_C <= add_sum(ALU_A,ALU_B,'0');
						C_F <= add_carry(ALU_A,ALU_B,'0');
						if( add_sum(ALU_A,ALU_B,'0')= "0000000000000000") then
							Z_F <= '1';
						else Z_F <= '0';
						end if;
						
				elsif (sel= "001") then
						ALU_C <= bit_nand(ALU_A,ALU_B);
						C_F <= '0';
						if( bit_nand(ALU_A,ALU_B) = "0000000000000000") then
							Z_F <= '1';
						else Z_F <= '0';

						end if;
						
				elsif (sel= "010") then
						ALU_C <= add_sum(ALU_A,ALU_B,'1');
						C_F <= add_carry(ALU_A,ALU_B,'1');
						if( add_sum(ALU_A,ALU_B,'1') = "0000000000000000") then
							Z_F <= '1';
						else Z_F <= '0';
						end if;
						
				elsif (sel= "100") then
						ALU_C <= add_sum(ALU_A,cpl(ALU_B),'0');
						C_F <= add_carry(ALU_A,cpl(ALU_B),'0');
						if( add_sum(ALU_A,cpl(ALU_B),'1') = "0000000000000000") then
							Z_F <= '1';
						else Z_F <= '0';
						end if;

						
				else
						ALU_C <= bit_nand(ALU_A,cpl(ALU_B));
						C_F <= '0';
						if( bit_nand(ALU_A,cpl(ALU_B)) = "0000000000000000") then
							Z_F <= '1';
						else Z_F <= '0';
						end if;
						
			
				
				end if;
---------------------CARRY FLAG----------------------------
---I am modifing carry flag every time,
---but we can set the carry ff to reset
---when we dont want to modify it.	
	end process;
end behave;