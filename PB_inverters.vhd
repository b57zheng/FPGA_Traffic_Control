library ieee;
use ieee.std_logic_1164.all;
--Group 9, Hermela Gebretsion, Bowen Zheng

entity PB_inverters is port (
 	pb_n	: in  std_logic_vector (3 downto 0);
	pb	: out	std_logic_vector(3 downto 0)							 
	); 
end PB_inverters;

architecture ckt of PB_inverters is

begin
pb <= NOT(pb_n); 							-- inverts push buttons


end ckt;