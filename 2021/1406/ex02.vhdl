LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164;

ENTITY fsm IS
PORT(	x, rst, clk : IN std_logic;
	z : OUT std_logic
);
END fsm;


ARCHITECTURE behav OF fsm IS
TYPE stateType IS (idle, S_0, S_01, S_loop, S_011);
SIGNAL currentState, nextState : stateType;

BEGIN

seq: PROCESS(clk) BEGIN
	IF(rising_edge(clk)) THEN
		IF(rst ='1') THEN
			currentState <= idle;
		ELSE
			currentState <= nextState;
		END IF;
	END IF;
END PROCESS;

comb : PROCESS(currentState, x) BEGIN
	nextState <= currentState;
	z <= '0';

	CASE currentState IS
		WHEN idle =>
			IF( x = '1') THEN
				nextState <= idle;
			ELSE
				nextState <= S_0;
			END IF;
		WHEN S_0 =>
			IF( x = '1') THEN
				nextState <= S_01;
			ELSE
				nextState <= S_0;
			END IF;
		WHEN S_01 =>
			IF( x = '1') THEN
				nextState <= S_011;
			ELSE
				nextState <= S_loop;
			END IF;
		WHEN S_loop =>
			IF( x = '1') THEN
				nextState <= S_011
			ELSE
				nextState <= S_loop;
			END IF;
		WHEN S_011 =>
			z <= '1';
			IF( x = '1') THEN
				nextState <= idle;
			ELSE
				nextState <= S_0;
			END IF;
		
		WHEN OTHERS =>
			nextState <= idle;

	END CASE;
END PROCESS;

END behav;