library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity counter_rtl is
  generic (
    g_system_clock_in_hz : natural;
    g_preload_bit_size : natural
  );
  port (
    i_clk       : in std_logic;
    i_rst_n     : in std_logic;
    i_cnt_en    : in std_logic;
    i_cnt_rst   : in std_logic;
    i_cnt_pre   : in std_logic_vector(g_preload_bit_size - 1 downto 0);
    o_cnt_done  : out std_logic
  );
end entity counter_rtl;

architecture rtl of counter_rtl is

  constant c_system_clock_in_hz : natural := g_system_clock_in_hz;
  signal cnt_done : std_logic;
  signal counter  : unsigned(g_preload_bit_size - 1 downto 0);

begin

  o_cnt_done <= cnt_done;

  p_cnt : process (i_rst_n, i_clk)
  begin

    if (i_rst_n = '0') then
      cnt_done <= '0';
      counter <= (others => '0');
    elsif rising_edge(i_clk) then

      Null;
      -- if (i_cnt_rst = '1') then
      --   counter <= (others => '0');
      --   cnt_done <= '0';
      -- else
      --   Null;
      -- end if;
     
    end if;

  end process;

end architecture rtl;