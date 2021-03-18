-------------------------------------------------------------------------
-- Dustin Heims
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- bitshift28.vhd

library IEEE;
use IEEE.std_logic_1164.all;

entity bitshift28 is

  port(i_Data        : in std_logic_vector(25 downto 0);   
       i_PC          : in std_logic_vector(31 downto 0);  
       o_Data        : out std_logic_vector(31 downto 0));   

end bitshift28;

architecture mixed of bitshift28 is

begin

o_Data(27 downto 0)  <= i_Data(25 downto 0) & "00";
o_Data(31 downto 28) <= i_PC(31 downto 28);
  
end mixed;
