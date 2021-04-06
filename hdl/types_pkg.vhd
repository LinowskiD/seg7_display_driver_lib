library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package types_pkg is

  subtype t_digit is std_logic_vector(3 downto 0);
  type t_digits is array (natural range <>) of t_digit;
  type t_digit_select is array (natural range <>) of std_logic;
  type t_segments is record
    ca : std_logic;
    cb : std_logic;
    cc : std_logic;
    cd : std_logic;
    ce : std_logic;
    cf : std_logic;
    cg : std_logic;
  end record;
  type t_segment_pos is record
    ca : natural;
    cb : natural;
    cc : natural;
    cd : natural;
    ce : natural;
    cf : natural;
    cg : natural;
  end record;
  type t_digit_map_to_seg is array (16#0# to 16#F#) of std_logic_vector(6 downto 0);


end package types_pkg;