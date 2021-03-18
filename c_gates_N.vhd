-------------------------------------------------------------------------
-- Colton Hazlett
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- nor_N.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an XOR_N gate
--
--
-- NOTES:
-- 2/4/2020 by H3::Created.
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity c_gates_N is
  generic(N : integer := 32); -- Generic of type integer for input/output data width. Default value is 32.
  port(i_A   : in  std_logic_vector(N-1 downto 0);
       i_B   : in  std_logic_vector(N-1 downto 0);
       i_Sel : in  std_logic_vector(1 downto 0);
       o_Q   : out std_logic_vector(N-1 downto 0));


end c_gates_N;

architecture behavioral of c_gates_N is

begin

    with i_Sel select
     o_Q <=   i_A AND i_B when "00",
              i_A OR  i_B when "01",
              i_A XOR i_B when "10",
              i_A NOR i_B when "11",
              i_A when others;

end behavioral;