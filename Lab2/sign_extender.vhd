-------------------------------------------------------------------------
-- Colton Hazlett
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- sign_extender.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of an edge-triggered MIPS register
-- file
--
--
-- NOTES:
-- 8/19/16 by JAZ::Design created.
-- 11/25/19 by H3:Changed name to avoid name conflict with Quartus
--          primitives.
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity sign_extender is
  
  port(i_Signed   :  in  std_logic;
       i_Data     :  in  std_logic_vector(15 downto 0);
       o_Data     :  out std_logic_vector(31 downto 0));

end sign_extender;

architecture structural of sign_extender is
   
signal s_oData : std_logic_vector(31 downto 0);

begin 
   
   o_Data <= s_oData;

   process (i_Signed, i_Data)
   begin
     if(i_Signed = '1' AND i_Data(15) = '1') then
        s_oData <=  "1111111111111111" & i_Data(15 downto 0);
     else
        s_oData <=  "0000000000000000" & i_Data(15 downto 0);
     end if;
   end process;

end structural;