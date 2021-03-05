library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library seg7_display_driver_lib;
use seg7_display_driver_lib.types_pkg.all;
use seg7_display_driver_lib.defines_pkg.all;

entity driver_top is
  generic (
    g_number_of_digits : natural := c_number_of_digits_default
  );
  port (
    i_clk : in std_logic;
    i_rst_n : in std_logic;
    i_digits : in t_digits(0 to (g_number_of_digits - 1));
    o_segments : out t_segments;
    o_digit_select : out t_digit_select(0 to (g_number_of_digits - 1))
  );
end entity driver_top;

architecture struct of driver_top is

begin

  

end architecture struct;