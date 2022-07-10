----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/03/2022 09:31:55 PM
-- Design Name: 
-- Module Name: a3 - Behavioral
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
use IEEE.STD_LOGIC_unsigned.ALL;


-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity a4 is    -- make a entity with name as a4
    Port ( clk : in STD_LOGIC;  --define a clock 
           B : in STD_LOGIC_VECTOR (15 downto 0); --define a vector of length 16 that contains input 4 length for each display
           segment : out STD_LOGIC_VECTOR (6 downto 0); --define a vector of length 7 that contains output of 7 segment display
           anode : out STD_LOGIC_VECTOR (3 downto 0)); -- define a vector of size 4 for the 4 seven segment display
end a4;

architecture Behavioral of a4 is

signal Bt:std_logic_vector(3 downto 0):="0000"; --define a signal for handle the input given by the buttons
signal refresh_clk : std_logic_vector(19 downto 0):= (others => '0'); -- a 20-bit clock used for selecting anode and incrementing refresh-rates.
signal refresh_rate:integer :=0;--define an integer for apply the timer to the clock 
signal clk_input:std_logic_vector( 1 downto 0):="00"; -- define a signal of size 2-bit for selecting a anode.

begin

-- Define a process of a combinational circuit using the logical expressions for each output segment
process(Bt)
begin
segment(0) <= (not Bt(3) and not Bt(2) and not Bt(1) and Bt(0)) or(not Bt(3) and Bt(2) and not Bt(1) and not Bt(0)) or (Bt(3) and Bt(2) and not Bt(1) and Bt(0)) or (Bt(3) and not Bt(2) and Bt(1) and Bt(0));
segment(1) <= (Bt(2) and Bt(1) and not Bt(0)) or (Bt(3) and Bt(1) and Bt(0)) or (not Bt(3) and Bt(2) and not Bt(1) and Bt(0)) or (Bt(3) and Bt(2) and not Bt(1) and not Bt(0));
segment(2) <= ((NOT Bt(3)) AND (NOT Bt(2)) AND Bt(1) AND (NOT Bt(0))) OR (Bt(3) AND Bt(2) AND Bt(1)) OR (Bt(3) AND Bt(2) AND (NOT Bt(0)));
segment(3) <= ((NOT Bt(3)) AND (NOT Bt(2)) AND (NOT Bt(1)) AND Bt(0)) OR ((NOT Bt(3)) AND Bt(2) AND (NOT Bt(1)) AND (NOT Bt(0))) OR (Bt(3) AND (NOT Bt(2)) AND Bt(1) AND (NOT Bt(0))) OR (Bt(2) AND Bt(1) AND Bt(0));
segment(4) <= ((NOT Bt(2)) AND (NOT Bt(1)) AND Bt(0)) OR ((NOT Bt(3)) AND Bt(0)) OR ((NOT Bt(3)) AND Bt(2) AND (NOT Bt(1)));
segment(5) <= ((NOT Bt(3)) AND (NOT Bt(2)) AND Bt(0)) OR ((NOT Bt(3)) AND (NOT Bt(2)) AND (Bt(1))) OR ((NOT Bt(3)) AND Bt(1) AND Bt(0)) OR (Bt(3) AND Bt(2) AND (NOT Bt(1)) AND Bt(0));
segment(6) <= ((NOT Bt(3)) AND (NOT Bt(2)) AND (NOT Bt(1))) OR ((NOT Bt(3)) AND Bt(2) AND Bt(1) AND Bt(0)) OR (Bt(3) AND Bt(2) AND (NOT Bt(1)) AND (NOT Bt(0)));

end process;

-- process over clock for chaning the refresh_clk and refresh_rate and selecting clk_input(anode selector)
process(clk)
begin 
if rising_edge(clk) then
    refresh_clk <= refresh_clk + '1';
    refresh_rate <= refresh_rate + 1;
    if refresh_rate > 8000 then
        refresh_rate <= 0;
    end if ;
    clk_input <= refresh_clk(19 downto 18);
end if ;
end process;

-- process over clock_input for showing the output to the seven segment display only at the rising rising_edge
process(clk_input)
begin
case( clk_input ) is

    -- 1st seven-segment (leftmost) display is always shows with his full capacity
    when "00" =>
        anode <= "0111";
        Bt <= B(15 downto 12);

    --2nd seven-segment display will glow only when the refresh_rate<4000 so its brightness will be less than leftmost.
    when "01" =>
    if( refresh_rate <4000) then
        anode <= "1011";
        Bt <= B(11 downto 8);

    else
        anode <= "1111";
    end if;

    --3rd seven-segment display will glow only when the refresh_rate<2000 so its brightness will be less than both 1st and 2nd seven-segment display.
    when "10" =>
    if( refresh_rate <2000) then
        anode <= "1101";
        Bt <= B(7 downto 4);

    else
        anode <= "1111";
    end if;

    --4th seven-segment display will glow only when the refresh_rate<1000 so its brightness will be less than all other displays.
    when "11" =>
    if( refresh_rate <1000) then
        anode <= "1110";
        Bt <= B(3 downto 0);

    else
        anode <= "1111";
    end if;
    when others => anode <= "1111";

end case ;
end process;

end Behavioral;