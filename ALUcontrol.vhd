-------------------------------------------------------------------------
-- Colton Hazlett
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- ALUcontrol.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of an Ones complementor 
-- that will negate each bit given in the single input.
--
--
-- NOTES:
-- 2/4/2020 by H3::Created.
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity ALUcontrol is
  port(i_ALUop   : in  std_logic_vector(3 downto 0);
       funct     : in  std_logic_vector(5 downto 0);
       o_ALUop   : out std_logic_vector(3 downto 0));
end ALUcontrol;

architecture structural of ALUcontrol is

   signal s_oFunct : std_logic_vector(3 downto 0);

   begin

	--When R-type instruction
	with funct select
        	s_oFunct <= "1000" when "100000", --add
                	    "1000" when "100001", --addu
                            "0100" when "100100", --and
                            "0111" when "100111", --nor
                            "0110" when "100110", --xor
                            "0101" when "100101", --or
                            "1011" when "101010", --slt
                            "0010" when "000010", --sll
                            "0001" when "000000", --srl
                            "0011" when "000011", --sra
                            "1001" when "100010", --sub
                            "1001" when "100011", --subu
                            "0000" when others;

	--Mux between R & I type command
	with i_ALUop select
		o_ALUop <= s_oFunct when "0000",
		 	   i_ALUop when others;

end structural;