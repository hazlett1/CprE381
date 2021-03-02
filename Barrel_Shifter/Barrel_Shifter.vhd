-------------------------------------------------------------------------
-- Dustin Heims
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- barrel_shifter.vhd

library IEEE;
use IEEE.std_logic_1164.all;

entity barrel_shifter is
  
  port(i_Data 	: in std_logic_vector(31 downto 0);
	i_left 	: in std_logic; --1 for left and 0 for right 
	i_logic	: in std_logic; --1 for logic and 0 for arithmetic
	i_shift	: in std_logic_vector; --shift amount
	o_Data	: out std_logic_vector(31 downto 0));

end barrel_shifter;

architecture structural of barrel_shifter is
   
signal s_oData : std_logic_vector(31 downto 0);

begin 
   
   o_Data <= s_oData;

   process (i_Data, i_left, i_logic, i_shift)
   begin
     if() then
        
     else
        
     end if;
   end process;

end structural;