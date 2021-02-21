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

  signal counter_en, counter_rst : std_logic;
  signal counter_pre : std_logic_vector(c_preload_bit_size - 1 downto 0);

  alias spy_dut_counter is << signal .counter_tb.uut.counter : unsigned >>;

begin
  main : process
  begin
    test_runner_setup(runner, runner_cfg);
    while test_suite loop
      if run("test_0001_values_in_reset") then
        info("* REQ_SEG_0020");
        info("Testing in reset");
        check_equal(dut_rst_n, '0', "Reset shall be active");
        wait until rising_edge(dut_clk);
        report to_string(spy_dut_counter);
        check_equal(dut_done, '0', "Default value shall be used");
        -- TODO: solve spying internal counter
        -- check_equal(spy_dut_counter, to_unsigned(0, c_preload_bit_size), "Default value shall be used");
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
      i_cnt_en => counter_en,
      i_cnt_rst => counter_rst,
      i_cnt_pre => counter_pre,
      o_cnt_done => dut_done
    );
end architecture;