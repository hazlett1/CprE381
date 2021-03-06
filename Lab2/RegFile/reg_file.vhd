-------------------------------------------------------------------------
-- Colton Hazlett
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- reg_file.vhd
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
use work.mypack.all;  --Include the inputArray array for 31-1 mux

entity reg_file is
  generic(N : integer := 32); -- Generic of type integer for input/output data width. Default value is 32.
  port(i_CLK        : in  std_logic;                        -- Clock input
       i_RST        : in  std_logic;                        -- Reset input
       i_WE         : in std_logic;                         -- Write enabled input
       i_WS         : in  std_logic_vector(4 downto 0);     -- Write select input
       i_sRS        : in  std_logic_vector(4 downto 0);     -- Select bits for source register
       i_sRT        : in  std_logic_vector(4 downto 0);     -- Select bits for target register
       i_wD         : in  std_logic_vector(31 downto 0);    -- Data value input
       o_RT         : out std_logic_vector(31 downto 0);    -- Output from target register
       o_RS         : out std_logic_vector(31 downto 0));   -- Output from source register

end reg_file;

architecture mixed of reg_file is
   ---------------------------------------------------
   -- Step 1 initialize all the components to be used
   ---------------------------------------------------

   component reg_N is
    port(i_CLK        : in  std_logic;                        -- Clock input
         i_RST        : in  std_logic;                        -- Reset input
         i_WE         : in  std_logic;                        -- Write enable input
         i_D          : in  std_logic_vector(31 downto 0);    -- Data value input
         o_Q          : out std_logic_vector(31 downto 0));   -- Data value output
   end component;

   component mux32t1_N is
     port(i_S   : in  std_logic_vector(4 downto 0);       -- Select Bits 
          i_D   : in  inputArray;
          o_Y   : out std_logic_vector(N-1 downto 0));    -- Decoder output
   end component;

   component decoder5t32 is
     port(i_W          : in  std_logic_vector(4 downto 0);     -- Select Bits 
          o_Y          : out std_logic_vector(31 downto 0));   -- Decoder output
   end component;

   --------------------------------------------------------
   -- Step 2: Declare all the signals that will be needed
   --------------------------------------------------------

   signal s_oDC, s_Temp  :  std_logic_vector(31 downto 0);

   signal s_sRT  :  std_logic_vector(4 downto 0); 
   signal s_sRS  :  std_logic_vector(4 downto 0);
   signal s_oRT  :  std_logic_vector(31 downto 0);
   signal s_oRS  :  std_logic_vector(31 downto 0);
   signal s_iD   :  inputArray;
   
begin
   
   g_Decoder: decoder5t32
    port map(i_W   =>  i_WS,
             o_Y   =>  s_Temp);
   
   with i_WE select
      s_oDC <= s_Temp when '1',
               "00000000000000000000000000000000" when others;

   g_Regs: for i in 1 to 31 generate
    REG: reg_N port map(i_CLK  => i_CLK,
                        i_RST  => i_RST,
                        i_WE   => s_oDC(i),
                        i_D    => i_wD,
                        o_Q    => s_iD(i)); 
   end generate g_Regs;

   s_iD(0) <= "00000000000000000000000000000000";

   g_Mux_RT: mux32t1_N
    port map( i_S  => i_sRT,
              i_D  => s_iD,
              o_Y  => o_RT);

   g_Mux_RS: mux32t1_N
    port map( i_S  => i_sRS,
              i_D  => s_iD,
              o_Y  => o_RS);
  
end mixed;