library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

library vunit_lib;
context vunit_lib.vunit_context;

library seg7_display_driver_lib;
use seg7_display_driver_lib.driver_pkg.all;

package driver_tb_pkg is

  type t_boolean_array is array (natural range <>) of boolean;
  type t_char_matrix is array (natural range <>) of string;
  
  constant c_system_clock_in_hz         : natural := 100_000_000;
  constant c_clk_period                 : time := 10**3 * 1 ms / c_system_clock_in_hz;
  constant c_number_of_digits           : natural := c_number_of_digits_default;
  constant c_digit_change_interval      : natural := 100; -- clock cycles
  constant c_digit_change_interval_time : time := c_clk_period * c_digit_change_interval; -- time
  constant c_digit_on_off_ratio         : natural := c_digit_on_off_ratio_default;

  constant separator : string := "-------------------------------------------------------------------";

  function get_slice(
    v       : std_logic_vector;
    pos     : natural;
    pos_len : natural := c_digit_vec_len
  ) return std_logic_vector;

  function get_slice_range(
    pos     : natural;
    pos_len : natural := c_digit_vec_len
  ) return std_logic_vector;

  procedure walk (
    signal   clk   : in std_logic;
    constant steps : natural := 1
  );

  procedure display_segments (
    signal segments : in t_segments
  );

end package driver_tb_pkg;

package body driver_tb_pkg is

  function get_slice(
    v       : std_logic_vector;
    pos     : natural;
    pos_len : natural := c_digit_vec_len
  ) return std_logic_vector is
  begin
    return v((pos_len * pos + pos_len - 1) downto (pos_len * pos));
  end function;

  function get_slice_range(
    pos     : natural;
    pos_len : natural := c_digit_vec_len
  ) return std_logic_vector is
    variable v : std_logic_vector((pos_len * pos + pos_len - 1) downto (pos_len * pos)) := (others => '0');
  begin
    return v;
  end function;

  procedure walk (
    signal   clk   : in std_logic;
    constant steps : natural := 1
    ) is
  begin
    if steps /= 0 then
      for step in 0 to steps - 1 loop
        wait until rising_edge(clk);
      end loop;
    end if;
  end procedure;

  --  #A## 
  -- F    B
  -- #    #
  --  #G##
  -- E    C
  -- #    #
  --  #D##
  procedure display_segments (
    signal segments : in t_segments
    ) is
    variable v_screen_buff : t_char_matrix(0 to 6)(1 to 6) := (others => "      ");
  begin
    -- prepare buffer
    if (segments.ca = '1') then
      v_screen_buff(0)(2 to 5) := "####";
    end if;
    if (segments.cb = '1') then
      v_screen_buff(1)(6) := '#';
      v_screen_buff(2)(6) := '#';
    end if;
    if (segments.cc = '1') then
      v_screen_buff(4)(6) := '#';
      v_screen_buff(5)(6) := '#';
    end if;
    if (segments.cd = '1') then
      v_screen_buff(6)(2 to 5) := "####";
    end if;
    if (segments.ce = '1') then
      v_screen_buff(4)(1) := '#';
      v_screen_buff(5)(1) := '#';
    end if;
    if (segments.cf = '1') then
      v_screen_buff(1)(1) := '#';
      v_screen_buff(2)(1) := '#';
    end if;
    if (segments.cg = '1') then
      v_screen_buff(3)(2 to 5) := "####";
    end if;
    -- display buffer
    for line_nmb in 0 to 6 loop
      info(v_screen_buff(line_nmb));
    end loop;
  end procedure;

end package body driver_tb_pkg;