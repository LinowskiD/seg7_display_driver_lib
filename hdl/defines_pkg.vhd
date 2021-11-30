library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library seg7_display_driver_lib;
use seg7_display_driver_lib.types_pkg.all;

package defines_pkg is

  constant c_clock_frequency_default : natural := 100_000_000;
  constant c_number_of_digits_default : natural := 4;
  constant c_digit_change_interval_default : natural := 1;
  constant c_digit_to_seg : t_digit_to_seg := (
    -- seg:    A    B    C    D    E    F    G
    16#0# => ('1', '1', '1', '1', '1', '1', '0'),
    16#1# => ('0', '1', '1', '0', '0', '0', '0'),
    16#2# => ('1', '1', '0', '1', '1', '0', '1'),
    16#3# => ('1', '1', '1', '1', '0', '0', '1'),
    16#4# => ('0', '1', '1', '0', '0', '1', '1'),
    16#5# => ('1', '0', '1', '1', '0', '1', '1'),
    16#6# => ('1', '0', '1', '1', '1', '1', '1'),
    16#7# => ('1', '1', '1', '0', '0', '0', '0'),
    16#8# => ('1', '1', '1', '1', '1', '1', '1'),
    16#9# => ('1', '1', '1', '1', '0', '1', '1'),
    16#A# => ('1', '1', '1', '1', '1', '0', '1'),
    16#B# => ('0', '0', '1', '1', '1', '1', '1'),
    16#C# => ('1', '0', '0', '1', '1', '1', '0'),
    16#D# => ('0', '1', '1', '1', '1', '0', '1'),
    16#E# => ('1', '0', '0', '1', '1', '1', '1'),
    16#F# => ('1', '0', '0', '0', '1', '1', '1')
  );

end package defines_pkg;