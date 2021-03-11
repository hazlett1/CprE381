-------------------------------------------------------------------------
-- Dustin Heims
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- shift2bits.vhd

library IEEE;
use IEEE.std_logic_1164.all;

entity shift2bits is

  port(i_Data        : in std_logic_vector(31 downto 0);     -- Clock input
       o_Data        : out std_logic_vector(31 downto 0));   -- Data value output

end shift2bits;

architecture mixed of shift2bits is

begin

o_Data(31 downto 2) <= i_Data(29 downto 0);
o_Data(1 downto 0) <= "00";

  
end mixed;
