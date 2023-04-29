-- A DUT entity is used to wrap your design so that we can combine it with testbench.
-- This example shows how you can do this for the OR Gate

library ieee;
use ieee.std_logic_1164.all;

entity DUT is
    port(input_vector: in std_logic_vector(34 downto 0));
end entity;

architecture DutWrap of DUT is
component IITB_CPU is
    port (
        --Clock and reset
        clock,Reset: in std_logic;
        --Input for External Memory Update
        Mem_Ext_WR:in std_logic;
        Mem_Ext_Data_in,Mem_Ext_Add : in std_logic_vector(15 downto 0)
    );
end component;
begin

   -- input/output vector element ordering is critical,
   -- and must match the ordering in the trace file!
   add_instance: IITB_CPU

					port map(
					clock=>input_vector(0) ,Reset=>input_vector(1),
        --Input for External Memory Update
        Mem_Ext_WR=>input_vector(2),
        Mem_Ext_Data_in=>input_vector(18 downto 3) ,Mem_Ext_Add=> input_vector(34 downto 19) 
		  );
end DutWrap;