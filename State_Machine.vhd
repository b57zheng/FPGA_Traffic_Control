library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
--Group 9, Hermela Gebretsion, Bowen Zheng

Entity State_Machine IS Port
(
 clk_input, reset, enable			: IN std_logic; 							-- clock, reset and clock enable
 NS_hold_state, EW_hold_state		: IN std_logic; 							-- holding states for NS and EW
 blink									: IN std_logic; 							-- blinking lights signal
 
 NS_cross, EW_cross					: OUT std_logic;
 NS_light, EW_light					: OUT std_logic_vector(6 downto 0);	-- green, red and amber lights for NS and EW
 
 
 clr_NS, clr_EW						: OUT std_logic; 							-- clears signals for NS and EW
 states									: OUT std_logic_vector(3 downto 0)  -- 4 bit output of states
 
-- EW_grn, EW_ambr, EW_red			: OUT std_logic;
-- 
-- NS_grn, NS_ambr, NS_red			: OUT std_logic
 );
END ENTITY;
 

 Architecture SM of State_Machine is

 
 TYPE STATE_NAMES IS (S0, S1, S2, S3, S4, S5, S6, S7, S8, S9, S10, S11, S12, S13, S14, S15);   -- list all the STATE_NAMES values

 
 SIGNAL current_state, next_state	:  STATE_NAMES;     	-- signals of type STATE_NAMES

 BEGIN

  --------------------------------------------------------------------------------
 --State Machine:
 --------------------------------------------------------------------------------

 -- REGISTER_LOGIC PROCESS

Register_Section: PROCESS (clk_input)  					-- this process updates with a clock
BEGIN
	IF(rising_edge(clk_input)) THEN							-- updates on rising edge of the clock
		IF (reset = '1') THEN
			current_state <= S0;									-- resets current state back to S0
		ELSIF (reset = '0' AND enable ='1') THEN			-- when enable is on update current state to next state but only if reset is not active
			current_state <= next_State;
		END IF;
	END IF;
END PROCESS;	



-- TRANSITION LOGIC PROCESS
-- Logic that determines the next state after the clock changes
Transition_Section: PROCESS (current_state) 

BEGIN
 CASE current_state IS
	
		  WHEN S0 =>		
				IF(EW_hold_state='1' AND NS_hold_state = '0') THEN					-- If only the EW holding register is active jump from S0 to S6
				next_state <= S6;
				ELSE
				next_state <= S1;
				END IF;

         WHEN S1 =>	
				IF(EW_hold_state='1' AND NS_hold_state = '0') THEN					-- If only the EW holding register is active jump from S1 to S6
				next_state <= S6;
				ELSE
				next_state <= S2;
				END IF; 
					

         WHEN S2 =>		
				next_state <= S3;
				
         WHEN S3 =>		
				next_state <=S4;

         WHEN S4 =>		
				next_state <= S5;

         WHEN S5 =>		
				next_state <= S6;
				
         WHEN S6 =>		
				next_state <= S7;
				
         WHEN S7 =>		
				next_state <= S8;

			WHEN S8 =>
				IF (NS_hold_State = '1' AND EW_hold_State ='0') THEN				-- If only the NS holding register is active jump from S8 to S14
				 next_state <= S14;
				 ELSE 
				 next_state <= S9;
				END IF;
			
			WHEN S9 =>
				IF (NS_hold_State = '1' AND EW_hold_State ='0') THEN				-- If only the NS holding register is active jump from S9 to S14
				 next_state <= S14;
				 ELSE 
				 next_state <= S10;
				END IF;
			
			WHEN S10 =>
				next_state <= S11;
				
			WHEN S11 =>
				next_state <= S12;
			
			WHEN S12 =>
				next_state <= S13;
			
			WHEN S13 =>
				next_state <= S14;
				
			WHEN S14 =>
				next_state <= S15;
			
			WHEN S15 =>																			-- Return to the first state after reaching the last state
				next_state <= S0;
	  END CASE;
 END PROCESS;
 

-- DECODER SECTION PROCESS (MOORE FORM SHOWN)
-- red	: 0000001
-- amber : 1000000
-- green : 0001000
-- all outputs generated here
Decoder_Section: PROCESS (current_state, blink) 					  


BEGIN
     CASE current_state IS																  -- cases for each state
	  
         WHEN S0 =>		
				
				NS_light <= ("0001000" AND ("000" & blink & "000"));  		  -- blinking green
				EW_light <= "0000001";
				clr_NS <= '0';
				clr_EW <= '0';
				NS_cross <= '0'; 													
				EW_cross <= '0';
				states <= "0000";															  -- current state represesented in binary 
				
--				EW_grn <= '0';
--				EW_ambr <= '0';
--				EW_red <= '1';
				
--				IF (blink= '1') THEN
--					NS_grn <= '1';
--				ELSE
--					Ns_grn <= '0';
--				END IF;
--				
--				NS_ambr <= '0';
--				NS_red <= '0';
					

				
         WHEN S1 =>		
				
				NS_light <= ("0001000" AND ("000" & blink & "000")) ; 		-- blinking green
				EW_light <= "0000001";
				clr_NS <= '0';
				clr_EW <= '0';
				NS_cross <= '0';
				EW_cross <= '0';
				states <= "0001";
				
--				EW_grn <= '0';
--				EW_ambr <= '0';
--				EW_red <= '1';
				
--				IF (blink='1') THEN
--					NS_grn <= '1';
--				ELSE
--					Ns_grn <= '0';
--				END IF;
--				
--				NS_ambr <= '0';
--				NS_red <= '0';

         WHEN S2 =>		
				
				NS_light <= "0001000";
				EW_light <= "0000001";
				clr_NS <= '0';
				clr_EW <= '0';
				NS_cross <= '1';															-- NS crossing signal ON at NS solid green light
				EW_cross <= '0';
				states <= "0010";
				
--				EW_grn <= '0';
--				EW_ambr <= '0';
--				EW_red <= '1';
--				
--				NS_grn <='1';
--				NS_ambr <='0';
--				NS_red <='0';
				
         WHEN S3 =>	
			
				NS_light <= "0001000";
				EW_light <= "0000001";
				clr_NS <= '0';
				clr_EW <= '0';
				NS_cross <= '1';
				EW_cross <= '0';
				states <= "0011";
				
--				EW_grn <= '0';
--				EW_ambr <= '0';
--				EW_red <= '1';
--				
--				NS_grn <='1';
--				NS_ambr <='0';
--				NS_red <='0';
		

         WHEN S4 =>	
			
				NS_light <= "0001000";
				EW_light <= "0000001";
				clr_NS <= '0';
				clr_EW <= '0';
				NS_cross <= '1';
				EW_cross <= '0';
				states <= "0100";
				
--				EW_grn <= '0';
--				EW_ambr <= '0';
--				EW_red <= '1';
--				
--				NS_grn <='1';
--				NS_ambr <='0';
--				NS_red <='0';

         WHEN S5 =>	
			
				NS_light <= "0001000";
				EW_light <= "0000001";
				clr_NS <= '0';
				clr_EW <= '0';
				NS_cross <= '1';
				EW_cross <= '0';
				states <= "0101";
				
--				EW_grn <= '0';
--				EW_ambr <= '0';
--				EW_red <= '1';
--				
--				NS_grn <='1';
--				NS_ambr <='0';
--				NS_red <='0';

				
         WHEN S6 =>	
			
				NS_light <= "1000000";
				EW_light <= "0000001";
				clr_NS <= '1';														-- clear NS holding register after reaching S6
				clr_EW <= '0';
				NS_cross <= '0';
				EW_cross <= '0';
				states <= "0110";
				
--				EW_grn <= '0';
--				EW_ambr <= '0';
--				EW_red <= '1';
--				
--				NS_grn <='0';
--				NS_ambr <='1';
--				NS_red <='0';
				
         WHEN S7 =>	
			
				NS_light <= "1000000";
				EW_light <= "0000001";
				clr_NS <= '0';
				clr_EW <= '0';
				NS_cross <= '0';
				EW_cross <= '0';
				states <= "0111";
				
--				EW_grn <= '0';
--				EW_ambr <= '0';
--				EW_red <= '1';
--				
--				NS_grn <='0';
--				NS_ambr <='1';
--				NS_red <='0';
				
			WHEN S8 =>	
			
				NS_light <= "0000001";
				EW_light <= ("0001000" AND ("000" & blink & "000")); -- blinking green
				clr_NS <= '0';
				clr_EW <= '0';
				NS_cross <= '0';
				EW_cross <= '0';
				states <= "1000";
				
--				IF (blink='1') THEN
--					EW_grn <= '1';
--				ELSE
--					EW_grn <= '0';
--				END IF;
--				
--				EW_ambr <= '0';
--				EW_red <= '0';
--				
--				Ns_grn <= '0';
--				NS_ambr <= '0';
--				NS_red <= '1';
				
				
			WHEN S9 =>	
			
				NS_light <= "0000001";
				EW_light <= ("0001000" AND ("000" & blink & "000")); -- blinking green 
				clr_NS <= '0';
				clr_EW <= '0';
				NS_cross <= '0';
				EW_cross <= '0';
				states <= "1001";
				
--				IF (blink='1') THEN
--					EW_grn <= '1';
--				ELSE
--					EW_grn <= '0';
--				END IF;
--				
--				EW_ambr <= '0';
--				EW_red <= '0';
--				
--				Ns_grn <= '0';
--				NS_ambr <= '0';
--				NS_red <= '1';
			
			WHEN S10 =>	
			
				NS_light <= "0000001";
				EW_light <= "0001000";
				clr_NS <= '0';
				clr_EW <= '0';
				NS_cross <= '0';
				EW_cross <= '1';													-- EW crossing signal ON at EW solid green light
				states <="1010";
				
--				EW_grn <= '1';
--				EW_ambr <= '0';
--				EW_red <= '0';
--				
--				NS_grn <='0';
--				NS_ambr <='0';
--				NS_red <='1';
			
				
         WHEN S11 =>		
				
				NS_light <= "0000001";
				EW_light <= "0001000";
				clr_NS <= '0';
				clr_EW <= '0';
				NS_cross <= '0';
				EW_cross <= '1';
				states <="1011";
				
--				EW_grn <= '1';
--				EW_ambr <= '0';
--				EW_red <= '0';
--				
--				NS_grn <='0';
--				NS_ambr <='0';
--				NS_red <='1';
				
				
			WHEN S12 =>	
			
				NS_light <= "0000001";
				EW_light <= "0001000";
				clr_NS <= '0';
				clr_EW <= '0';
				NS_cross <= '0';
				EW_cross <= '1';
				states <="1100";
				
--				EW_grn <= '1';
--				EW_ambr <= '0';
--				EW_red <= '0';
--				
--				NS_grn <='0';
--				NS_ambr <='0';
--				NS_red <='1';
				
				
			WHEN S13 =>	
			
				NS_light <= "0000001";
				EW_light <= "0001000";
				clr_NS <= '0';
				clr_EW <= '0';
				NS_cross <= '0';
				EW_cross <= '1';
				states <="1101";
				
--				EW_grn <= '1';
--				EW_ambr <= '0';
--				EW_red <= '0';
--				
--				NS_grn <='0';
--				NS_ambr <='0';
--				NS_red <='1';
			
			WHEN S14 =>	
			
				NS_light <= "0000001";
				EW_light <= "1000000";
				clr_NS <= '0';
				clr_EW <= '1';												-- clear EW holding register after reaching S14
				NS_cross <= '0';
				EW_cross <= '0';
				states <="1110";
				
--				EW_grn <= '0';
--				EW_ambr <= '1';
--				EW_red <= '0';
--				
--				NS_grn <='0';
--				NS_ambr <='0';
--				NS_red <='1';
			
			
			WHEN S15 =>	
			
				NS_light <= "0000001";
				EW_light <= "1000000";
				clr_NS <= '0';
				clr_EW <= '0';
				NS_cross <= '0';
				EW_cross <= '0';
				states <="1111";
				
--				EW_grn <= '0';
--				EW_ambr <= '1';
--				EW_red <= '0';
--				
--				NS_grn <='0';
--				NS_ambr <='0';
--				NS_red <='1';
		
	  END CASE;
 END PROCESS;

 END ARCHITECTURE SM;
