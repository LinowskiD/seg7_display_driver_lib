library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

library vunit_lib;
context vunit_lib.vunit_context;

library seg7_display_driver_lib;

entity counter_tb is
  generic (runner_cfg : string);
end entity;

architecture tb of counter_tb is

  constant c_system_clock_in_hz : natural := 100_000_000;
  constant c_clk_period       : time := 10**3 * 1 ms / c_system_clock_in_hz;
  constant c_preload_bit_size : natural := 32;

  signal dut_clk    : std_logic := '0';
  signal dut_rst_n  : std_logic := '0';
  signal dut_done   : std_logic;
  signal dut_counter_en : std_logic := '0';
  signal dut_counter_rst : std_logic := '0';

  signal dut_counter_pre : std_logic_vector(c_preload_bit_size - 1 downto 0) := (others => '0');

begin
  main : process
  alias spy_dut_counter is << signal .counter_tb.uut.counter : unsigned >>;
  variable v_preload : std_logic_vector(c_preload_bit_size - 1 downto 0) := std_logic_vector(to_unsigned(0, c_preload_bit_size));
  begin
    test_runner_setup(runner, runner_cfg);
    while test_suite loop
      if run("test_0001_generics_passed") then
        info("* REQ_SEG_0010");
        check_equal(spy_dut_counter'length, c_preload_bit_size, "g_preload_bit_size should match passed value");
      elsif run("test_0002_values_in_reset") then
        info("* REQ_SEG_0020");
        check_equal(dut_rst_n, '0', "Reset shall be active");
        wait until rising_edge(dut_clk);
        check_equal(dut_done, '0', "done signal shall be 0 in reset");
        check_equal(spy_dut_counter, to_unsigned(0, c_preload_bit_size), "Internal counter shall be all zeroes");
      elsif run("test_0003_preload_value_loading_at_start") then
        info("* REQ_SEG_0110");
        info("* REQ_SEG_0120");
        v_preload := std_logic_vector(to_unsigned(10, c_preload_bit_size));
        info("Disabling reset and setting preload value");
        dut_rst_n <= '1';
        dut_counter_pre <= v_preload;
        wait until rising_edge(dut_clk);
        
      end if;
    end loop;
    test_runner_cleanup(runner); -- Simulation ends here
  end process;

  dut_clk <= not dut_clk after (c_clk_period/2);

  uut : entity seg7_display_driver_lib.counter_rtl
    generic map (
      g_system_clock_in_hz => c_system_clock_in_hz,
      g_preload_bit_size => c_preload_bit_size
    )
    port map (
      i_clk => dut_clk,
      i_rst_n => dut_rst_n,
      i_cnt_en => dut_counter_en,
      i_cnt_rst => dut_counter_rst,
      i_cnt_pre => dut_counter_pre,
      o_cnt_done => dut_done
    );
end architecture;