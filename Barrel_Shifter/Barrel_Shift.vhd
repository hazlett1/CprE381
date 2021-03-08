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

signal switched_bits : std_logic_vector(31 downto 0); --switch bits so that I can do right shift

signal logicOrArith : std_logic; --used for making of if is logic or arithmetic

signal signedval : std_logic := '0';

signal unsignedval : std_logic := '1'; --hard coded for sign or unsigned to add 1 or 0 for sign or unsigned

signal shiftLorR : std_logic_vector(31 downto 0);

signal o_firstshift : std_logic;

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
   
--o_Data <= s_oData;

---------------------------------------------------------------------------------------------------
--logic for the 1 bit 2to1 mux for if arithmetic or logic and chooses which to add to shifting bits
---------------------------------------------------------------------------------------------------
logicOrArthimetic : mux2t1
	port map(i_D0 => signedval,
		i_D1 => unsignedval,
		o_O => logicOrArith,
		i_S => i_logic);


-------------------------------------------------------
--switching of intial bits and checking if right or left
-------------------------------------------------------
bitswitching : for i in 0 to 31 generate
	switched_bits(i) <= i_Data(31 - i); --this is done so that i can shift right on same mux logics
end generate bitswitching;



shiftleftorRight : mux2t1_N --mux for it it is to be shift left or right
	port map(i_S => i_Left,
		i_D1 => i_Data,
		i_D0 => switched_bits,
		o_OA  => shiftLorR);


------------------------------
--shifting of the intial 1 bit
------------------------------
bitmuxshift_1 : for i in 31 downto 1 generate
shiftlogic_1 : mux2t1 port map(
	i_S => i_Shift(0), 
	i_D1 => shiftLorR(i),
	i_D0 => shiftLorR(i-1),
	o_O => o_firstShift);
end generate bitmuxshift_1;

shift_1 : mux2t1 port map( --setting of intial bits
	i_S => i_Shift(0), --shift amount LSB
	i_D1 => i_logic,
	i_D0 => shiftLorR(0),
	o_O => o_firstShift);

--------------------
--shifting of 2 bits
--------------------
bitmuxshift_2 : for i in 31 downto 2 generate
shiftlogic_2 : mux2t1 port map(
	i_S => i_Shift(1), 
	i_D1 => shiftLorR(i),
	i_D0 => shiftLorR(i-2),
	o_O => o_firstShift);
end generate bitmuxshift_2;

shift_2 : mux2t1 port map( --setting of intial bits
	i_S => i_Shift(1), --shift amount LSB
	i_D1 => i_logic,
	i_D0 => shiftLorR(0),
	o_O => o_firstShift);


----------------
--shifting 4 bits
-----------------
bitmuxshift_4 : for i in 31 downto 4 generate
shiftlogic_4 : mux2t1 port map(
	i_S => i_Shift(2), 
	i_D1 => shiftLorR(i),
	i_D0 => shiftLorR(i-4),
	o_O => o_firstShift);
end generate bitmuxshift_4;

shift_4 : mux2t1 port map( --setting of intial bits
	i_S => i_Shift(2), --shift amount LSB
	i_D1 => i_logic,
	i_D0 => shiftLorR(0),
	o_O => o_firstShift);

-----------------
--shifting 8 bits
-----------------
bitmuxshift_8 : for i in 31 downto 8 generate
shiftlogic_8 : mux2t1 port map(
	i_S => i_Shift(3), 
	i_D1 => shiftLorR(i),
	i_D0 => shiftLorR(i-8),
	o_O => o_firstShift);
end generate bitmuxshift_8;

shift_8 : mux2t1 port map( --setting of intial bits
	i_S => i_Shift(3), --shift amount LSB
	i_D1 => i_logic,
	i_D0 => shiftLorR(0),
	o_O => o_firstShift);


-----------------
--shifting 16 bits
-----------------
bitmuxshift_16 : for i in 31 downto 16 generate
shiftlogic_16 : mux2t1 port map(
	i_S => i_Shift(4), 
	i_D1 => shiftLorR(i),
	i_D0 => shiftLorR(i-16),
	o_O => o_firstShift);
end generate bitmuxshift_16;

shift_16 : mux2t1 port map( --setting of intial bits
	i_S => i_Shift(4), --shift amount LSB
	i_D1 => i_logic,
	i_D0 => shiftLorR(0),
	o_O => o_firstShift);


-------------------------------------
--switching back to the original bits
-------------------------------------
bitswitchback : for i in 0 to 31 generate
	switched_bits(i) <= shiftLorR(31 - i); --switch back to normal
end generate bitswitchback;


shiftleftorRight_2 : mux2t1_N --mux for it it is to be shift left or right
	port map(i_S => i_Left,
		i_D1 => shiftLorR,
		i_D0 => switched_bits,
		o_OA  => o_Data);

end structural;