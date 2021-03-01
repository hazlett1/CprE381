-------------------------------------------------------------------------
-- Colton Hazlett
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- ones_comp_N.vhd
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

entity ones_comp_N is
  generic(N : integer := 32); -- Generic of type integer for input/output data width. Default value is 32.
  port(i_D          : in  std_logic_vector(N-1 downto 0);
       o_O          : out std_logic_vector(N-1 downto 0));

end ones_comp_N;

architecture structural of ones_comp_N is

  component invg
    port(i_A        : in std_logic;
         o_F        : out std_logic);
  end component;

begin
  -- Instantiate N mux instances.
  G_NBit_ONES_COMP: for i in 0 to N-1 generate
    NEG: invg port map(
              i_A   => i_D(i),   -- ith instance's data input hooked up to ith data 0 input.
              o_F   => o_O(i));  -- ith instance's data output hooked up to ith data output.
  end generate G_NBit_ONES_COMP;
  
end structural;