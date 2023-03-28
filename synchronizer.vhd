library ieee;
use ieee.std_logic_1164.all;
--Group 9, Hermela Gebretsion, Bowen Zheng

-- synchronizing pedestrian crosswalk inputs with the clock
entity synchronizer is port (

			clk					: in std_logic;						-- syncs with the global clock
			reset					: in std_logic;						-- reset button 
			din					: in std_logic;						-- inputs are unsynchronized crossign requests
			dout					: out std_logic
	);
	end synchronizer;
	
	architecture sync of synchronizer is 

	signal sreg					: std_logic_vector(1 downto 0); 	-- 2-bit signal to store current and previous values
	
begin 

	process(clk, reset, din) is 										-- process senstivity list
	begin
	
		if (rising_edge(clk)) then 									-- synced with the global clock
		
			if(reset = '1') then 										-- reset the signal if reset button is ON
				sreg <= "00";
				
			else
			sreg(1) <= sreg(0); 											-- shift signal by 1 bit
			sreg(0) <= din; 												-- set the first bit to the crossing input
			
			end if;
		end if;
	
		dout <= sreg(1); 													-- output the previous signal
	end process;
	
end sync;