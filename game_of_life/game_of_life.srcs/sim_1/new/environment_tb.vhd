----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/25/2018 01:49:55 PM
-- Design Name: 
-- Module Name: environment_tb - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity environment_tb is
--  Port ( );
end environment_tb;

architecture Behavioral of environment_tb is
    constant size : INTEGER := 4;
    signal clock : STD_LOGIC := '1';
    signal button_clock : STD_LOGIC := '1';
    signal clock_enable : STD_LOGIC := '0';
    
    signal button : STD_LOGIC_VECTOR(4 downto 0);
    signal initial_condition : STD_LOGIC_VECTOR(1 downto 0) := "00";
    
    signal selection : STD_LOGIC_VECTOR(1 downto 0);
    signal change       : STD_LOGIC := '0';
    signal change_order : STD_LOGIC := '0';
    signal delay1, delay2, delay3 : STD_LOGIC;
    
    
    signal out_row0 : BIT_VECTOR(0 to 3);
    signal out_row1 : BIT_VECTOR(0 to 3);
    signal out_row2 : BIT_VECTOR(0 to 3);
    signal out_row3 : BIT_VECTOR(0 to 3);
    
begin
    
    clock <= not clock after 500 ns;
    button_clock <= not button_clock after 10 ns;
    
    DUT : entity work.environment(Behavioral)
        Generic Map (FIELD_SIZE => size)
        Port Map  (  clock             => clock,
                     button_clock      => button_clock,
                     clock_enable      => clock_enable,
                     button            => button,
                     initial_condition => initial_condition);
    
    sim : process
    begin
    
        wait for 500 ns;
        clock_enable <= '1';
        
        wait for 1000 ns;
        clock_enable <= '0';
        
        wait for 1000 ns;
        clock_enable <= '1';
        
        wait for 1000 ns;
        clock_enable <= '0';
        button <= "00001";
        
        wait for 4000 ns;
        button <= "00000";
        
        wait for 500 ns;
        clock_enable <= '1';
        
        wait for 100 ns;   
        wait; 
    end process;
    
end Behavioral;
