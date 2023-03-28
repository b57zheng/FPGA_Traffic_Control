library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

Entity State_Machine IS Port
(
 clk_input, reset, enable			: IN std_logic; 							-- clock, reset and clock enable
 NS_hold_state, EW_hold_state		: IN std_logic; 							-- holding states for NS and EW
 blink									: IN std_logic; 							-- blinking lights signal
 
 NS_cross, EW_cross					: OUT std_logic;
 grn_NS, red_NS, ambr_NS			: OUT std_logic;							-- green, red and amber lights for NS
 grn_EW, red_EW, ambr_EW			: OUT std_logic;							-- green, red and amber lights for NS
 
 clr_NS, clr_EW						: OUT std_logic; 							-- clears signals for NS and EW
 states									: OUT std_logic_vector(3 downto 0); -- 4 bit output of states
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
		ELSIF (reset = '0' AND enable ='1') THEN			-- when enable is on update current state to next state
			current_state <= next_State;
		END IF;
	END IF;
END PROCESS;	



-- TRANSITION LOGIC PROCESS

Transition_Section: PROCESS (I0, I1, I2, current_state) 

BEGIN
  CASE current_state IS
	
        WHEN S0 =>		
				IF(I0='1') THEN
					next_state <= S1;
					current_state <= GFLASH;
					
				ELSE
					next_state <= S0;
				END IF;

         WHEN S1 =>	-- current_state is still GFLASH	
					next_state <= S2; 
		

         WHEN S2 =>		
				IF ((I0='1')) THEN
					next_state <= S6;
				ELSIF(I1='1') THEN
					next_state <= S3;
				ELSE
					next_state <= S2;
				END IF;
				
         WHEN S3 =>		
				IF(I0='1') THEN
					next_state <= S4;
				ELSE
					next_state <= S3;
				END IF;

         WHEN S4 =>		
					next_state <= S5;

         WHEN S5 =>		
					next_state <= S6;
				
         WHEN S6 =>		
				IF(I0='1') THEN
					next_state <= S7;
				ELSE
					next_state <= S6;
				END IF;
				
         WHEN S7 =>		
				IF(I2='1') THEN
					next_state <= S0;
				ELSE
					next_state <= S7;
				END IF;

				WHEN OTHERS =>
               next_state <= S0;
	  END CASE;
 END PROCESS;
 

-- DECODER SECTION PROCESS (MOORE FORM SHOWN)

Decoder_Section: PROCESS (current_state) 

BEGIN
     CASE current_state IS
	  
         WHEN S0 =>		
				IF(blink ='1') THEN
					grn_NS <='1';
				ELSE
					grn_NS <='0';
				END IF;
				
				red_NS <= '0';
				ambr_NS <= '0';
				NS_cross <= '0';
				
				states <="0000";
				clr_NS <= '0';
			
         WHEN S1 =>		
				IF(blink ='1') THEN
					grn_NS <='1';
				ELSE
					grn_NS <='0';
				END IF;
				
				red_NS <= '0';
				ambr_NS <= '0';
				NS_cross <= '0';
				
				states <="0001";
				clr_NS <= '0';
			

         WHEN S2 =>		
				IF(blink ='1') THEN
					grn_NS <='0';
				ELSE
					grn_NS <='1';
				END IF;
				
				red_NS <= '0';
				ambr_NS <= '0';
				NS_cross <= '0';
				
				states <="0010";
				clr_NS <= '0';
			
         WHEN S3 =>		
				IF(blink ='1') THEN
					grn_NS <='0';
				ELSE
					grn_NS <='1';
				END IF;
				
				red_NS <= '0';
				ambr_NS <= '0';
				NS_cross <= '0';
				
				states <="0011";
				clr_NS <= '0';

         WHEN S4 =>		
				IF(blink ='1') THEN
					grn_NS <='0';
				ELSE
					grn_NS <='1';
				END IF;
				
				red_NS <= '0';
				ambr_NS <= '0';
				NS_cross <= '0';
				
				states <="0100";
				clr_NS <= '0';

         WHEN S5 =>		
				IF(blink ='1') THEN
					grn_NS <='0';
				ELSE
					grn_NS <='1';
				END IF;
				
				red_NS <= '0';
				ambr_NS <= '0';
				NS_cross <= '0';
				
				states <="0101";
				clr_NS <= '0';

				
         WHEN S6 =>		
				grn_NS <= '0'
				red_NS <= '0';
				ambr_NS <= '1';
				NS_cross <= '0';
				
				states <="0110";
				clr_NS <= '0';
				
         WHEN S7 =>		
				grn_NS <= '0'
				red_NS <= '0';
				ambr_NS <= '1';
				NS_cross <= '0';
				
				states <="0111";
				clr_NS <= '0';
				
			WHEN S8 =>		
				grn_NS <= '0'
				red_NS <= '1';
				ambr_NS <= '0';
				NS_cross <= '0';
				
				states <="1000";
				clr_NS <= '0';
				
			WHEN S9 =>		
				grn_NS <= '0'
				red_NS <= '1';
				ambr_NS <= '0';
				NS_cross <= '0';
				
				states <="1001";
				clr_NS <= '0';
			
			WHEN S10 =>		
				grn_NS <= '0'
				red_NS <= '1';
				ambr_NS <= '0';
				NS_cross <= '0';
				
				states <="1010";
				clr_NS <= '0';
				
         WHEN others =>		
 			output1 <= '0';
			output2 <= '0';
	  END CASE;
 END PROCESS;

 END ARCHITECTURE SM;
