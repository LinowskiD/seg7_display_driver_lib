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
    16#0# => ('0', '0', '0', '0', '0', '0', '1'),
    16#1# => ('1', '0', '0', '1', '1', '1', '1'),
    16#2# => ('0', '0', '1', '0', '0', '1', '0'),
    16#3# => ('0', '0', '0', '0', '1', '1', '0'),
    16#4# => ('1', '0', '0', '1', '1', '0', '0'),
    16#5# => ('0', '1', '0', '0', '1', '0', '0'),
    16#6# => ('0', '1', '0', '0', '0', '0', '0'),
    16#7# => ('0', '0', '0', '1', '1', '1', '1'),
    16#8# => ('0', '0', '0', '0', '0', '0', '0'),
    16#9# => ('0', '0', '0', '0', '1', '0', '0'),
    16#A# => ('0', '0', '0', '0', '0', '1', '0'),
    16#B# => ('1', '1', '0', '0', '0', '0', '0'),
    16#C# => ('0', '1', '1', '0', '0', '0', '1'),
    16#D# => ('1', '0', '0', '0', '0', '1', '0'),
    16#E# => ('0', '1', '1', '0', '0', '0', '0'),
    16#F# => ('0', '1', '1', '1', '0', '0', '0')
  );

end package defines_pkg;