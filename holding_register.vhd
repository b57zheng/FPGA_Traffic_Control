library ieee;
use ieee.std_logic_1164.all;
--Group 9, Hermela Gebretsion, Bowen Zheng

entity holding_register is port (

			clk					: in std_logic;					-- syncs with the global clock
			reset					: in std_logic;
			register_clr		: in std_logic;					-- clears the holding register, sent from State Machine
			din					: in std_logic;
			dout					: out std_logic					-- pending crossing request
  );
  end holding_register;
  
architecture hold of holding_register is 
 
	signal hreg			: std_logic; 								-- creating a signal
	to temporarily store our holding register value
	
begin 

	process(clk, reset, din, register_clr, hreg) 			-- sensitivity list of inputs
	begin
	
		if (rising_edge(clk)) then									-- process only acitvates at rising edge
		
			if( reset = '1') then 											
			hreg <= '0';												-- reset hreg to 0 if hreg is pressed
			
			else
			hreg <= ((not register_clr) AND (din OR hreg)); -- set the hreg value 
			end if;
	
	end if;
	
	dout <= hreg; -- sets the pending request
	end process;

end hold;