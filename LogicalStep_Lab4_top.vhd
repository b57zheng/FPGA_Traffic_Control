LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
--Group 9, Hermela Gebretsion, Bowen Zheng

ENTITY LogicalStep_Lab4_top IS
   PORT
	(
	
   clkin_50			: in	std_logic;							-- The 50 MHz FPGA Clockinput
	rst_n				: in	std_logic;							-- The RESET input (ACTIVE LOW)
	pb_n				: in	std_logic_vector(3 downto 0); -- The push-button inputs (ACTIVE LOW)
 	sw   				: in  std_logic_vector(7 downto 0); -- The switch inputs
   leds				: out std_logic_vector(7 downto 0);	-- for displaying the lab4 project details
	-------------------------------------------------------------
	-- you can add temporary output ports here if you need to debug your design 
	-- or to add internal signals for your simulations
	-------------------------------------------------------------
	
   seg7_data 		: out std_logic_vector(6 downto 0); -- 7-bit outputs to a 7-segment
	seg7_char1  	: out	std_logic;							-- seg7 digit1 selectors
	seg7_char2  	: out	std_logic							-- seg7 digit2 selectors
	
--	NS_red			: out	std_logic;							-- signals used to test output of segment A, G and D
--	NS_ambr			: out	std_logic;
--	NS_grn			: out	std_logic;
--	
--	EW_red			: out	std_logic;
--	EW_ambr			: out	std_logic;
--	EW_grn			: out	std_logic;
--	
--	sm_clk_enable	: out std_logic;							-- sm_clken signal used in simulation
--	blink_signal	: out std_logic							-- blink_sigused in simulation
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

   component pb_inverters port (																-- inverts push buttons from active low to active high
			 pb_n					: in std_logic_vector(3 downto 0);
			 pb			  		: out std_logic_vector(3 downto 0)
  );
   end component;
	
	Component State_Machine port
	(
			clk_input, reset, enable			: IN std_logic; 							-- clock, reset and clock enable
			NS_hold_state, EW_hold_state		: IN std_logic; 							-- holding states for NS and EW
			blink										: IN std_logic; 							-- blinking lights signal
 
			NS_cross, EW_cross					: OUT std_logic;
			NS_light, EW_light					: OUT std_logic_vector(6 downto 0);	-- green, red and amber lights for NS and EW
 
 
			clr_NS, clr_EW							: OUT std_logic; 							-- clears signals for NS and EW
			states									: OUT std_logic_vector(3 downto 0)  -- 4 bit output of states
			
--			EW_grn, EW_ambr, EW_red				: OUT std_logic;							-- signals used for simulation testing of segments A, G and D on Digit 1
-- 
--			NS_grn, NS_ambr, NS_red				: OUT std_logic							-- signals used for simulation testing of segments A, G and D on Digit 2
	);
	end component;

	
	component synchronizer port(
			clk					: in std_logic;												-- synchronizes with shared global clock
			reset					: in std_logic;												-- reset button sets current state back to initial state
			din					: in std_logic;												-- push button crossing request signal
			dout					: out std_logic												-- ouputs crossing request synched with the clock
	);
   end component;
 
	component holding_register port (														-- holds crossing request signals and sends them to the State Machine
			clk					: in std_logic;												
			reset					: in std_logic;												-- reset button
			register_clr		: in std_logic;												-- clear holding register input
			din					: in std_logic;
			dout					: out std_logic												-- pending crossign request output
	);
	end component;
			
	
----------------------------------------------------------------------------------------------------
	CONSTANT	sim_mode						: boolean := FALSE; 					-- set to FALSE for LogicalStep board downloads
																							-- set to TRUE for SIMULATIONS
	
	SIGNAL sm_clken, blink_sig			: std_logic; 
	
	SIGNAL pb								: std_logic_vector(3 downto 0); 	-- pb(3) is used as an active-high reset for all registers

	
	
	signal seg7_A							: std_logic_vector(6 downto 0); 	-- signal for segments of Digit 2 
	signal seg7_B							: std_logic_vector(6 downto 0); 	-- signal for segments of Digit 2 
	
	signal EW_sync							: std_logic;							-- signal for crossing request of EW synched with clock
	signal NS_sync							: std_logic;							-- signal for crossing request of NS synched with clock
	
	signal clear_NS						: std_logic;							-- signal for when holding register gets cleared for NS
	signal clear_EW						: std_logic;							-- signal for when holding register gets cleared for EW
	signal NS_hold, EW_hold 			: std_logic;							-- signals for holding register outputs

--	signal EW_a, EW_g, EW_d				: std_logic;							-- Simulation testing signals for segements A, G and D on Digit 1
--	signal NS_a, NS_g, NS_d				: std_logic;							-- Simulation testing signals for segements A, G and D on Digit 2
	
BEGIN
	

leds(1) <= NS_hold;																	-- assign leds(1) to the crossing request signal for NS
leds(3) <= EW_hold;																	-- assign leds(3) to the crossing request signal for EW

-------------------------- Simulation Testing Signals-------------------------------------------------
--EW_red <= EW_a;
--EW_ambr <= EW_g;
--EW_grn <= EW_d;
--
--NS_red <= NS_a;
--NS_ambr <= NS_g;
--NS_grn <= NS_d;
--
--sm_clk_enable <= sm_clken;
--blink_signal <= blink_sig;
	

----------------------------------------------------------------------------------------------------
INST1: segment7_mux port map(clkin_50, seg7_A, seg7_B, seg7_data(6 downto 0), seg7_char2, seg7_char1); 																				 -- outputs seven segment display
INST2: pb_inverters		port map (pb_n, pb); 																																							 -- inverts push button signals
INST3: clock_generator 	port map (sim_mode, pb(3), clkin_50, sm_clken, blink_sig);																											 -- generates clock signals
INST4: State_Machine		port map (clkin_50, pb(3), sm_clken, NS_hold, EW_hold, blink_sig, leds(0), leds(2), seg7_A, seg7_B, clear_NS, clear_EW, leds(7 downto 4)); -- Determines state changes, will only run when sm_clken is active, outputs crossing and clears holding register
INST5: synchronizer port map (clkin_50, pb(3), pb(1), EW_sync); 																																	 -- EW synchronizer, syncs and sends crossing request inputs with the clock
INST6: synchronizer port map (clkin_50, pb(3), pb(0), NS_sync); 																																	 -- NS syncrhonizer
INST7: holding_register port map (clkin_50, pb(3), clear_EW, EW_sync, EW_hold); 																												 -- EW holding register, holds crossing request signal until State Machine montiors and clears it
INST8: holding_register port map (clkin_50, pb(3), clear_NS, NS_sync, NS_hold); 																												 -- NS holding register

END SimpleCircuit;
