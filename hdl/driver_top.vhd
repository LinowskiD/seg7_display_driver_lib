library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library seg7_display_driver_lib;
use seg7_display_driver_lib.driver_pkg.all;

entity driver_top is
  generic (
    g_clock_frequency : natural := c_clock_frequency_default; -- in Hz
    g_number_of_digits : natural := c_number_of_digits_default;
    g_digit_change_interval : natural := c_digit_change_interval_default; -- in miliseconds
    g_digit_on_off_ratio : natural := c_digit_on_off_ratio_default -- in percent
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

  constant c_safe: boolean := generics_verification(
    g_clock_frequency,
    g_number_of_digits,
    g_digit_change_interval,
    g_digit_on_off_ratio
  );

  constant c_clock_cycles_per_digit_change : natural := (g_clock_frequency / 1_000) * g_digit_change_interval; -- TODO: 1_000 -> constant
  constant c_clock_cycles_per_digit_active : natural := (c_clock_cycles_per_digit_change * g_digit_on_off_ratio) / 100; -- TODO: 100 -> constant
  
  signal digit : t_digit;
  signal digit_nmb : natural range 0 to (g_number_of_digits - 1);
  signal digit_active : std_logic;
  signal digit_change_cnt : natural range 0 to (c_clock_cycles_per_digit_change - 1);

begin
  -- Extract currently processed digit
  digit <= i_digits(digit_nmb);

  p_digit_change : process(i_rst_n, i_clk)
  begin
    if (i_rst_n = '0') then
      digit_nmb <= 0;
      digit_change_cnt <= 0;
      digit_active <= '1';
    elsif rising_edge(i_clk) then
      if (digit_change_cnt < c_clock_cycles_per_digit_change - 1) then
        digit_change_cnt <= digit_change_cnt + 1;
        if (digit_change_cnt < c_clock_cycles_per_digit_active - 1) then
          digit_active <= '1';
        else
          digit_active <= '0';
        end if;
      else
        digit_change_cnt <= 0;
        if (digit_nmb < g_number_of_digits - 1) then
          digit_nmb <= digit_nmb + 1;
        else
          digit_nmb <= 0;
        end if;
      end if;
    end if;
  end process;
  
  -- Assign outputs

  o_segments <= (others => '0') when (i_rst_n = '0') else 
                c_digit_to_seg(to_integer(unsigned(digit)));

  GEN_MUX: for index in 0 to g_number_of_digits - 1 generate
    o_digit_select(index) <= '0' when (i_rst_n = '0') else 
                             '0' when (digit_active = '0') else
                             '0' when (digit_nmb /= index) else '1';
  end generate GEN_MUX;


end architecture rtl;