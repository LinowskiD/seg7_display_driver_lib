library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package driver_pkg is

  type t_driver_conf is record
    number_of_digits                : natural;
    digit_change_interval_bit_size  : natural;
    digit_change_interval           : natural;
  end record;
  
  type t_segments is record
    ca : std_logic;
    cb : std_logic;
    cc : std_logic;
    cd : std_logic;
    ce : std_logic;
    cf : std_logic;
    cg : std_logic;
  end record;
  type t_digit_to_seg is array (16#0# to 16#F#) of t_segments;
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
  constant c_digit_vec_len : natural := 4;
  type t_value is array (natural range <>) of std_logic_vector(c_digit_vec_len - 1 downto 0);

  function generics_verification(
    driver_conf : t_driver_conf
  ) return boolean;

end package driver_pkg;

package body driver_pkg is

  function generics_verification(
    driver_conf : t_driver_conf
  ) return boolean is
  begin
    assert (driver_conf.number_of_digits > 0)
      report "driver_conf.number_of_digits must be greater than 0!"
      severity failure;
    assert (driver_conf.digit_change_interval_bit_size > 0)
      report "driver_conf.digit_change_interval_bit_size must be greater than 0!"
      severity failure;
    assert (driver_conf.digit_change_interval > 0)
      report "driver_conf.digit_change_interval must be greater than 0!"
      severity failure;
    return true;
  end function;

end package body driver_pkg;