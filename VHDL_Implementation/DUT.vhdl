-- A DUT entity is used to wrap your design so that we can combine it with testbench.
-- This example shows how you can do this for the OR Gate

library ieee;
use ieee.std_logic_1164.all;

entity DUT is
    port(input_vector: in std_logic_vector(5 downto 0);
       	output_vector: out std_logic_vector(7 downto 0));
end entity;

architecture DutWrap of DUT is
   component Datapath is
     port(
        --Inputs
        clock, reset:in std_logic;
		  Reg_sel : in std_logic_vector(3 downto 0);
		  output_Reg : out std_logic_vector(7 downto 0) 
		);
   end component;
begin

   -- input/output vector element ordering is critical,
   -- and must match the ordering in the trace file!
   add_instance: Datapath 
			port map (
					-- order of inputs clock reset
					clock   => input_vector(1),
					reset   => input_vector(0),
               -- order of output OUTPUT
					output_Reg => output_vector(7 downto 0));
end DutWrap;