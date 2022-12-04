library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

library vunit_lib;
context vunit_lib.vunit_context;

library seg7_display_driver_lib;
use seg7_display_driver_lib.driver_pkg.all;

library seg7_display_driver_tb_lib;
use seg7_display_driver_tb_lib.driver_tb_pkg.all;

-- TESTS:
-- * signals in reset
-- * digit change
-- * segment update
-- * digit ON time update

entity driver_top_tb is
  generic (runner_cfg : string := runner_cfg_default);
end entity;

architecture tb of driver_top_tb is

  signal dut_clk                  : std_logic := '0';
  signal dut_rst_n                : std_logic := '0';
  signal dut_digit_on_time        : std_logic_vector((c_digit_change_interval_bit_size - 1) downto 0) := std_logic_vector(to_unsigned(c_digit_change_interval, c_digit_change_interval_bit_size));
  signal dut_value                : t_value((c_number_of_digits - 1) downto 0) := (others => X"0");
  signal dut_digit_select         : std_logic_vector((c_number_of_digits - 1) downto 0);
  signal dut_digit_select_stable  : t_boolean_array((c_number_of_digits - 1) downto 0);
  signal dut_segments             : t_segments;

begin

  dut_clk <= not dut_clk after (c_clk_period/2);

  uut : entity seg7_display_driver_lib.driver_top(rtl)
    generic map (
      g_number_of_digits                => c_number_of_digits,
      g_digit_change_interval_bit_size  => c_digit_change_interval_bit_size,
      g_digit_change_interval           => c_digit_change_interval
    )
    port map (
      i_clk           => dut_clk,
      i_rst_n         => dut_rst_n,
      i_digit_on_time => dut_digit_on_time,
      i_value         => dut_value,
      o_digit_select  => dut_digit_select,
      o_segments      => dut_segments
    );
  
  GEN_STABLE_CHECK: for index in 0 to c_number_of_digits - 1 generate
    dut_digit_select_stable(index) <= dut_digit_select(index)'stable(c_digit_change_interval_time);
  end generate GEN_STABLE_CHECK;
  
  main : process
    variable v_time_start : time;
  begin
    test_runner_setup(runner, runner_cfg);
    while test_suite loop
      if run("test_0001_output_ports_in_reset") then
        info(separator);
        info("===== TEST CASE STARTED =====");
        info("TEST CASE: test_0001_output_ports_in_reset");
        info(separator);
        info("Verify state in reset");
        check_equal(dut_rst_n, '0', "for reset to be enabled");
        info("* dut_segments");
        check_equal(dut_segments.ca, '0', result("for segment.ca when in reset"));
        check_equal(dut_segments.cb, '0', result("for segment.cb when in reset"));
        check_equal(dut_segments.cc, '0', result("for segment.cc when in reset"));
        check_equal(dut_segments.cd, '0', result("for segment.cd when in reset"));
        check_equal(dut_segments.ce, '0', result("for segment.ce when in reset"));
        check_equal(dut_segments.cf, '0', result("for segment.cf when in reset"));
        check_equal(dut_segments.cg, '0', result("for segment.cg when in reset"));
        info("* dut_digit_select");
        for digit_nmb in 0 to c_number_of_digits - 1 loop
          check_equal(dut_digit_select(digit_nmb), '0', result("for digit_select when in reset"));
        end loop;
        info("Verify state after re-entering reset");
        info("Release reset and provide input");
        dut_rst_n <= '1';
        for digit_nmb in 0 to c_number_of_digits - 1 loop
          dut_value(digit_nmb) <= X"F";
        end loop;
        walk(dut_clk, 1);
        info("* dut_digit_select");
        check_equal(dut_digit_select(0), '1', result("for digit_select(0) after reset release"));
        info("Enable reset once again and wait for a delta cycle");
        dut_rst_n <= '0';
        wait for 1 ps;
        info("* dut_segments");
        check_equal(dut_segments.ca, '0', result("for segment.ca when in reset"));
        check_equal(dut_segments.cb, '0', result("for segment.cb when in reset"));
        check_equal(dut_segments.cc, '0', result("for segment.cc when in reset"));
        check_equal(dut_segments.cd, '0', result("for segment.cd when in reset"));
        check_equal(dut_segments.ce, '0', result("for segment.ce when in reset"));
        check_equal(dut_segments.cf, '0', result("for segment.cf when in reset"));
        check_equal(dut_segments.cg, '0', result("for segment.cg when in reset"));
        info("* dut_digit_select");
        for digit_nmb in 0 to c_number_of_digits - 1 loop
          check_equal(dut_digit_select(digit_nmb), '0', result("for digit_select when in reset"));
        end loop;
        info("===== TEST CASE FINISHED =====");
      elsif run("test_0002_digit_change") then
        info(separator);
        info("===== TEST CASE STARTED =====");
        info("TEST CASE: test_0002_digit_change");
        info(separator);
        info("Release reset and provide input");
        dut_rst_n <= '1';
        for digit_nmb in 0 to c_number_of_digits - 1 loop
          dut_value(digit_nmb) <= X"F";
        end loop;
        walk(dut_clk, 1);
        info("* dut_digit_select");
        for digit_nmb in 0 to c_number_of_digits - 1 loop
          if digit_nmb = 0 then
            check_equal(dut_digit_select(digit_nmb), '1', result("for digit_select(" & integer'image(digit_nmb) & ") after reset release"));
          else
            check_equal(dut_digit_select(digit_nmb), '0', result("for digit_select(" & integer'image(digit_nmb) & ") after reset release"));
          end if;
        end loop;
        info("Wait for 1st digit change - using default ON/OFF ratio (100% ON)");
        wait until dut_digit_select(1) = '1' for c_digit_change_interval_time;
        for digit_nmb in 0 to c_number_of_digits - 1 loop
          if digit_nmb = 1 then
            check_equal(dut_digit_select(digit_nmb), '1', result("for digit_select(" & integer'image(digit_nmb) & ") after reset release"));
          else
            check_equal(dut_digit_select(digit_nmb), '0', result("for digit_select(" & integer'image(digit_nmb) & ") after reset release"));
          end if;
        end loop;
        info("Wait for next changes and verify pin state");
        v_time_start := now;
        for step_nmb in 2 to 10 loop
          info("Verifying change no. " & integer'image((step_nmb)));
          wait for 1 ps;
          wait until dut_digit_select(step_nmb mod c_number_of_digits) = '1' for c_digit_change_interval_time;
          check_equal(now - v_time_start, c_digit_change_interval_time, result("for digit_select(" & integer'image(step_nmb mod c_number_of_digits) & ")"));
          v_time_start := now;
          for digit_nmb in 0 to c_number_of_digits - 1 loop
            if digit_nmb = (step_nmb mod c_number_of_digits) then
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
        info("===== TEST CASE STARTED =====");
        info("TEST CASE: test_0003_segment_change");
        info(separator);
        info("Verify if segments light in valid shapes");
        info(separator);
        info("Release reset and provide input");
        dut_rst_n <= '1';
        dut_value <= (X"0", X"1", X"2", X"3");
        walk(dut_clk, 1);
        info("Wait for digit change");
        wait until dut_digit_select(1) = '1' for c_digit_change_interval_time;
        v_time_start := now;
        check_equal(dut_digit_select(0), '0', result("for first change of digit_select(0)"));
        check_equal(dut_digit_select(1), '1', result("for first change of digit_select(1)"));
        for digit_nmb in 2 to c_number_of_digits - 1 loop
          check_equal(dut_digit_select(digit_nmb), '0', result("for digit_select(" & integer'image(digit_nmb) & ") when in operation"));
        end loop;
        for step_nmb in 2 to 10 loop
          info("Veifying change no. " & integer'image((step_nmb)));
          wait for 1 ps;
          wait until dut_digit_select(step_nmb mod c_number_of_digits) = '1' for c_digit_change_interval_time;
          check_equal(now - v_time_start, c_digit_change_interval_time, "duration check");
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
      end if;
    end loop;
    test_runner_cleanup(runner); -- Simulation ends here
  end process;

end architecture;
