library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity vga_regulator is
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
end vga_regulator;

architecture Behavioral of vga_regulator is
    -- constants --
	constant HORIZONTAL_PERIOD   : INTEGER := HORIZONTAL_PIXELS + HORIZONTAL_PULSE 
	                                        + HORIZONTAL_FRONTPORCH + HORIZONTAL_BACKPORCH;
	
	constant VERTICAL_PERIOD     : INTEGER := VERTICAL_PIXELS + VERTICAL_PULSE 
                                            + VERTICAL_FRONTPORCH + VERTICAL_BACKPORCH;
    -- signals --
    signal vertical_count_enable : STD_LOGIC := '0';
begin

    process( clock , clear )
        variable horizontal_count : INTEGER range 0 to (HORIZONTAL_PERIOD - 1) := 0;
        variable vertical_count   : INTEGER range 0 to (VERTICAL_PERIOD - 1)   := 0;
    begin
        if (clear = '1') then
            horizontal_count      := 0;
            vertical_count        := 0;
            display_enable        <= '0';
            horizontal_sync_pulse <= not HORIZONTAL_POLARITY;
            vertical_sync_pulse   <= not VERTICAL_POLARITY;
            
        elsif rising_edge( clock ) then
            -- horizontal pixel count
            if (horizontal_count = (HORIZONTAL_PERIOD - 1)) then
                horizontal_count := 0;
                vertical_count_enable <= '1';
            else
                horizontal_count := horizontal_count + 1;
                vertical_count_enable <= '0';
            end if;
            
            -- vertical pixel count 
            if (vertical_count_enable = '1') then
                if (vertical_count = (VERTICAL_PERIOD - 1)) then
                    vertical_count := 0;
                else
                    vertical_count := vertical_count + 1;
                end if;
            end if;
            
            -- generate horizontal sync pulse
            if ( horizontal_count >= HORIZONTAL_PERIOD - (HORIZONTAL_PULSE + HORIZONTAL_BACKPORCH) AND 
                 horizontal_count < HORIZONTAL_PERIOD - HORIZONTAL_BACKPORCH ) then
                horizontal_sync_pulse <= HORIZONTAL_POLARITY;   
            else
                horizontal_sync_pulse <= not HORIZONTAL_POLARITY;
            end if;
            
            -- generate vertical sync pulse
            if ( vertical_count >= VERTICAL_PERIOD - (VERTICAL_PULSE + VERTICAL_BACKPORCH) AND 
                 vertical_count < VERTICAL_PERIOD - VERTICAL_BACKPORCH ) then
                vertical_sync_pulse <= VERTICAL_POLARITY;   
            else
                vertical_sync_pulse <= not VERTICAL_POLARITY;
            end if;
            
            -- enable display 
            if (horizontal_count < HORIZONTAL_PIXELS AND vertical_count < VERTICAL_PIXELS ) then
                display_enable <= '1';
            else
                display_enable <= '0';
            end if;
            
            -- generate each pixel
            if (horizontal_count < HORIZONTAL_PIXELS) then
                horizontal_out <= horizontal_count;
            end if;
            if (vertical_count < VERTICAL_PIXELS) then
                vertical_out <= vertical_count;
            end if;
        end if;
    end process;

end Behavioral;
