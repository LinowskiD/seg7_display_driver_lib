library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library seg7_display_driver_lib;
use seg7_display_driver_lib.types_pkg.all;
use seg7_display_driver_lib.defines_pkg.all;

entity driver_top is
  generic (
    g_clock_frequency : natural := c_clock_frequency_default; -- in Hz
    g_number_of_digits : natural := c_number_of_digits_default;
    g_digit_change_interval : natural := c_digit_change_interval_default -- in miliseconds
  );
  port (
    i_clk : in std_logic;
    i_rst_n : in std_logic;
    i_digits : in t_digits((g_number_of_digits - 1) downto 0);
    o_segments : out t_segments;
    o_digit_select : out t_digit_select((g_number_of_digits - 1) downto 0)
  );
end entity driver_top;

architecture rtl of driver_top is

  constant c_clock_cycles_per_digit_change : natural := (g_clock_frequency / 1_000) * g_digit_change_interval;
  
  signal segments : t_segments;

  signal digit : t_digit;

  signal digit_nmb : natural range 0 to (g_number_of_digits - 1);

  signal digit_change_cnt : natural range 0 to (c_clock_cycles_per_digit_change - 1);

begin
  
  -- Extract currently processed digit
  digit <= i_digits(digit_nmb);
  
  p_encoder : process (digit)
    variable v_digit : natural;
  begin
    v_digit := to_integer(unsigned(digit));
    segments.ca <= c_digit_map_to_seg(v_digit)(c_seg_pos.ca);
    segments.cb <= c_digit_map_to_seg(v_digit)(c_seg_pos.cb);
    segments.cc <= c_digit_map_to_seg(v_digit)(c_seg_pos.cc);
    segments.cd <= c_digit_map_to_seg(v_digit)(c_seg_pos.cd);
    segments.ce <= c_digit_map_to_seg(v_digit)(c_seg_pos.ce);
    segments.cf <= c_digit_map_to_seg(v_digit)(c_seg_pos.cf);
    segments.cg <= c_digit_map_to_seg(v_digit)(c_seg_pos.cg);
  end process;

  o_segments <= segments when i_rst_n = '1' else (others => '0');
  o_digit_select <= (others => '0'); -- TODO

end architecture rtl;