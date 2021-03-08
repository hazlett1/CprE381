-------------------------------------------------------------------------
-- Colton Hazlett
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- control.vhd
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

entity control is
  port(instruction  : in  std_logic_vector(5 downto 0);
       RegDst       : out std_logic;
       jump         : out std_logic;
       branch       : out std_logic;
       MemWR        : out std_logic;
       MemtoReg     : out std_logic;
       ALUSrc       : out std_logic;
       RegWE        : out std_logic;
       immSigned    : out std_logic;
       ALUop        : out std_logic_vector(3 downto 0));


end control;

architecture structural of control is

   -- Overview of array
   --   0    - ALUSrc
   --   1    - MemtoReg
   --   2    - s_MemWE
   --   3    - s_RegWE
   --   4    - RegDst
   --   5    - i_Signed
   --   6    - jump
   --   7    - branch
   --   8-11 - ALU control
   signal output : std_logic_vector(11 downto 0); --Temp placeholder for control outputs for with select statement

begin

    with instruction select 
       output <= "000000011000" when "000000", --R-type instruction
                 "000100101001" when "001000", --Addi
                 "001000001001" when "001001", --Addiu
                 "011000101001" when "001100", --Andi
                 "010100001001" when "001111", --lui
                 "101000101111" when "100011", --lw
                 "100000001001" when "001110", --xori
                 "011100001001" when "001101", --ori
                 "100100101001" when "001010", --slti
                 "101100100111" when "101011", --sw
                 "110010001001" when "000100", --beq
                 "110110001001" when "000101", --bne
                 "000001000000" when "000010", --j
                 "000001000000" when "000011", --jal
                 "000000000000" when others;

   ALUSrc    <= output(0);
   MemtoReg  <= output(1);
   MemWR     <= output(2);
   RegWE     <= output(3);
   RegDst    <= output(4);
   immSigned <= output(5);
   jump      <= output(6);
   branch    <= output(7);
   ALUop     <= output(11 downto 8);

end structural;