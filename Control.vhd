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
       equals       : out std_logic;
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
   --   8    - equals
   --   9-12 - ALU control
   signal output : std_logic_vector(12 downto 0); --Temp placeholder for control outputs for with select statement

begin

    -- Merge together all the output bits
    with instruction select 
       output <= "0000000011000" when "000000", --R-type instruction
                 "0001000101001" when "001000", --Addi
                 "0010000001001" when "001001", --Addiu
                 "0110000101001" when "001100", --Andi
                 "0101000001001" when "001111", --lui
                 "1010000101111" when "100011", --lw
                 "1000000001001" when "001110", --xori
                 "0111000001001" when "001101", --ori
                 "1001000101001" when "001010", --slti
                 "1011000100111" when "101011", --sw
                 "1100110001001" when "000100", --beq
                 "1101010001001" when "000101", --bne
                 "0000001000000" when "000010", --j
                 "0000001000000" when "000011", --jal
                 "0000000000000" when others;
   
   --Seperate the array into all of the outputs
   ALUSrc    <= output(0);
   MemtoReg  <= output(1);
   MemWR     <= output(2);
   RegWE     <= output(3);
   RegDst    <= output(4);
   immSigned <= output(5);
   jump      <= output(6);
   branch    <= output(7);
   equals    <= output(8);
   ALUop     <= output(12 downto 9);

end structural;