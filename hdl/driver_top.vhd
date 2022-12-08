library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library seg7_display_driver_lib;
use seg7_display_driver_lib.driver_pkg.all;

entity driver_top is
  generic (
    g_driver_conf : t_driver_conf
  );
  port (
    -- general
    i_clk             : in  std_logic;
    i_rst_n           : in  std_logic;
    -- config
    i_digit_on_time   : in  std_logic_vector((g_driver_conf.digit_change_interval_bit_size - 1) downto 0);
    -- control
    i_value           : in  t_value((g_driver_conf.number_of_digits - 1) downto 0);
    -- driver
    o_digit_select    : out std_logic_vector((g_driver_conf.number_of_digits - 1) downto 0);
    o_segments        : out t_segments
  );
end entity driver_top;

architecture rtl of driver_top is

  constant c_safe: boolean := generics_verification(g_driver_conf);

  signal digit            : std_logic_vector((c_digit_vec_len - 1) downto 0);
  signal digit_nmb        : natural range 0 to (g_driver_conf.number_of_digits - 1);
  signal digit_active     : std_logic;
  signal digit_change_cnt : unsigned((g_driver_conf.digit_change_interval_bit_size - 1) downto 0);

begin
  -- Extract currently processed digit
  digit <= i_value(digit_nmb);

  p_digit_change : process(i_rst_n, i_clk)
  begin
    if (i_rst_n = '0') then
      digit_nmb <= 0;
      digit_change_cnt <= (others => '0');
      digit_active <= '1';
    elsif rising_edge(i_clk) then
      if (to_integer(digit_change_cnt) < g_driver_conf.digit_change_interval - 1) then
        digit_change_cnt <= digit_change_cnt + 1;
        if (digit_change_cnt < unsigned(i_digit_on_time) - 1) then
          digit_active <= '1';
        else
          digit_active <= '0';
        end if;
      else
        digit_change_cnt <= (others => '0');
        if (digit_nmb < g_driver_conf.number_of_digits - 1) then
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

  GEN_MUX: for index in 0 to g_driver_conf.number_of_digits - 1 generate
    o_digit_select(index) <= '0' when (i_rst_n = '0') else 
                             '0' when (digit_active = '0') else
                             '0' when (digit_nmb /= index) else '1';
  end generate GEN_MUX;


end architecture rtl;