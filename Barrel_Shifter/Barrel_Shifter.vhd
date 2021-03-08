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
	i_logic	: in std_logic; --1 for logic (unsigned) and 0 for arithmetic (signed)
	i_shift	: in std_logic_vector(4 downto 0); --shift amount
	o_Data	: out std_logic_vector(31 downto 0));
end barrel_shifter;

architecture behavior of barrel_shifter is

signal s_oData : std_logic_vector(63 downto 0);

begin 
   
o_Data <= s_oData;
   
process (i_Data, i_left, i_logic, i_shift)
begin
--if for arithmetric and has 1 need to add ones and not zeros
--possible to make a for loop with logic in text channel or meeting room
	if(i_logic = '1') then
		if(i_left = '1') then
		--unsigdned (logical) always add 0
		with i_shift select
			s_oData <= i_Data(31 downto 0) when "00000",
				i_Data(31 downto 0) & "0" when "00001",
				i_Data(31 downto 0) & "00" when "00010",
				i_Data(31 downto 0) & "000" when "00011",
				i_Data(31 downto 0) & "0000" when "00100",
			i_Data 
			
			
			o_Data <= s_oData(31 downto 0);
		else
		with i_shift select
			s_oData <= i_Data(31 downto 0) when "00000",
			s_oData <= i_Data(31 downto 0) & "0" when "00001",
			
	--for arithmetic have to check if 0 or one
	else
		with i

	end if;
end Behavioral;