library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library seg7_display_driver_lib;
use seg7_display_driver_lib.types_pkg.all;
use seg7_display_driver_lib.defines_pkg.all;

entity seg_ctrl is
  port (
    i_digit    : in  t_digit;
    o_segments : out t_segments
  );
end entity seg_ctrl;

architecture rtl of seg_ctrl is

  signal segments : t_segments;

begin

  o_segments <= segments;

  p_encoder : process (i_digit)
    variable v_digit : natural := to_integer(unsigned(i_digit));
  begin
    segments.ca <= c_digit_map_to_seg(v_digit)(c_seg_pos.ca);
    segments.cb <= c_digit_map_to_seg(v_digit)(c_seg_pos.cb);
    segments.cc <= c_digit_map_to_seg(v_digit)(c_seg_pos.cc);
    segments.cd <= c_digit_map_to_seg(v_digit)(c_seg_pos.cd);
    segments.ce <= c_digit_map_to_seg(v_digit)(c_seg_pos.ce);
    segments.cf <= c_digit_map_to_seg(v_digit)(c_seg_pos.cf);
    segments.cg <= c_digit_map_to_seg(v_digit)(c_seg_pos.cg);
  end process;

end architecture rtl;