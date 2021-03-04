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
  generic(N : integer := 32); -- Generic of type integer for input/output data width. Default value is 32.
  port(i_D          : in  std_logic_vector(5 downto 0);
       RegDst       : out std_logic;
       jump         : out std_logic;
       branch       : out std_logic;
       MemWR        : out std_logic;
       MemtoReg     : out std_logic;
       ALUSrc       : out std_logic;
       RegWrite     : out std_logic;
       immSigned    : out std_logic;
       ALUop        : out std_logic_vector(3 downto 0));


end control;

architecture structural of control is



begin



end structural;