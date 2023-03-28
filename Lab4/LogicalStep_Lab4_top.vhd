
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY LogicalStep_Lab4_top IS
   PORT
	(
   clkin_50		: in	std_logic;							-- The 50 MHz FPGA Clockinput
	rst_n			: in	std_logic;							-- The RESET input (ACTIVE LOW)
	pb_n			: in	std_logic_vector(3 downto 0); -- The push-button inputs (ACTIVE LOW)
 	sw   			: in  std_logic_vector(7 downto 0); -- The switch inputs
   leds			: out std_logic_vector(7 downto 0);	-- for displaying the lab4 project details
	-------------------------------------------------------------
	-- you can add temporary output ports here if you need to debug your design 
	-- or to add internal signals for your simulations
	-------------------------------------------------------------
	
   seg7_data 	: out std_logic_vector(6 downto 0); -- 7-bit outputs to a 7-segment
	seg7_char1  : out	std_logic;							-- seg7 digit1 selectors
	seg7_char2  : out	std_logic							-- seg7 digit2 selectors
	);
END LogicalStep_Lab4_top;

ARCHITECTURE SimpleCircuit OF LogicalStep_Lab4_top IS

   component segment7_mux port (
          clk        : in  std_logic := '0';
			 DIN2 		: in  std_logic_vector(6 downto 0);	--bits 6 to 0 represent segments G,F,E,D,C,B,A
			 DIN1 		: in  std_logic_vector(6 downto 0); --bits 6 to 0 represent segments G,F,E,D,C,B,A
			 DOUT			: out	std_logic_vector(6 downto 0);
			 DIG2			: out	std_logic;
			 DIG1			: out	std_logic
   );
   end component;

   component clock_generator port (
			sim_mode			: in boolean;
			reset				: in std_logic;
         clkin      		: in  std_logic;
			sm_clken			: out	std_logic;
			blink		  		: out std_logic
  );
   end component;

   component pb_inverters port (
			 pb_n					: in std_logic_vector(3 downto 0);
			 pb			  		: out std_logic_vector(3 downto 0)
  );
   end component;
	
	Component State_Machine port
	(
			clk_input, reset, I0, I1, I2			: IN std_logic;
			output1, output2						: OUT std_logic
	);
	end component;

	
	component synchronizer port(
			clk					: in std_logic;
			reset					: in std_logic;
			din					: in std_logic;
			dout					: out std_logic
	);
   end component;
 
	component holding_register port (
			clk					: in std_logic;
			reset					: in std_logic;
			register_clr		: in std_logic;
			din					: in std_logic;
			dout					: out std_logic
	);
	end component;
			
	
----------------------------------------------------------------------------------------------------
	CONSTANT	sim_mode						: boolean := TRUE; -- set to FALSE for LogicalStep board downloads
	                                                     -- set to TRUE for SIMULATIONS
	
	SIGNAL sm_clken, blink_sig			: std_logic; 
	
	SIGNAL pb								: std_logic_vector(3 downto 0); -- pb(3) is used as an active-high reset for all registers
	
	SIGNAL output1, output2				: std_logic;
	
	SIGNAL input0, input1, input2		: std_logic; -- input signals to drive state machine
	
	
	signal seg7_A							: std_logic_vector(6 downto 0);
	signal seg7_B							: std_logic_vector(6 downto 0);
	
	signal EW_output						: std_logic;
	signal NS_output						: std_logic;

	

	
	
BEGIN
	--seg7_A <= (DIN1(5) & DIN1(4) & DIN1(2) & DIN1(1)) & '0';
	--seg7_B <= (DIN2(5) & DIN2(4) & DIN2(2) & DIN2(1)) & '0';
	
	

----------------------------------------------------------------------------------------------------
INST1: segment7_mux port map(clkin_50, seg7_A, seg7_B, seg7_data(6 downto 0), seg7_char2, seg7_char1); -- outputs seven segment display
INST2: pb_inverters		port map (pb_n, pb); -- inverts push button signals
INST3: clock_generator 	port map (sim_mode, pb(3), clkin_50, sm_clken, blink_sig);
--INST2: clock_generator 	port map (sim_mode, pb(3), clkin_50, leds(2), leds(0));
--INST4: State_Machine		port map (clkin_50, pb(3), input0, input1, input2, output1, output2);
INST5: synchronizer port map (clkin_50, pb(3), pb(1), EW_output); -- EW synchronizer
INST6: synchronizer port map (clkin_50, pb(3), pb(0), NS_output); -- NS syncrhonizer
INST7: holding_register port map (clkin_50, pb(3), pb(2), EW_output, leds(3)); -- EW holding register
INST8: holding_register port map (clkin_50, pb(3), pb(2), NS_output, leds(1)); -- NS holdign register


END SimpleCircuit;
