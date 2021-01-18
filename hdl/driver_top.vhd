library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library seg7_display_driver_lib;
use seg7_display_driver_lib.types_pkg.all;
use seg7_display_driver_lib.defines_pkg.all;

entity driver_top is
  generic (
    g_number_of_digits : natural := c_number_of_digits_default;
    g_freq_divider : natural := 1  -- TODO: properly define how this mechanism should work
  );
  port (
    i_clk : in std_logic;
    i_rst_n : in std_logic;
    i_digits : in std_logic_vector((4 * g_number_of_digits - 1) downto 0);
    o_segments : out std_logic_vector(6 downto 0);
    o_digit_select : out std_logic_vector((g_number_of_digits - 1) downto 0)
  );
end entity driver_top;

architecture struct of driver_top is

begin

  

end architecture struct;