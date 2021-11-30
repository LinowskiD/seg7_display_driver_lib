library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

library vunit_lib;
context vunit_lib.vunit_context;

library seg7_display_driver_lib;
use seg7_display_driver_lib.types_pkg.all;
use seg7_display_driver_lib.driver_pkg.all;

entity driver_top_tb is
  generic (runner_cfg : string := runner_cfg_default);
end entity;

architecture tb of driver_top_tb is

  type t_boolean_array is array (natural range <>) of boolean;
  type t_char_matrix is array (natural range <>) of string;
  
  constant c_system_clock_in_hz : natural := 100_000_000;
  constant c_clk_period       : time := 10**3 * 1 ms / c_system_clock_in_hz;
  constant c_number_of_digits : natural := c_number_of_digits_default;
  constant c_digit_change_interval : natural := 1;
  constant c_digit_change_interval_ms : time := c_digit_change_interval * 1 ms;

  signal dut_clk    : std_logic := '0';
  signal dut_rst_n  : std_logic := '0';
  signal dut_digits  : t_digits((c_number_of_digits - 1) downto 0) := (others => X"0");
  signal dut_segments  : t_segments;
  signal dut_digit_select : t_digit_select((c_number_of_digits - 1) downto 0);
  signal dut_digit_select_stable : t_boolean_array((c_number_of_digits - 1) downto 0);

  constant separator : string := "-------------------------------------------------------------------";

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
      -- 6 x 7 (line x col)
    variable v_screen_buff : t_char_matrix(0 to 6)(1 to 6) := (others => "      ");
    -- variable v_line_buffer : string(1 to 6) := "      ";
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

begin

  GEN_STABLE_CHECK: for index in 0 to c_number_of_digits - 1 generate
    dut_digit_select_stable(index) <= dut_digit_select(index)'stable(c_digit_change_interval_ms);
  end generate GEN_STABLE_CHECK;
  
  main : process
    variable v_time_start : time;
  begin
    test_runner_setup(runner, runner_cfg);
    while test_suite loop
      if run("test_0001_output_ports_in_reset") then
        info(separator);
        info("TEST CASE: test_0001_output_ports_in_reset");
        info("REQ_SEG_0000");
        info(separator);
        info("Verify state in reset");
        check_equal(dut_rst_n, '0', "for reset to be enabled");
        check_equal(dut_segments.ca, '0', result("for segment.ca when in reset"));
        check_equal(dut_segments.cb, '0', result("for segment.cb when in reset"));
        check_equal(dut_segments.cc, '0', result("for segment.cc when in reset"));
        check_equal(dut_segments.cd, '0', result("for segment.cd when in reset"));
        check_equal(dut_segments.ce, '0', result("for segment.ce when in reset"));
        check_equal(dut_segments.cf, '0', result("for segment.cf when in reset"));
        check_equal(dut_segments.cg, '0', result("for segment.cg when in reset"));
        for digit_nmb in 0 to c_number_of_digits - 1 loop
          check_equal(dut_digit_select(digit_nmb), '0', result("for digit_select when in reset"));
        end loop;
        info("Verify state in after entering reset during operation");
        info("Disable reset and provide input");
        dut_rst_n <= '1';
        for digit_nmb in 0 to c_number_of_digits - 1 loop
          dut_digits(digit_nmb) <= X"F";
        end loop;
        walk(dut_clk, 1);
        check_equal(dut_digit_select(0), '1', result("for digit_select(0) after reset release"));
        info("Enable reset once again and wait for a delta cycle");
        dut_rst_n <= '0';
        wait for 1 ps;
        check_equal(dut_segments.ca, '0', result("for segment.ca when in reset"));
        check_equal(dut_segments.cb, '0', result("for segment.cb when in reset"));
        check_equal(dut_segments.cc, '0', result("for segment.cc when in reset"));
        check_equal(dut_segments.cd, '0', result("for segment.cd when in reset"));
        check_equal(dut_segments.ce, '0', result("for segment.ce when in reset"));
        check_equal(dut_segments.cf, '0', result("for segment.cf when in reset"));
        check_equal(dut_segments.cg, '0', result("for segment.cg when in reset"));
        for digit_nmb in 0 to c_number_of_digits - 1 loop
          check_equal(dut_digit_select(digit_nmb), '0', result("for digit_select when in reset"));
        end loop;
        info("===== TEST CASE FINISHED =====");
      elsif run("test_0002_digit_change") then
        info(separator);
        info("TEST CASE: test_0002_digit_change");
        info("REG_SEG_0010");
        info("REG_SEG_0020");
        info("REG_SEG_0030");
        info("REG_SEG_0050");
        info("REG_SEG_0060");
        info("REG_SEG_0070");
        info(separator);
        info("Disable reset");
        dut_rst_n <= '1';
        walk(dut_clk, 1);
        -- REG_SEG_0060
        check_equal(dut_digit_select(0), '1', result("for digit_select(0) after start"));
        for digit_nmb in 1 to c_number_of_digits - 1 loop
          check_equal(dut_digit_select(digit_nmb), '0', result("for digit_select(" & integer'image(digit_nmb) & ") when in reset"));
        end loop;
        info("Wait for digit change");
        wait until dut_digit_select(1) = '1' for c_digit_change_interval_ms;
        v_time_start := now;
        check_equal(dut_digit_select(0), '0', result("for first change of digit_select(0)"));
        check_equal(dut_digit_select(1), '1', result("for first change of digit_select(1)"));
        for digit_nmb in 2 to c_number_of_digits - 1 loop
          check_equal(dut_digit_select(digit_nmb), '0', result("for digit_select(" & integer'image(digit_nmb) & ") when in operation"));
        end loop;
        -- REQ_SEG_0010
        -- REQ_SEG_0020
        -- REQ_SEG_0030
        -- REG_SEG_0050
        -- REG_SEG_0070
        for step_nmb in 2 to 10 loop
          info("Veifying change no. " & integer'image((step_nmb)));
          wait for 1 ps;
          wait until dut_digit_select(step_nmb mod c_number_of_digits) = '1' for c_digit_change_interval_ms;
          check_equal(now - v_time_start, c_digit_change_interval_ms, "duration check");
          v_time_start := now;
          for digit_nmb in 0 to c_number_of_digits - 1 loop
            if digit_nmb = step_nmb mod 4 then
              check_equal(dut_digit_select(digit_nmb), '1', result("for digit_select(" & integer'image(digit_nmb) & ") when in operation"));
            else
              check_equal(dut_digit_select(digit_nmb), '0', result("for digit_select(" & integer'image(digit_nmb) & ") when in operation"));
            end if;
            check_equal(dut_digit_select_stable(digit_nmb), true, result("for stability stability check on digit_select(" & integer'image(digit_nmb)) & ")");
          end loop;
        end loop;
        info("===== TEST CASE FINISHED =====");
      elsif run("test_0003_segment_change") then
        info(separator);
        info("TEST CASE: test_0003_segment_change");
        info("TBD");
        info(separator);
        info("Disable reset");
        dut_rst_n <= '1';
        walk(dut_clk, 1);
        info("update BCD");
        dut_digits <= (X"0", X"1", X"2", X"3");
        walk(dut_clk, 1);

        info("Wait for digit change");
        wait until dut_digit_select(1) = '1' for c_digit_change_interval_ms;
        v_time_start := now;
        check_equal(dut_digit_select(0), '0', result("for first change of digit_select(0)"));
        check_equal(dut_digit_select(1), '1', result("for first change of digit_select(1)"));
        for digit_nmb in 2 to c_number_of_digits - 1 loop
          check_equal(dut_digit_select(digit_nmb), '0', result("for digit_select(" & integer'image(digit_nmb) & ") when in operation"));
        end loop;
        -- REQ_SEG_0010
        -- REQ_SEG_0020
        -- REQ_SEG_0030
        -- REG_SEG_0050
        -- REG_SEG_0070
        for step_nmb in 2 to 10 loop
          info("Veifying change no. " & integer'image((step_nmb)));
          wait for 1 ps;
          wait until dut_digit_select(step_nmb mod c_number_of_digits) = '1' for c_digit_change_interval_ms;
          check_equal(now - v_time_start, c_digit_change_interval_ms, "duration check");
          v_time_start := now;
          display_segments(dut_segments);
          for digit_nmb in 0 to c_number_of_digits - 1 loop
            if digit_nmb = step_nmb mod 4 then
              check_equal(dut_digit_select(digit_nmb), '1', result("for digit_select(" & integer'image(digit_nmb) & ") when in operation"));
            else
              check_equal(dut_digit_select(digit_nmb), '0', result("for digit_select(" & integer'image(digit_nmb) & ") when in operation"));
            end if;
            check_equal(dut_digit_select_stable(digit_nmb), true, result("for stability stability check on digit_select(" & integer'image(digit_nmb)) & ")");
          end loop;
        end loop;
        info("===== TEST CASE FINISHED =====");
        -- check_equal(o_digit_select, '0', "TBD");
        -- info("* REQ_SEG_0101");
        -- check_equal(spy_dut_counter'length, c_preload_bit_size, "g_preload_bit_size should match passed value");
    --   elsif run("test_0002_values_in_reset") then
    --     info("* REQ_SEG_0020");
    --     check_equal(dut_rst_n, '0', "Reset shall be active");
    --     wait until rising_edge(dut_clk);
    --     check_equal(dut_done, '0', "done signal shall be 0 in reset");
    --     check_equal(dut_busy, '0', "busy signal shall be 0 in reset");
    --     -- check_equal(spy_dut_counter, to_unsigned(0, c_preload_bit_size), "Internal counter shall be all zeroes");
    --   elsif run("test_0003_busy_when_started") then
    --     info("* REQ_SEG_0110");
    --     info("* REQ_SEG_0131");
    --     info("* REQ_SEG_0140");
    --     info("Disabling reset");
    --     dut_rst_n <= '1';
    --     wait until rising_edge(dut_clk);
    --     info("Default state after reset");
    --     check_equal(dut_done, '0', "done signal shall be 0 after reset");
    --     check_equal(dut_busy, '0', "busy signal shall be 0 after reset");
    --     info("Enabling counter");
    --     dut_en <= '1';
    --     -- check_equal(spy_dut_counter, to_unsigned(2**c_preload_bit_size, c_preload_bit_size), "Internal counter shall be all zeroes");
    --     wait until rising_edge(dut_clk);
    --     wait until rising_edge(dut_clk);
    --     check_equal(dut_busy, '1', "busy signal shall be set to 1 after counter enabling");
    --   elsif run("test_0004_count_from_10") then
    --     info("* REQ_SEG_0130");
    --     info("* REQ_SEG_0140");
    --     info("* REQ_SEG_0150");
    --     info("Disabling reset");
    --     dut_rst_n <= '1';
    --     wait until rising_edge(dut_clk);
    --     info("Preloading counter");
    --     v_preload_int := 10;
    --     v_preload := std_logic_vector(to_unsigned(v_preload_int, c_preload_bit_size));
    --     dut_load_val <= v_preload;
    --     dut_load <= '1';
    --     wait until rising_edge(dut_clk);
    --     dut_load <= '0';
    --     wait until rising_edge(dut_clk);
    --     -- check_equal(spy_preload_val, std_logic_vector(to_unsigned(v_preload_int, c_preload_bit_size)), "Internal preload value shall be be equal to preloaded value");
    --     info("Enabling counter");
    --     dut_en <= '1';
    --     wait until rising_edge(dut_clk);
    --     info("Since it is already enable, drive this signal low");
    --     dut_en <= '0';
    --     wait until rising_edge(dut_clk);
    --     check_equal(dut_busy, '1', "busy signal shall be 1 exactly 1 clock cycle after counter has been enabled.");
    --     wait until rising_edge(dut_done) for (v_preload_int + 1) * c_clk_period;
    --     check_equal(dut_done, '1', "done signal shall be 1 when counter has finished.");
    --     check_equal(dut_busy, '0', "busy signal shall be 0 when counter has finished.");
    --   elsif run("test_0005_continouos_operation") then
    --     info("* REQ_SEG_0151");
    --     info("Disabling reset");
    --     dut_rst_n <= '1';
    --     wait until rising_edge(dut_clk);
    --     info("Preloading counter and enabling counter");
    --     v_duration := 5;
    --     v_preload_int := v_duration - 1;
    --     v_preload := std_logic_vector(to_unsigned(v_preload_int, c_preload_bit_size));
    --     dut_load_val <= v_preload;
    --     dut_load <= '1';
    --     dut_en <= '1';
    --     wait until rising_edge(dut_clk);
    --     dut_load <= '0';
    --     wait until rising_edge(dut_clk);
    --     -- check_equal(spy_preload_val, std_logic_vector(to_unsigned(v_preload_int, c_preload_bit_size)), "Internal preload value shall be be equal to preloaded value");
    --     check_equal(dut_busy, '1', "busy signal shall be 1 exactly 1 clock cycle after counter has been enabled.");
    --     wait until rising_edge(dut_done) for (v_preload_int + 1) * c_clk_period;
    --     check_equal(dut_done, '1', "done signal shall be 1 when counter has finished.");
    --     check_equal(dut_busy, '0', "busy signal shall be 0 when counter has finished.");
    --     info("Waiting for a new cycle to start automatically");
    --     wait until rising_edge(dut_busy) for 2 * c_clk_period;
    --     check_equal(dut_done, '0', "done signal shall be 0 when counter has started.");
    --     check_equal(dut_busy, '1', "busy signal shall be 1 when counter has started.");
    --     info("Wait for this cycle to end");
    --     wait until rising_edge(dut_done) for (v_duration + 1) * c_clk_period;
    --     check_equal(dut_done, '1', "done signal shall be 1 when counter has finished.");
    --   elsif run("test_0006_clear_and_enable_again") then
    --     info("* REQ_SEG_0121");
    --     info("Disabling reset");
    --     dut_rst_n <= '1';
    --     wait until rising_edge(dut_clk);
    --     info("Preloading counter and enabling counter");
    --     v_duration := 5;
    --     dut_load_val <= std_logic_vector(to_unsigned(v_duration - 1, c_preload_bit_size));
    --     dut_load <= '1';
    --     dut_en <= '1';
    --     wait until rising_edge(dut_clk);
    --     dut_load <= '0';
    --     wait until rising_edge(dut_clk);
    --     check_equal(dut_busy, '1', "busy signal shall be 1 exactly 1 clock cycle after counter has been enabled.");
    --     info("Apply 'clear' signal to stop counter");
    --     dut_clear <= '1';
    --     wait until rising_edge(dut_clk);
    --     dut_clear <= '0';
    --     wait until rising_edge(dut_clk);
    --     check_equal(dut_busy, '0', "busy signal shall be 0 when counter has been cleared");
      end if;
    end loop;
    test_runner_cleanup(runner); -- Simulation ends here
  end process;

  dut_clk <= not dut_clk after (c_clk_period/2);

  uut : entity seg7_display_driver_lib.driver_top(rtl)
    generic map (
      g_clock_frequency => c_system_clock_in_hz,
      g_number_of_digits => c_number_of_digits,
      g_digit_change_interval => c_digit_change_interval
    )
    port map (
      i_clk => dut_clk,
      i_rst_n => dut_rst_n,
      i_digits => dut_digits,
      o_segments => dut_segments,
      o_digit_select => dut_digit_select
    );
end architecture;
