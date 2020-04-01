----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/10/2018 09:53:21 PM
-- Design Name: 
-- Module Name: environment_package - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.NUMERIC_STD.ALL;

package environment_package is
    type FIELD is array (integer range <> , integer range <>) of BIT;
    
    function clear            (area : FIELD)                                             return FIELD;
    function initialize       (area : FIELD; selection : STD_LOGIC_VECTOR(2 downto 0))   return FIELD;
    function isAlive          (area: FIELD; X : INTEGER; Y : INTEGER)                    return BOOLEAN;
    function reverse          (area: FIELD; X : INTEGER; Y : INTEGER)                    return FIELD;
    function numberOfNeighbor (area: FIELD; X : INTEGER; Y : INTEGER)                    return INTEGER;
    function findNext         (area: FIELD; X : INTEGER; Y : INTEGER)                    return BIT;
    function update           (area : FIELD)                                             return FIELD;
end package;

package body environment_package is
    -- sets every cell as dead
    function clear(area : FIELD) return FIELD is
        variable dummy_field : FIELD(0 to (area'length - 1), 0 to (area'length - 1));
    begin
        -- reset 
        for i in 0 to (dummy_field'length - 1) loop
            for j in 0 to (dummy_field'length - 1) loop
                dummy_field(i, j) := '0';
            end loop;
        end loop;       
        return dummy_field; 
    end function;
-------------------------------------------------------------------------------------------------
    -- sets an initial condition 
    function initialize(area : FIELD; selection : STD_LOGIC_VECTOR(2 downto 0)) return FIELD is
        variable dummy_field : FIELD(0 to (area'length - 1), 0 to (area'length - 1));
    begin
        -- all alive position 
        if selection = "001" then
            for i in 0 to (dummy_field'length - 1) loop
                for j in 0 to (dummy_field'length - 1) loop
                    dummy_field(i, j) := '1';
                end loop;
            end loop;     
        -- stable square position       
        elsif selection = "010" then
            for i in 0 to (dummy_field'length - 1) loop
                for j in 0 to (dummy_field'length - 1) loop
                    if (i <= 1 AND j <= 1) then
                        dummy_field(i, j) := '1';
                    else
                        dummy_field(i, j) := '0';
                    end if;
                end loop;
            end loop;  
        -- glider position    
        elsif selection = "011" then
            for i in 0 to (dummy_field'length - 1) loop
                for j in 0 to (dummy_field'length - 1) loop
                    if (i = 1 AND j = 0) OR (i = 2 AND j = 1) OR
                        (i = 0 AND j = 2) OR (i = 1 AND j = 2) OR
                        (i = 2 AND j = 2) then
                        dummy_field(i, j) := '1';
                    else
                        dummy_field(i, j) := '0';
                    end if;
                end loop;
            end loop;       
        -- exploder position
        elsif selection = "100" AND dummy_field'length >= 15 then
            for i in 0 to (dummy_field'length - 1) loop
                for j in 0 to (dummy_field'length - 1) loop
                    if ((i = (dummy_field'length / 2) - 2) 
                        AND ((dummy_field'length / 2) - 2 <= j 
                        AND j <=(dummy_field'length / 2) + 2)) 
                    OR (i = dummy_field'length / 2 AND j = (dummy_field'length / 2) - 2) 
                    OR(i = dummy_field'length / 2 AND j = (dummy_field'length / 2) + 2) 
                    OR ((i = (dummy_field'length / 2) + 2) 
                        AND ((dummy_field'length / 2) - 2 <= j 
                        AND j <=(dummy_field'length / 2) + 2)) then
                        dummy_field(i, j) := '1';
                    else
                        dummy_field(i, j) := '0';
                    end if;
                end loop;
            end loop;   
        -- tumblr position
        elsif selection = "101" AND dummy_field'length >= 15 then
            for i in 0 to (dummy_field'length - 1) loop
                for j in 0 to (dummy_field'length - 1) loop
                    if ((i = (dummy_field'length / 2) - 1) 
                        AND ((dummy_field'length / 2) - 2 <= j 
                        AND j <= (dummy_field'length / 2) + 2))
                    OR ((i = (dummy_field'length / 2) - 2) 
                        AND j < (dummy_field'length / 2)
                        AND (dummy_field'length / 2) - 2 <= j) 
                    OR ((i = (dummy_field'length / 2) - 3) 
                        AND (dummy_field'length / 2) < j
                        AND j <= (dummy_field'length / 2) + 3) 
                               
                    
                    OR (i = (dummy_field'length / 2) - 2 AND j = (dummy_field'length / 2) + 3) 
                    OR (i = (dummy_field'length / 2) + 2 AND j = (dummy_field'length / 2) + 3) 
                    
                    OR ((i = (dummy_field'length / 2) + 1) 
                        AND ((dummy_field'length / 2) - 2 <= j 
                        AND j <= (dummy_field'length / 2) + 2))
                    OR ((i = (dummy_field'length / 2) + 2) 
                        AND j < (dummy_field'length / 2)
                        AND (dummy_field'length / 2) - 2 <= j) 
                    OR ((i = (dummy_field'length / 2) + 3) 
                        AND (dummy_field'length / 2) < j
                        AND j <= (dummy_field'length / 2) + 3) then
                        dummy_field(i, j) := '1';
                    else
                        dummy_field(i, j) := '0';
                    end if;
                end loop;
            end loop;                       
        else
            return clear(area);    
        end if;
        return dummy_field;  
    end function;
-------------------------------------------------------------------------------------------------
    -- checks whether cell is alive or not
    function isAlive(area: FIELD; X : INTEGER; Y : INTEGER) return BOOLEAN is 
    begin 
        return (area(X , Y) = '1');
    end function;
-------------------------------------------------------------------------------------------------
    function reverse (area: FIELD; X : INTEGER; Y : INTEGER) return FIELD is
        variable dummy_field : FIELD(0 to (area'length - 1), 0 to (area'length - 1));
    begin
        for i in 0 to (dummy_field'length - 1) loop
                for j in 0 to (dummy_field'length - 1) loop
                    dummy_field(i, j) := area(i, j);
            end loop;
        end loop;
        
        dummy_field(X, Y) := not dummy_field(X, Y);
        
        return dummy_field;
    end function;
    -- determines the number of neighbors
    function numberOfNeighbor ( area: FIELD; X : INTEGER; Y : INTEGER ) return INTEGER is
        -- constants 
        constant DEAD : BIT := '0';
        constant ALIVE : BIT := '1';
        -- variables
        variable count : INTEGER range -1 to 9 := 0;
        begin
            -- for loops counts the cell itself so to
            -- prevent counting itself as a neighbor
            -- count is set to -1 if the cell is populated
            if (area(X , Y) = ALIVE) then
                count := -1;
            end if;    
            
             -- corners: looks at 3 squares for neighbors
             if ( (X = 0) and (Y = 0) ) then
                for i in X to (X + 1) loop
                    for j in Y to (Y + 1) loop
                        if (area(i, j) = ALIVE) then
                            count := count + 1;
                        end if;
                    end loop;
                end loop;
        
             elsif ( (X = area'length - 1) and (Y = 0) ) then
                for i in (X - 1) to X loop
                    for j in Y to (Y + 1) loop
                        if (area(i, j) = ALIVE) then
                            count := count + 1;
                        end if;
                    end loop;
                end loop;
             
             elsif ( (X = 0) and (Y = area'length - 1) ) then
                for i in X to (X + 1) loop
                    for j in (Y - 1) to Y loop
                        if (area(i, j) = ALIVE) then
                            count := count + 1;
                        end if;
                    end loop;
                end loop;
             
             elsif ( (X = area'length - 1) and (Y = area'length - 1) ) then
                for i in (X - 1) to X loop
                    for j in (Y - 1) to Y loop
                        if (area(i, j) = ALIVE) then
                            count := count + 1;
                        end if;
                    end loop;
                end loop; 
             
             -- base lines: looks at 6 squares around it
             -- since these come after from the checking of corners
             -- checking one the parameters is enough for lines
             elsif ( X = 0 ) then
                for i in X to (X + 1) loop
                    for j in (Y - 1) to (Y + 1)  loop
                        if (area(i, j) = ALIVE) then
                            count := count + 1;
                        end if;
                    end loop;
                end loop; 
        
             elsif ( X = area'length - 1 ) then
                for i in (X - 1) to X loop
                    for j in (Y - 1) to (Y + 1)  loop
                        if (area(i, j) = ALIVE) then
                            count := count + 1;
                        end if;
                    end loop;
                end loop;
             
             elsif ( Y = 0 ) then
                   for i in (X - 1) to (X + 1) loop
                       for j in Y to (Y + 1)  loop
                           if (area(i, j) = ALIVE) then
                               count := count + 1;
                           end if;
                       end loop;
                   end loop; 
                   
             elsif ( Y = area'length - 1 ) then
                for i in (X - 1) to (X + 1) loop
                    for j in (Y - 1) to Y  loop
                        if (area(i, j) = ALIVE) then
                            count := count + 1;
                        end if;
                    end loop;
                end loop;
        
             -- inner: looks at 9 squares around it
             else
                for i in (X - 1) to (X + 1) loop
                    for j in (Y - 1) to (Y + 1)  loop
                        if (area(i, j) = ALIVE) then
                            count := count + 1;
                        end if;
                    end loop; 
                end loop;    
             end if;   
             
            return count;
    end function;
-------------------------------------------------------------------------------------------------   
    -- determines the next state of the cell using numberOfNeighbors 
    function findNext(area: FIELD; X : INTEGER; Y : INTEGER) return BIT is
        -- constants
        constant DEAD : BIT := '0';
        constant ALIVE : BIT := '1';
        constant REPRODUCE : INTEGER := 3;
        constant LOW : INTEGER := 1;
        constant HIGH : INTEGER := 4;
        -- variables
        variable neighbor_count : INTEGER;
        ------------------------------------
        begin
            neighbor_count := numberOfNeighbor( area, X, Y );
            
            if (area(X, Y) = ALIVE) then
                if ((neighbor_count <= LOW) OR (neighbor_count >= HIGH)) then
                    return DEAD;
                else
                    return ALIVE;
                end if;
            else
                if (neighbor_count = REPRODUCE) then
                    return ALIVE;
                else
                    return DEAD;
                end if;
            end if;   
    end function;
-------------------------------------------------------------------------------------------------  
    -- creates the next field according to current one using findNext  
    function update(area : FIELD) return FIELD is
        variable next_field : FIELD(0 to area'length - 1 , 0 to area'length - 1 );
    begin 
        -- creating the next_field
        for i in 0 to (next_field'length - 1) loop
            for j in 0 to (next_field'length - 1) loop
                next_field(i, j) := findNext(area, i, j);
            end loop;
        end loop; 
        
        return next_field;
--    begin
--        return clear(area);
    end function;
-------------------------------------------------------------------------------------------------    
end package body;
