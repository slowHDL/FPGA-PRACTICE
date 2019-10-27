
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

----------------------------------
--		Entity Declaration 		--
----------------------------------
-- Here we specify all input/output ports

entity ledtest is
	port(
		clk_50mhz : in std_logic ;
		reset_btn : in std_logic;
		green_led : out std_logic_vector(0 to 7)
	);
end entity;

----------------------------------
--	Architecture Declaration 	--
----------------------------------
--	here we put the description code of the design

architecture behave of ledtest is

-- signal declaration

signal clk_1hz : std_logic ;
signal scaler : integer range 0 to 25000000 ;
signal counter : integer range 0 to 8;
signal LED  : std_logic_vector(0 to 7);

begin

-- this process is used to scale down the 50mhz frequency
-- In reality, clk_1hz is not periodic but i used it to get 2 clock cycle by second ( 2 rising edge ).
-- 50 mhz means 50 000 000 cycle in one second : 
-- by using the scaler , i will have 2 cycle by second so that led will be on 1/2 s and off 1/2 s
 
	clk_1hz_process : process( clk_50mhz , reset_btn )
	begin
		if (reset_btn = '0') then 
			clk_1hz <= '0';
			scaler <= 0;
			counter <= 0;
		elsif(rising_edge(clk_50mhz)) then 
			if (scaler < 25000000) then 
				scaler <= scaler + 1 ;
				clk_1hz <= '0';
			else
				scaler <= 0;
				clk_1hz <= '1';
				counter <= counter + 1;
			end if;
		elsif(falling_edge(clk_50mhz)) then 
			if (scaler < 25000000) then 
				scaler <= scaler + 1 ;
				clk_1hz <= '0';
			else
				scaler <= 0;
				clk_1hz <= '1';
				counter <= counter + 1;
			end if;
		end if;
	end process clk_1hz_process;

-- blinking LED process : led turn on and off	
	blinking_process : process (clk_1hz,reset_btn)
	begin
		if (reset_btn = '0') then 
			LED(0) <= '0';
		
		elsif rising_edge(clk_1hz) AND counter = 1 then
			LED(0) <= not LED(0) ;
			LED(7) <=  '0' ; 
		elsif rising_edge(clk_1hz) AND counter = 2 then
			LED(1) <= not LED(1) ;
			LED(0) <= not LED(0) ;
		elsif rising_edge(clk_1hz) AND counter = 3 then
			LED(2) <= not LED(2) ;
			LED(1) <= not LED(1) ;
		elsif rising_edge(clk_1hz) AND counter = 4 then
			LED(3) <= not LED(3) ;
			LED(2) <= not LED(2) ;
		elsif rising_edge(clk_1hz) AND counter = 5 then
			LED(4) <= not LED(4) ;
			LED(3) <= not LED(3) ;
		elsif rising_edge(clk_1hz) AND counter = 6 then
			LED(5) <= not LED(5) ;
			LED(4) <= not LED(4) ;
		elsif rising_edge(clk_1hz) AND counter = 7 then
			LED(6) <= not LED(6) ;
			LED(5) <= not LED(5) ;
		elsif rising_edge(clk_1hz) AND counter = 8 then
			LED(7) <= not LED(7) ;
			LED(6) <= not LED(6) ;

		end if;

	end process blinking_process;

	green_led(0) <= LED(0);
	green_led(1) <= LED(1);
	green_led(2) <= LED(2);
	green_led(3) <= LED(3);
	green_led(4) <= LED(4);
	green_led(5) <= LED(5);
	green_led(6) <= LED(6);
	green_led(7) <= LED(7);
end behave;