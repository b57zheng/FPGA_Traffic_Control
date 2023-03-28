library ieee;
use ieee.std_logic_1164.all;

 -- synchronizing pedestrian crosswalk inputs with the clock
entity synchronizer is port (

			clk					: in std_logic;
			reset					: in std_logic;
			din					: in std_logic;
			dout					: out std_logic
	);
	end synchronizer;
	
	architecture sync of synchronizer is 

	signal sreg					: std_logic_vector(1 downto 0); -- 2-bit signal to store current and previous values
	
begin 

	process(clk, reset, din) is 
	begin
	
		if (rising_edge(clk)) then
		
			if(reset = '1') then -- reset the signal if reset button is ON
				sreg <= "00";
				
			else
			sreg(1) <= sreg(0); -- shift signal by 1 bit
			sreg(0) <= din; -- set the first bit to the crosswalk input
			
			end if;
		end if;
	
		dout <= sreg(1); -- output the previous signal
	end process;
	
end sync;