LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY fsm IS
PORT(	clk, rst, x: IN std_logic;
	u : OUT std_logic
);
END fsm;

ARCHITECTURE behav OF fsm IS
TYPE stateType IS (idle, S_0, S_01, S_010, S_0101, S_01011);
SIGNAL currentState, nextState : stateType;
BEGIN

seq: PROCESS(clk,rst) BEGIN
	IF(rst ='1') THEN
		currentState <= idle;
	ELSIF(rising_edge(clk)) THEN
		currentState <= nextState;
	END IF;
END PROCESS;

comb: PROCESS(currentState, x) BEGIN
	nextState <= currentState;
	u <= '0';
	CASE currentState IS
		WHEN idle =>
			IF(x = '1') THEN
				nextState <= idle;
			ELSE
				nextState <= S_0;
			END IF;
		WHEN S_0 =>
			IF(x = '1') THEN
				nextState <= S_01;
			ELSE
				nextState <= S_0;
			END IF;
		WHEN S_01 =>
			IF(x = '1') THEN
				nextState <= idle;
			ELSE
				nextState <= S_010;
			END IF;
		WHEN S_010 =>
			IF(x = '1') THEN
				nextState <= S_0101;
			ELSE
				nextState <= S_0;
			END IF;
		WHEN S_0101 =>
			IF(x = '1') THEN
				nextState <= S_01011;
			ELSE
				nextState <= S_010;
			END IF;
		WHEN S_01011 =>
			u <= '1';
			IF(x = '1') THEN
				nextState <= idle;
			ELSE
				nextState <= S_0;
			END IF;
		WHEN OTHERS =>
			nextState <= idle;
		END CASE;

END PROCESS;
END behav;