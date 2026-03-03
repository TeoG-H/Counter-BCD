library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity TopModule is
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           sel : in STD_LOGIC_VECTOR (1 downto 0);
           data_in : in STD_LOGIC;
           led : out STD_LOGIC_VECTOR (3 downto 0);
           D : in STD_LOGIC_VECTOR ( 3 downto 0 );
           seg : out STD_LOGIC_VECTOR(6 downto 0);
           an : out STD_LOGIC_VECTOR ( 3 downto 0)
);
end TopModule;

architecture Behavioral of TopModule is
    signal a : STD_LOGIC_VECTOR (3 downto 0) := "0000";
    signal shift_reg : STD_LOGIC_VECTOR (3 downto 0) := "0000";
    signal clk_out : STD_LOGIC := '0';
   
    begin
    an(0) <= '0';
    an(1) <= '1';
    an(2) <= '1';
    an(3) <= '1';
    
    
-- divizorul de frecventa
process(clk)
    variable  n : integer range 0 to 1000000000;
    begin
    if clk'event and clk='1' then
        if n < 100000000 then
            n := n+1;
        else
            n := 0;
        end if;
    
        if n <= 50000000 then
            clk_out <= '1';
        else
            clk_out <= '0';
        end if;
    end if;
end process;


-- cand rulez pe placuta aici clk e clk_out cel care rezulta din divizor
process(clk, reset)
    begin
        if reset = '0' then
            a <= "0000";
            shift_reg <= "0000";
        elsif rising_edge(clk) then
            case sel is
                when "01" => -- BCD counter
                    if a="1001" then
                       a <= (others => '0'); 
                    else
                        a <= a + 1;
                    end if;
                when "10" => -- shift register
                    shift_reg <= shift_reg(2 downto 0) & data_in;
                when "11" => -- paralel
                    shift_reg <= D;
                when others =>
                    null;
            end case;
        end if;
    end process;
    
    led <= shift_reg;
    
 --- pentru display-ul  cu 7 segmente
    seg(0) <= (a(2) and not(a(1)) and not(a(0))) or (not(a(3)) and not(a(2)) and not(a(1)) and a(0));
    seg(1) <= (a(2) and not(a(1)) and a(0)) or (a(2) and a(1) and not(a(0)));
    seg(2) <= (not(a(2)) and a(1) and not(a(0)));
    seg(3) <= (a(2) and not(a(1)) and not(a(0))) or (a(2) and a(1) and a(0)) or (not(a(3)) and not(a(2)) and not(a(1)) and 
    a(0));
    seg(4) <= a(0) or (a(2) and not(a(1)));
    seg(5) <= (not(a(3)) and not(a(2)) and a(0)) or (a(1) and a(0)) or (not(a(3)) and not(a(2)) and a(1));
    seg(6) <= (not(a(3)) and not(a(2)) and not(a(1))) or (a(2) and a(1) and a(0));
end Behavioral;


