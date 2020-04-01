library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use WORK.ENVIRONMENT_PACKAGE.ALL;

entity environment is
    Generic (FIELD_SIZE : INTEGER := 4);
    Port    (clock             : in STD_LOGIC;
             button_clock      : in STD_LOGIC;
             clock_enable      : in STD_LOGIC;
             button            : in STD_LOGIC_VECTOR(4 downto 0);
             initial_condition : in STD_LOGIC_VECTOR(2 downto 0);
             
             cursor_x          : out INTEGER;
             cursor_y          : out INTEGER;
             field_out         : out FIELD(0 to (FIELD_SIZE - 1), 0 to (FIELD_SIZE - 1)));
end environment;

architecture Behavioral of environment is
    -- signals
    -- next state
    signal myField   : FIELD(0 to (FIELD_SIZE - 1), 0 to (FIELD_SIZE - 1));
    signal newField  : FIELD(0 to (FIELD_SIZE - 1), 0 to (FIELD_SIZE - 1));
    signal condition : STD_LOGIC_VECTOR(2 downto 0) := "000";
    signal selection : STD_LOGIC_VECTOR(1 downto 0);
    -- cursor
    signal change                 : STD_LOGIC := '0';
    signal change_order           : STD_LOGIC := '0';
    signal column                 : INTEGER range 0 to FIELD_SIZE - 1 := 0;
    signal row                    : INTEGER range 0 to FIELD_SIZE - 1 := 0;
    signal delay1, delay2, delay3 : STD_LOGIC;
--------------------------------------------------------------------------
begin
    selection <= (clock_enable & change_order);
    with selection select newField <= update(myField) when "10",
                                      update(myField) when "11",
                                      reverse(myField, column, row) when "01",
                                      myField         when others;

    field_out <= myField;
    
    change_order <= delay1 AND delay2 AND (not delay3);
    cursor_x <= column;
    cursor_y <= row;
    
    NEXT_STATE: process(clock, initial_condition)
    begin
        if rising_edge(clock) then
        
            if(initial_condition = condition) then
                myField <= newField;
            else
                myField <= initialize(myField, initial_condition);
                condition <= initial_condition;
            end if;
        end if;
    end process;
    
        CURSOR : process(button_clock)
    begin
        if rising_edge(button_clock) then
            change <= '0'; 
            if clock_enable = '1' then
                column <= 0;
                row    <= 0;
                
            -- down button
            elsif button = "10000" then
                if (row = FIELD_SIZE - 1) then
                    row <= 0;
                else    
                    row <= row + 1;
                end if;
            -- right button
            elsif button = "01000" then
                if (column = FIELD_SIZE - 1) then
                    column <= 0;
                else    
                    column <= column + 1;
                end if;
            -- left button
            elsif button = "00100" then
                if (column = 0) then
                    column <= FIELD_SIZE - 1;
                else    
                    column <= column - 1;
                end if;
            -- up button
            elsif button = "00010" then
                if (row = 0) then
                    row <= FIELD_SIZE - 1;
                else    
                    row <= row - 1;
                end if;
            
            -- center button
            elsif button = "00001" then
                change <= '1';                
            end if;
        end if;
    end process;
    
    push_pulse : process(clock)
    begin
        if rising_edge(clock) then
            delay1 <= change;
            delay2 <= delay1;
            delay3 <= delay2;
        end if;
    end process;
    
end Behavioral;
