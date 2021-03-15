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

   signal s_oFunct, s_oALUop : std_logic_vector(3 downto 0);

   begin

	--When R-type instruction
	with funct select
        	s_oFunct <= "1000" when "100000", --add
                	"1000" when "100001", --addu
                        "0100" when "100100", --and
                        "0110" when "100111", --nor
                        "0111" when "100110", --xor
                        "0101" when "100101", --or
                        "1011" when "101010", --slt
                        "0001" when "000000", --sll
                        "0010" when "000010", --srl
                        "0011" when "000011", --sra
                        "1001" when "100010", --sub
                        "1001" when "100011", --subu
                        "0000" when others;

        --When an I-Type instruction
	with i_ALUop select
        	s_oALUop <= "1000" when "0001", --addi
                	"1000" when "0010", --addiu
                        "1100" when "0011", --lui
                        "0100" when "0100", --andi
                        "0101" when "0101", --ori
                        "0111" when "0110", --xori
                        "1011" when "0111", --slti
                        "1110" when "1000", --lw
                        "1111" when "1001", --sw
                        "0000" when others;

	--Mux between R & I type command
	with i_ALUop select
		o_ALUop <= s_oFunct when "0000",
		 	   s_oALUop when others;

end structural;