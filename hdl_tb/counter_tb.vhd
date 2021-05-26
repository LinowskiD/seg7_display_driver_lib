library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

library vunit_lib;
context vunit_lib.vunit_context;

library seg7_display_driver_lib;

entity counter_tb is
  generic (runner_cfg : string := runner_cfg_default);
end entity;

architecture tb of counter_tb is

  constant c_system_clock_in_hz : natural := 100_000_000;
  constant c_clk_period       : time := 10**3 * 1 ms / c_system_clock_in_hz;
  constant c_preload_bit_size : natural := 32;

  signal dut_clk    : std_logic := '0';
  signal dut_rst_n  : std_logic := '0';
  signal dut_en     : std_logic := '0';
  signal dut_clear  : std_logic := '0';
  signal dut_load   : std_logic := '0';
  signal dut_done   : std_logic;
  signal dut_busy   : std_logic;

  signal dut_load_val : std_logic_vector(c_preload_bit_size - 1 downto 0) := (others => '0');

begin
  
  main : process
  -- alias spy_dut_counter is << signal .counter_tb.uut.counter : unsigned >>;
  -- alias spy_preload_val is << signal .counter_tb.uut.preload_val : std_logic_vector >>;
  variable v_duration : integer;
  variable v_preload_int : integer;
  variable v_preload : std_logic_vector(c_preload_bit_size - 1 downto 0) := std_logic_vector(to_unsigned(0, c_preload_bit_size));
  variable v_start_time : time;
  begin
    test_runner_setup(runner, runner_cfg);
    while test_suite loop
      if run("test_0001_generics_passed") then
        info("* REQ_SEG_0101");
        -- check_equal(spy_dut_counter'length, c_preload_bit_size, "g_preload_bit_size should match passed value");
      elsif run("test_0002_values_in_reset") then
        info("* REQ_SEG_0020");
        check_equal(dut_rst_n, '0', "Reset shall be active");
        wait until rising_edge(dut_clk);
        check_equal(dut_done, '0', "done signal shall be 0 in reset");
        check_equal(dut_busy, '0', "busy signal shall be 0 in reset");
        -- check_equal(spy_dut_counter, to_unsigned(0, c_preload_bit_size), "Internal counter shall be all zeroes");
      elsif run("test_0003_busy_when_started") then
        info("* REQ_SEG_0110");
        info("* REQ_SEG_0131");
        info("* REQ_SEG_0140");
        info("Disabling reset");
        dut_rst_n <= '1';
        wait until rising_edge(dut_clk);
        info("Default state after reset");
        check_equal(dut_done, '0', "done signal shall be 0 after reset");
        check_equal(dut_busy, '0', "busy signal shall be 0 after reset");
        info("Enabling counter");
        dut_en <= '1';
        -- check_equal(spy_dut_counter, to_unsigned(2**c_preload_bit_size, c_preload_bit_size), "Internal counter shall be all zeroes");
        wait until rising_edge(dut_clk);
        wait until rising_edge(dut_clk);
        check_equal(dut_busy, '1', "busy signal shall be set to 1 after counter enabling");
      elsif run("test_0004_count_from_10") then
        info("* REQ_SEG_0130");
        info("* REQ_SEG_0140");
        info("* REQ_SEG_0150");
        info("Disabling reset");
        dut_rst_n <= '1';
        wait until rising_edge(dut_clk);
        info("Preloading counter");
        v_preload_int := 10;
        v_preload := std_logic_vector(to_unsigned(v_preload_int, c_preload_bit_size));
        dut_load_val <= v_preload;
        dut_load <= '1';
        wait until rising_edge(dut_clk);
        dut_load <= '0';
        wait until rising_edge(dut_clk);
        -- check_equal(spy_preload_val, std_logic_vector(to_unsigned(v_preload_int, c_preload_bit_size)), "Internal preload value shall be be equal to preloaded value");
        info("Enabling counter");
        dut_en <= '1';
        wait until rising_edge(dut_clk);
        info("Since it is already enable, drive this signal low");
        dut_en <= '0';
        wait until rising_edge(dut_clk);
        check_equal(dut_busy, '1', "busy signal shall be 1 exactly 1 clock cycle after counter has been enabled.");
        wait until rising_edge(dut_done) for (v_preload_int + 1) * c_clk_period;
        check_equal(dut_done, '1', "done signal shall be 1 when counter has finished.");
        check_equal(dut_busy, '0', "busy signal shall be 0 when counter has finished.");
      elsif run("test_0005_continouos_operation") then
        info("* REQ_SEG_0151");
        info("Disabling reset");
        dut_rst_n <= '1';
        wait until rising_edge(dut_clk);
        info("Preloading counter and enabling counter");
        v_duration := 5;
        v_preload_int := v_duration - 1;
        v_preload := std_logic_vector(to_unsigned(v_preload_int, c_preload_bit_size));
        dut_load_val <= v_preload;
        dut_load <= '1';
        dut_en <= '1';
        wait until rising_edge(dut_clk);
        dut_load <= '0';
        wait until rising_edge(dut_clk);
        -- check_equal(spy_preload_val, std_logic_vector(to_unsigned(v_preload_int, c_preload_bit_size)), "Internal preload value shall be be equal to preloaded value");
        check_equal(dut_busy, '1', "busy signal shall be 1 exactly 1 clock cycle after counter has been enabled.");
        wait until rising_edge(dut_done) for (v_preload_int + 1) * c_clk_period;
        check_equal(dut_done, '1', "done signal shall be 1 when counter has finished.");
        check_equal(dut_busy, '0', "busy signal shall be 0 when counter has finished.");
        info("Waiting for a new cycle to start automatically");
        wait until rising_edge(dut_busy) for 2 * c_clk_period;
        check_equal(dut_done, '0', "done signal shall be 0 when counter has started.");
        check_equal(dut_busy, '1', "busy signal shall be 1 when counter has started.");
        info("Wait for this cycle to end");
        wait until rising_edge(dut_done) for (v_duration + 1) * c_clk_period;
        check_equal(dut_done, '1', "done signal shall be 1 when counter has finished.");
      elsif run("test_0006_clear_and_enable_again") then
        info("* REQ_SEG_0121");
        info("Disabling reset");
        dut_rst_n <= '1';
        wait until rising_edge(dut_clk);
        info("Preloading counter and enabling counter");
        v_duration := 5;
        dut_load_val <= std_logic_vector(to_unsigned(v_duration - 1, c_preload_bit_size));
        dut_load <= '1';
        dut_en <= '1';
        wait until rising_edge(dut_clk);
        dut_load <= '0';
        wait until rising_edge(dut_clk);
        check_equal(dut_busy, '1', "busy signal shall be 1 exactly 1 clock cycle after counter has been enabled.");
        info("Apply 'clear' signal to stop counter");
        dut_clear <= '1';
        wait until rising_edge(dut_clk);
        dut_clear <= '0';
        wait until rising_edge(dut_clk);
        check_equal(dut_busy, '0', "busy signal shall be 0 when counter has been cleared");
      end if;
    end loop;
    test_runner_cleanup(runner); -- Simulation ends here
  end process;

  dut_clk <= not dut_clk after (c_clk_period/2);

  uut : entity seg7_display_driver_lib.counter(rtl)
    generic map (
      g_preload_bit_size => c_preload_bit_size
    )
    port map (
      i_clk       => dut_clk,
      i_rst_n     => dut_rst_n,
      i_en        => dut_en,
      i_clear     => dut_clear,
      i_load      => dut_load,
      i_load_val  => dut_load_val,
      o_busy      => dut_busy,
      o_done      => dut_done
    );
end architecture;
