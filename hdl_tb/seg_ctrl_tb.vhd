library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

library vunit_lib;
context vunit_lib.vunit_context;

library seg7_display_driver_lib;
use seg7_display_driver_lib.types_pkg.all;
use seg7_display_driver_lib.defines_pkg.all;

entity seg_ctrl_tb is
  generic (runner_cfg : string := runner_cfg_default);
end entity;

architecture tb of seg_ctrl_tb is

  constant c_system_clock_in_hz : natural := 100_000_000;
  constant c_clk_period       : time := 10**3 * 1 ms / c_system_clock_in_hz;

  signal dut_clk    : std_logic := '0';
  signal dut_digit    : t_digit;
  signal dut_segments    : t_segments;

begin
  
  main : process
  begin
    test_runner_setup(runner, runner_cfg);
    while test_suite loop
      if run("TBD") then
        info("* REQ_SEG_0101");
        wait until rising_edge(dut_clk);
        check_equal(TRUE, TRUE, "TRUE");
        -- check_equal(spy_dut_counter'length, c_preload_bit_size, "g_preload_bit_size should match passed value");
      elsif run("TBD2") then
        info("* REQ_SEG_0020");
        -- check_equal(dut_rst_n, '0', "Reset shall be active");
        wait until rising_edge(dut_clk);
        -- check_equal(dut_done, '0', "done signal shall be 0 in reset");
        -- check_equal(dut_busy, '0', "busy signal shall be 0 in reset");
        -- check_equal(spy_dut_counter, to_unsigned(0, c_preload_bit_size), "Internal counter shall be all zeroes");
      end if;
    end loop;
    test_runner_cleanup(runner); -- Simulation ends here
  end process;

  dut_clk <= not dut_clk after (c_clk_period/2);

  uut : entity seg7_display_driver_lib.seg_ctrl
    port map (
      i_digit     => dut_digit,
      o_segments  => dut_segments
    );
end architecture;