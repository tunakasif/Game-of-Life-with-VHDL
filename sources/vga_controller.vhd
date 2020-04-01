library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use WORK.ENVIRONMENT_PACKAGE.ALL;

entity vga_controller is
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
end vga_controller;

architecture Behavioral of vga_controller is
-- components ----------------------------
component clock_div
    Generic (COUNTER_BIT : INTEGER);
    Port    (selection    : in INTEGER := 0;
             clock_in     : in STD_LOGIC;
             reset        : in STD_LOGIC;
             clock_enable : in STD_LOGIC;
             clock_out    : out STD_LOGIC);
end component;

component vga_regulator
 	Generic(
            HORIZONTAL_PIXELS     : INTEGER   := 640;
            HORIZONTAL_PULSE      : INTEGER   := 96;
            HORIZONTAL_FRONTPORCH : INTEGER   := 16;
            HORIZONTAL_BACKPORCH  : INTEGER   := 48;
            HORIZONTAL_POLARITY   : STD_LOGIC := '0';
          
            VERTICAL_PIXELS       : INTEGER   := 480;
            VERTICAL_PULSE        : INTEGER   := 2;
            VERTICAL_FRONTPORCH   : INTEGER   := 10;
            VERTICAL_BACKPORCH    : INTEGER   := 33;
            VERTICAL_POLARITY     : STD_LOGIC := '0');
    Port (  clock, clear          : in STD_LOGIC;
            horizontal_sync_pulse : out STD_LOGIC;
            vertical_sync_pulse   : out STD_LOGIC;
            horizontal_out        : out INTEGER;
            vertical_out          : out INTEGER;
            display_enable        : out STD_LOGIC);
end component;

component vga_display
    Generic (FIELD_SIZE : INTEGER := 4);
    Port (  display_enable      : in STD_LOGIC;
            clock_enable        : in STD_LOGIC;
            
            cursor_x            : in INTEGER;
            cursor_y            : in INTEGER;
            
            column              : in INTEGER;
            row                 : in INTEGER;
            thickness_selection : in STD_LOGIC_VECTOR(1 downto 0);
            myField             : in FIELD(0 to FIELD_SIZE - 1, 0 to FIELD_SIZE - 1);
                        
            red                 : out STD_LOGIC_VECTOR(3 downto 0);
            green               : out STD_LOGIC_VECTOR(3 downto 0);
            blue                : out STD_LOGIC_VECTOR(3 downto 0));
end component;

-- signals ---------------------------------
-- clock divider --
signal clock_reset : STD_LOGIC := '0';
signal clock25mhz : STD_LOGIC;
signal enable : STD_LOGIC := '1';
-- vga regulator --
signal h_outS : INTEGER;
signal v_outS : INTEGER;
signal dis_en : STD_LOGIC;

begin    
    P1 : clock_div 
    Generic Map ( COUNTER_BIT  => 2 )
    Port Map    ( selection    => 1,
                  clock_in     => clock100mhz,
                  reset        => clock_reset,
                  clock_enable => enable, 
                  clock_out    => clock25mhz);
               
    P2: vga_regulator
    Port Map (  clock                 => clock25mhz, 
                clear                 => clock_reset,
                horizontal_sync_pulse => horizontal_sync,
                vertical_sync_pulse   => vertical_sync,
                horizontal_out        => h_outS,
                vertical_out          => v_outS,
                display_enable        => dis_en);    
                
    P3: vga_display
    Generic Map (FIELD_SIZE => FIELD_SIZE)
    Port Map (  display_enable      => dis_en,
                clock_enable        => clock_enable,
                cursor_x            => cursor_x,
                cursor_y            => cursor_y,
                column              => h_outS,
                row                 => v_outS,
                thickness_selection => size_selection,
                myField             => myField,
                red                 => red,
                green               => green,
                blue                => blue);                       
end Behavioral;
