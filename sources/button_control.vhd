library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity button_control is
    Port (  clock100mhz  : in STD_LOGIC;
            button       : in STD_LOGIC_VECTOR(4 downto 0);
            selection    : in INTEGER;
            clock_button : out STD_LOGIC;
            button_out   : out STD_LOGIC_VECTOR(4 downto 0));
end button_control;

architecture Behavioral of button_control is
-- components
    component button_regulator is
        Port (  clock : in STD_LOGIC;
                btn   : in STD_LOGIC_VECTOR(4 downto 0);
                push  : out STD_LOGIC_VECTOR(4 downto 0));
    end component;
    
    component clock_div is
        Generic (COUNTER_BIT : INTEGER);
        Port    (selection    : in INTEGER := 0;
                 clock_in     : in STD_LOGIC;
                 reset        : in STD_LOGIC;
                 clock_enable : in STD_LOGIC;
                 clock_out    : out STD_LOGIC);
    end component;
    
-- signals
    signal enable : STD_LOGIC := '1';
    signal reset  : STD_LOGIC := '0';
    
    signal button_clock : STD_LOGIC;
    signal button_click : STD_LOGIC_VECTOR(4 downto 0);
    
begin 
    clock_button <= button_clock;

    P1 : clock_div
        Generic Map (COUNTER_BIT  => 26)
        Port Map    (selection    => selection,
                     clock_in     => clock100mhz,
                     reset        => reset,
                     clock_enable => enable,
                     clock_out    => button_clock);
                     

    P2 : button_regulator
        Port Map (  clock  => button_clock,
                    btn    => button,
                    push   => button_out);                                                     

end Behavioral;
