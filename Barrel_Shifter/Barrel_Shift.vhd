-------------------------------------------------------------------------
-- Dustin Heims
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- barrel_shifter.vhd

library IEEE;
use IEEE.std_logic_1164.all;

entity barrel_shift is
  
  port(i_Data 	: in std_logic_vector(31 downto 0);
	i_left 	: in std_logic; --1 for left and 0 for right 
	i_logic	: in std_logic; --1 for logic (unsigned) and 0 for arithmetic (signed)
	i_shift	: in std_logic_vector(4 downto 0); --shift amount
	o_Data	: out std_logic_vector(31 downto 0));
end barrel_shift;




architecture structural of barrel_shift is

signal s_oData : std_logic_vector(31 downto 0); --intermetiate wire

signal switched_bits : std_logic_vector(31 downto 0);

signal logicOrArith : std_logic; --used for making of if is logic or arithmetic

signal signedval : std_logic := '0';

signal unsignedval : std_logic := '1';

signal shiftLorR : std_logic_vector(31 downto 0);

component mux2t1_N is
  port(i_S          : in std_logic;
       i_D0         : in std_logic_vector(31 downto 0);
       i_D1         : in std_logic_vector(31 downto 0);
       o_OA         : out std_logic_vector(31 downto 0));
end component;

component mux2t1 is
    port(i_S                  : in std_logic;
         i_D0                 : in std_logic;
         i_D1                 : in std_logic;
         o_O                  : out std_logic);
  end component;





begin 
   
o_Data <= s_oData;


--logic for the 1 bit 2to1 mux for if arithmetic or logic
logicOrArthimetic : mux2t1
	port map(i_D0 => signedval,
		i_D1 => unsignedval,
		o_O => logicOrArith,
		i_S => i_logic);


switch_bits : for i in 0 to 31 generate
	switched_bits(31 downto 0) <= i_Data(31 - i downto 0); --this is done so that i can shift right on same mux logics
end generate switch_bits;

shiftleftorRight : mux2t1_N 
	port map(i_S => i_Left,
		i_D1 => i_Data,
		i_D0 => switched_bits,
		o_O  => shiftLorR);

32bitmuxshift : for i in 0 to 31 generate --making of the grid type of stuff for the actual shifting
	shiftlogic : mux2t1_N port map(
			i_S => 
			i_D1 =>
			i_D0 =>
			o_O  => );



end structural;