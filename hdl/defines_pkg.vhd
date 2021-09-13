library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library seg7_display_driver_lib;
use seg7_display_driver_lib.types_pkg.all;

package defines_pkg is

  constant c_clock_frequency_default : natural := 100_000_000;
  constant c_number_of_digits_default : natural := 4;
  constant c_digit_change_interval_default : natural := 1;
  constant c_seg_pos : t_segment_pos := (
    ca => 6,
    cb => 5,
    cc => 4,
    cd => 3,
    ce => 2,
    cf => 1,
    cg => 0
  );
  constant c_digit_map_to_seg : t_digit_map_to_seg := (
    16#0# => "0000001",
    16#1# => "1001111",
    16#2# => "0010010",
    16#3# => "0000110",
    16#4# => "1001100",
    16#5# => "0100100",
    16#6# => "0100000",
    16#7# => "0001111",
    16#8# => "0000000",
    16#9# => "0000100",
    16#A# => "0000010",
    16#B# => "1100000",
    16#C# => "0110001",
    16#D# => "1000010",
    16#E# => "0110000",
    16#F# => "0111000"
  );

end package defines_pkg;