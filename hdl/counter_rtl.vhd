library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity counter is
  generic (
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
end entity counter;

architecture rtl of counter is

  signal done : std_logic;
  signal busy : std_logic;
  signal preload_val : std_logic_vector(g_preload_bit_size - 1 downto 0);
  signal counter  : unsigned(g_preload_bit_size - 1 downto 0);

begin

  o_done <= done;
  o_busy <= busy;

  p_cnt : process (i_rst_n, i_clk)
    variable v_preload_val : std_logic_vector(g_preload_bit_size - 1 downto 0);
  begin

    if (i_rst_n = '0') then
      done <= '0';
      busy <= '0';
      preload_val <= (others => '1');
      counter <= (others => '0');
    elsif rising_edge(i_clk) then
      if (i_load = '1') then
        v_preload_val := i_load_val;
      else
        v_preload_val := preload_val;
      end if;
      if (i_clear = '1') then
        busy <= '0';
        counter <= (others => '0');
      elsif (busy = '0') then
        if (i_en = '1') then
          busy <= '1';
          done <= '0';
          counter <= unsigned(v_preload_val);
        end if;
      else
        -- busy
        if (counter /= 0) then
          counter <= counter - 1;
        else
          done <= '1';
          busy <= '0';
        end if;
      end if;
      preload_val <= v_preload_val;
    end if;

  end process;

end architecture rtl;