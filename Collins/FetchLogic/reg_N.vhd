-------------------------------------------------------------------------
-- Colton Hazlett
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- reg_N.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of an edge-triggered
-- N-Bit register file
--
--
-- NOTES:
-- 8/19/16 by JAZ::Design created.
-- 11/25/19 by H3:Changed name to avoid name conflict with Quartus
--          primitives.
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity reg_N is
  generic(N : integer := 32); -- Generic of type integer for input/output data width. Default value is 32.
  port(i_CLK        : in  std_logic;                        -- Clock input
       i_RST        : in  std_logic;                        -- Reset input
       i_WE         : in  std_logic;                        -- Write enable input
       i_D          : in  std_logic_vector(N-1 downto 0);   -- Data value input
       o_Q          : out std_logic_vector(N-1 downto 0));  -- Data value output

end reg_N;

architecture mixed of reg_N is
  signal s_D    : std_logic_vector(N-1 downto 0);    -- Multiplexed input to the FF
  signal s_Q    : std_logic_vector(N-1 downto 0);    -- Output of the FF

  component dffg is
    port(i_CLK        : in std_logic;     -- Clock input
         i_RST        : in std_logic;     -- Reset input
         i_WE         : in std_logic;     -- Write enable input
         i_D          : in std_logic;     -- Data value input
         o_Q          : out std_logic);   -- Data value output
   end component;

begin
  
  -- The output of the FF is fixed to s_Q
  o_Q <= s_Q;

   -- Create a multiplexed input to the FF based on i_WE
  with i_WE select
    s_D <= i_D when '1',
           s_Q when others;

  -- This process handles the asyncrhonous reset and
  -- synchronous write. We want to be able to reset 
  -- our processor's registers so that we minimize
  -- glitchy behavior on startup.
  process (i_CLK, i_RST)
  begin
    if (i_RST = '1') then
      for i in 0 to N-1 loop
        s_Q(i) <= '0'; -- Loops through all the bits and sets it to 0
      end loop;
    elsif (rising_edge(i_CLK)) then
      s_Q <= s_D;
    end if;
  end process;
 

  -- Instantiate N dffg instances.
  G_NBit_dff: for i in 0 to N-1 generate
    DFF: dffg port map(
              i_CLK      => i_CLK,
              i_RST      => i_RST,
              i_WE       => i_WE,
              i_D        => s_D(i),
              o_Q        => s_Q(i));

  end generate G_NBit_dff;

  
  
end mixed;