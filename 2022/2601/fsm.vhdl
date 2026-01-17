LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY fsm IS 
PORT(	clk, reset, comb1, comb2, enter : IN std_logic;
	unlock, error: OUT std_logic
);
END fsm;

ARCHITECTURE behav OF fsm IS
TYPE stateType IS (idle,S_firstlock,S_firstlock_safe, closed, open);
SIGNAL currentState, nextState : stateType;
BEGIN

seq: PROCESS(clk) BEGIN
	IF(rising_edge(clk)) THEN
		IF(reset = '1') THEN
			currentState <= idle;
		ELSE
			currentState <= nextState;
		END IF;
	END IF;
END PROCESS;


comb: PROCESS(currentState, comb1, comb2, enter) BEGIN
	nextState <= currentState;
	unlock <= '0';
	error <= '0';

	CASE currentState IS
		WHEN idle =>
			IF(enter = '1') THEN

				IF(comb1 = '1') THEN
					nextState <= S_firstlock_safe;
				ELSE
					nextState <= S_firstlock;
				END IF;	

			ELSE
				nextState <= idle;
			END IF;
		WHEN S_firstlock =>
			IF(enter = '1') THEN
				nextState <= closed;
			ELSE
				nextState <= S_firstlock;
			END IF;

		WHEN S_firstlock_safe =>
			IF(enter = '1') THEN
				IF(comb2 = '1') THEN
					nextState <= open;
				ELSE
					nextState <= closed;
				END IF;	
			ELSE
				nextState <= S_firstlock_safe;
			END IF;
		WHEN closed =>
			error <= '1';
		WHEN open =>
			unlock <= '1';
		WHEN OTHERS =>
			nextState <= idle;
	END CASE;
END PROCESS;
END behav;

