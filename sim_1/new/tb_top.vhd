library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity tb_top is
end tb_top;

architecture Behavioral of tb_top is
    signal clk      : STD_LOGIC := '0';
    signal reset    : STD_LOGIC := '1';
    signal sel      : STD_LOGIC_VECTOR(1 downto 0) := "00";
    signal data_in  : STD_LOGIC := '0';
    signal led      : STD_LOGIC_VECTOR(3 downto 0);
    signal D        : STD_LOGIC_VECTOR(3 downto 0) := "0000";
    signal seg      : STD_LOGIC_VECTOR(6 downto 0);
    signal an       : STD_LOGIC_VECTOR(3 downto 0);


begin
 -- instantiere modul testat
    uut: entity work.TopModule
        port map(
            clk => clk,
            reset => reset,
            sel => sel,
            data_in => data_in,
            led => led,
            D => D,
            seg => seg,
            an => an);

    -- clock 10 ns
    clk_process : process
    begin
        while true loop
            clk <= '0';
            wait for 5 ns;
            clk <= '1';
            wait for 5 ns;
        end loop;
    end process;

stim_proc: process
    begin

        -- RESET
        reset <= '0';
        wait for 20 ns;
        reset <= '1';
        wait for 20 ns;
--counter
        sel <= "01";
        wait for 200 ns;

--paralel
        sel <= "11";
        D <= "0100";
        wait for 20 ns;

--shift
        sel <= "10";
        data_in <= '1';
        wait for 100 ns;

        wait;
end process;


end Behavioral;
