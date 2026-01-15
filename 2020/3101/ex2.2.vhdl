LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY fsm IS 
PORT( 	clk, bi, rst: IN std_logic;
	bo : OUT std_logic
);
END fsm;

ARCHITECTURE behav OF fsm IS
TYPE stateType IS(idle, pressed, s_wait);
SIGNAL currentState, nextState : stateType;
BEGIN

seq: PROCESS(clk) BEGIN
	IF(rising_edge(clk)) THEN
		IF(rst = '1') THEN
			currentState <= idle;
		ELSE
			currentState <= nextState;
		END IF;
	END IF;
END PROCESS;

comb: PROCESS(currentState, bi) BEGIN
	nextState <= currentState;
	bo <= '0';

	CASE currentState IS
		WHEN idle =>
			bo <= '0';
			IF(bi = '1') THEN
				nextState <= pressed;
			ELSE
				nextState <= idle;
			END IF;
		WHEN pressed =>
			bo <= '1';
			nextState <= s_wait;
		WHEN s_wait =>
			bo <= '0';
			IF(bi = '1') THEN
				nextState <= s_wait;
			ELSE
				nextState <= idle;
			END IF;
	END CASE;

END PROCESS;


END behav;