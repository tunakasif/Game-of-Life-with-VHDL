library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity clock_div is
    Generic (COUNTER_BIT : INTEGER);
    Port    (selection    : in INTEGER := 0;
             clock_in     : in STD_LOGIC;
             reset        : in STD_LOGIC;
             clock_enable : in STD_LOGIC := '1';
             clock_out    : out STD_LOGIC);
end clock_div;

architecture Behavioral of clock_div is
    signal counter : UNSIGNED((COUNTER_BIT - 1) downto 0) := to_unsigned(0 , COUNTER_BIT);
begin
    process( clock_in , reset )
    begin
        if (reset = '1') then
            counter <= to_unsigned(0 , COUNTER_BIT);
        elsif rising_edge(clock_in) then
            if clock_enable = '1' then
                counter <= counter + 1;
            end if;
        end if;
    end process;
    
    clock_out <= STD_LOGIC( counter(COUNTER_BIT - selection) );
end Behavioral;
