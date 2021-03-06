-------------------------------------------------------------------------
-- Colton Hazlett
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- full_adder_N.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of an N-bit wide 2:1
-- mux using structural VHDL, generics, and generate statements.
--
--
-- NOTES:
-- 1/6/20 by H3::Created.
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity full_adder_N is
  generic(N : integer := 32); -- Generic of type integer for input/output data width. Default value is 32.
  port( i_vC         :  in std_logic;
        i_vA         :  in std_logic_vector(N-1 downto 0);
        i_vB         :  in std_logic_vector(N-1 downto 0);
        o_vS         : out std_logic_vector(N-1 downto 0);
        o_vC         : out std_logic);

end full_adder_N;

architecture structural of full_adder_N is

  component full_adder is
    port(i_C                  :  in std_logic;
         i_A                  :  in std_logic;
         i_B                  :  in std_logic;
         o_S                  : out std_logic;
         o_C                  : out std_logic);
  end component;

  signal t_C : std_logic_vector(N downto 0);

begin

  t_C(0) <= i_vC;
  o_vC   <= t_C(N);

  -- Instantiate N full_adder instances.
  G_NBit_ADDER: for i in 0 to N-1 generate
    ADDER: full_adder port map(
              i_C       => t_C(i),
              i_A       => i_vA(i), -- Map all the bits for the value A to the vector A
              i_B       => i_vB(i), -- Map all the bits for the value B to the vector B
              o_S       => o_vS(i), -- Map all the bits from the the sum of A and B to the vector S
              o_C       => t_C(i+1));   -- Will be one if there needs to be a carry bit.
  
  end generate G_NBit_ADDER;    
  
end structural;