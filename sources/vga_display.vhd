library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use WORK.ENVIRONMENT_PACKAGE.ALL;
--use IEEE.NUMERIC_STD.ALL;
--use UNISIM.VComponents.all;

entity vga_display is
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
end vga_display;

architecture Behavioral of vga_display is
    -- signals
    signal row_thickness_pixel : INTEGER;
    signal col_thickness_pixel : INTEGER;
    signal indexX : INTEGER;
    signal indexY : INTEGER;

begin    
    
    with thickness_selection select 
    row_thickness_pixel <=  24 when "00",
                            48 when "01",
                            60 when "10",
                            120 when "11";
                                            
    with thickness_selection select 
    col_thickness_pixel <=  32 when "00",
                            64 when "01",
                            80 when "10",
                            160 when "11";  
                              
    indexX <= (column / col_thickness_pixel); 
    indexY <= (row / row_thickness_pixel);
                               
    process(display_enable, column, row, thickness_selection)
    begin              
        if (display_enable = '1') then
            if (row    mod row_thickness_pixel = 0 OR
                column mod col_thickness_pixel = 0)  then
                -- grey
                red   <= "1000";
                green <= "1000";
                blue  <= "1000"; 
            elsif ((indexX < myField'length) AND (indexY < myField'length) 
                    AND isAlive(myField, indexX, indexY)) then
                -- white
                red   <= (others => '1');
                green <= (others => '1');
                blue  <= (others => '1');    
            else
                -- black
                red   <= (others => '0');
                green <= (others => '0');
                blue  <= (others => '0');              
            end if;
            
            if clock_enable = '0' then
                if (indexX = cursor_x AND indexY = cursor_y)  then
                    -- yellow
                    red   <= (others => '1');
                    green <= (others => '1');
                    blue  <= (others => '0'); 
                end if;
            end if;
        else
            -- black
            red   <= (others => '0');
            green <= (others => '0');
            blue  <= (others => '0');
        end if;   
    end process;
end Behavioral;


