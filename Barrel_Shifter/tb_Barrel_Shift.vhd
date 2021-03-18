-------------------------------------------------------------------------
-- Henry Duwe
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------
-- tb_Barrel_Shift.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains a testbench for the TPU MAC unit.
--              
-- 01/03/2020 by H3::Design created.
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_textio.all;  -- For logic types I/O
library std;
use std.env.all;                -- For hierarchical/external signals
use std.textio.all;             -- For basic I/O



entity tb_Barrel_Shift is
  generic(gCLK_HPER   : time := 10 ns; N:integer:=32);   

  
end tb_Barrel_Shift;
  --

architecture muxxedeted of tb_Barrel_Shift is



constant cCLK_PER  : time := gCLK_HPER * 2;




component Barrel_Shift is
  port(	i_Data 	: in std_logic_vector(31 downto 0);
	i_left 	: in std_logic; --1 for left and 0 for right 
	i_logic	: in std_logic; --1 for logic (unsigned) and 0 for arithmetic (signed)
	i_shift	: in std_logic_vector(4 downto 0);--shift amount
	o_Data	: out std_logic_vector(31 downto 0));
end component;



signal CLK, reset : std_logic := '0';



signal s_i_Data                	:  std_logic_vector(31 downto 0);
signal s_i_left                	:  std_logic; --1 for left and 0 for right 
signal s_i_logic                :  std_logic; --1 for logic (unsigned) and 0 for arithmetic (signed)
signal s_i_shift		:  std_logic_vector(4 downto 0); --shift amount
signal s_o_Data			:  std_logic_vector(31 downto 0);

begin


  DUT0: Barrel_Shift
  port map(
 i_Data     =>    s_i_Data,
 i_left     =>    s_i_left,  
 i_logic    =>    s_i_logic,    
 i_shift     =>   s_i_shift,    
 o_Data     =>   s_o_Data);        



  

  P_TEST_CASES: process
  begin
    wait for gCLK_HPER/2; -- for waveform clarity, I prefer not to change inputs on clk edges




    -- Test case 1:

	s_i_Data	<=  x"0000000F"; -- 32 bits
	s_i_left	<=  '1'; -- 1 because we want to go left
	s_i_logic	<=  '1'; -- 1 because we want unsigned
	s_i_shift	<=  "00100"; --5 bits

  
    wait for gCLK_HPER*2;
    -- Expect: o_Data = x"000000F0"





  end process;

end muxxedeted;
