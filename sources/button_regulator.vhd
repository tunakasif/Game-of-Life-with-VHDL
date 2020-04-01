library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity button_regulator is
    Port (  clock : in STD_LOGIC;
            btn   : in STD_LOGIC_VECTOR(4 downto 0);
            push  : out STD_LOGIC_VECTOR(4 downto 0));
end button_regulator;

architecture Behavioral of button_regulator is
    signal delay1, delay2, delay3 : STD_LOGIC_VECTOR(4 downto 0);
begin

    push_pulse : process(clock)
    begin
        if rising_edge(clock) then
            delay1 <= btn;
            delay2 <= delay1;
            delay3 <= delay2;
        end if;
    end process;
    
    push <= delay1 AND delay2 AND (not delay3);

end Behavioral;

