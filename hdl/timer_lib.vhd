library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity timer_rtl is
  generic (
    g_system_clock_in_hz : natural;
    g_preload_bit_size : natural
  );
  port (
    i_clk       : in std_logic;
    i_rst_n     : in std_logic;
    i_en        : in std_logic;
    i_clear     : in std_logic;
    i_load      : in std_logic;
    i_load_val  : in std_logic_vector(g_preload_bit_size - 1 downto 0);
    o_busy      : out std_logic;
    o_done      : out std_logic
  );
end entity timer_rtl;

architecture rtl of timer_rtl is

  constant c_system_clock_in_hz : natural := g_system_clock_in_hz;
  signal done : std_logic;
  signal busy : std_logic;
  signal preload_val : std_logic_vector(g_preload_bit_size - 1 downto 0);
  signal counter  : unsigned(g_preload_bit_size - 1 downto 0);

begin

  o_done <= done;
  o_busy <= busy;

  p_cnt : process (i_rst_n, i_clk)
  begin

    if (i_rst_n = '0') then
      done <= '0';
      busy <= '0';
      preload_val <= (others => '1');
      counter <= (others => '0');
    elsif rising_edge(i_clk) then
      counter <= unsigned(preload_val);
      if (i_en = '1') or (busy = '1') then
        busy <= '1';
        done <= '0';
        if (counter /= 0) then
          counter <= counter - 1;
        else
          done <= '1';
          counter <= (others => '1'); -- TODO:  handle preload properly
        end if;
      end if;
     
    end if;

  end process;

end architecture rtl;