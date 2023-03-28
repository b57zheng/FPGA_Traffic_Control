library ieee;
use ieee.std_logic_1164.all;

entity holding_register is port (

			clk					: in std_logic;
			reset					: in std_logic;
			register_clr		: in std_logic;
			din					: in std_logic;
			dout					: out std_logic
  );
  end holding_register;
  
architecture hold of holding_register is 
 
	signal hreg			: std_logic; 
	
begin 

	
		process(clk, reset, din, register_clr, hreg) -- sensitivity list of inputs
		begin
		
			if (rising_edge(clk)) then
			
				if( reset = '1') then 
				hreg <= '0';
				
				else
				hreg <= ((not register_clr) AND (din OR hreg)); -- set the hreg value id reset is not pressed
				
				end if;
		
		end if;
		
		dout <= hreg; -- sets the pending request
		end process;

end hold;