library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use WORK.ENVIRONMENT_PACKAGE.ALL;

entity top_module is
    Port (  clk100mhz           : in STD_LOGIC;
            initial_condition   : in STD_LOGIC_VECTOR(2 downto 0);
            enable              : in STD_LOGIC;
            time_selection      : in STD_LOGIC_VECTOR(1 downto 0);
            size_selection      : in STD_LOGIC_VECTOR(1 downto 0);
            button              : in STD_LOGIC_VECTOR(4 downto 0);
            
            leds                : out STD_LOGIC_VECTOR(7 downto 0);
            horizontal_sync     : out STD_LOGIC;
            vertical_sync       : out STD_LOGIC;
            vgaRed              : out STD_LOGIC_VECTOR(3 downto 0);
            vgaGreen            : out STD_LOGIC_VECTOR(3 downto 0);
            vgaBlue             : out STD_LOGIC_VECTOR(3 downto 0));
end top_module;

architecture Behavioral of top_module is
    -- components
    component environment is
        Generic (FIELD_SIZE : INTEGER := 4);
        Port    (clock             : in STD_LOGIC;
                 button_clock      : in STD_LOGIC;
                 clock_enable      : in STD_LOGIC;
                 button            : in STD_LOGIC_VECTOR(4 downto 0);
                 initial_condition : in STD_LOGIC_VECTOR(2 downto 0);
                 
                 cursor_x          : out INTEGER;
                 cursor_y          : out INTEGER;
                 
                 field_out         : out FIELD(0 to (FIELD_SIZE - 1), 0 to (FIELD_SIZE - 1)));
    end component;
    
    component vga_controller is
        Generic (FIELD_SIZE : INTEGER := 4);
        Port (  clock100mhz     : in STD_LOGIC;
                clock_enable    : in STD_LOGIC;
                cursor_x        : in INTEGER;
                cursor_y        : in INTEGER;
                myField         : in FIELD(0 to FIELD_SIZE - 1, 0 to FIELD_SIZE - 1);
                size_selection  : in STD_LOGIC_VECTOR(1 downto 0);
                
                horizontal_sync : out STD_LOGIC;
                vertical_sync   : out STD_LOGIC;
                red             : out STD_LOGIC_VECTOR(3 downto 0);
                green           : out STD_LOGIC_VECTOR(3 downto 0);
                blue            : out STD_LOGIC_VECTOR(3 downto 0));
    end component;
    
    component clock_div is
        Generic (COUNTER_BIT : INTEGER);
        Port    (selection    : in INTEGER;
                 clock_in     : in STD_LOGIC;
                 reset        : in STD_LOGIC;
                 clock_enable : in STD_LOGIC := '1';
                 clock_out    : out STD_LOGIC);
    end component;
    
    component button_control is
        Port (  clock100mhz  : in STD_LOGIC;
                button       : in STD_LOGIC_VECTOR(4 downto 0);
                selection    : in INTEGER;
                clock_button : out STD_LOGIC;
                button_out   : out STD_LOGIC_VECTOR(4 downto 0));
    end component;
    -- constants
    constant SIZE         : INTEGER := 20;
    constant clock_bit    : INTEGER := 27; 
    
    -- signals 
    signal clock_reset    : STD_LOGIC := '0';
    signal clock_out      : STD_LOGIC;
    signal myField        : FIELD(0 to (SIZE - 1), 0 to (SIZE - 1));
    signal clock_division : INTEGER;
    
    signal button_clock   : STD_LOGIC;
    signal button_out     : STD_LOGIC_VECTOR(4 downto 0);
    
    signal cursor_control : STD_LOGIC_VECTOR(4 downto 0);
    signal cursor_x       :INTEGER;
    signal cursor_y       :INTEGER;

begin  
    -- identify which switches are on-------------
    leds(0) <= enable;
    leds(3 downto 1) <= initial_condition;
    leds(5 downto 4) <= size_selection;
    leds(7 downto 6) <= time_selection;
    ----------------------------------------------
    
    -- extra aid for managing modular design
    clock_division <= 2 * to_integer(unsigned(time_selection));
    cursor_control  <= button_out(4 downto 1) & button(0);
    
    P0 : clock_div
        Generic Map ( COUNTER_BIT  => 27 )
        Port Map    ( selection    => clock_division,
                      clock_in     => clk100mhz,
                      reset        => clock_reset, 
                      clock_out    => clock_out);  
                      
    P1 : button_control
        Port Map    (clock100mhz   => clk100mhz,
                     button        => button,
                     selection     => clock_division,
                     clock_button  => button_clock,
                     button_out    => button_out);          
                    
    P2 : environment 
    Generic Map (FIELD_SIZE => SIZE)
    Port Map    (clock             => clock_out,
                 button_clock      => button_clock,
                 clock_enable      => enable,
                 button            => cursor_control,
                 initial_condition => initial_condition,
                 cursor_x          => cursor_x,
                 cursor_y          => cursor_y,
                 field_out         => myField);     
                             
    P3 : vga_controller
        Generic Map (FIELD_SIZE => SIZE)
        Port Map (  clock100mhz     => clk100mhz,
                    clock_enable    => enable,
                    cursor_x        => cursor_x,
                    cursor_y        => cursor_y,
                    size_selection  => size_selection,
                    myField         => myField,
                    horizontal_sync => horizontal_sync,
                    vertical_sync   => vertical_sync,
                    red             => vgaRed,
                    green           => vgaGreen,
                    blue            => vgaBlue);
end Behavioral;
