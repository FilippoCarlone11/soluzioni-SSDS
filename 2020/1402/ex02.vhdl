LIBRARY IEEE;

USE IEEE.STD_LOGIC_1164.ALL;

ENTITY fsm IS
PORT(	x, clk, rst : IN std_logic;
	z : OUT std_logic
);
END fsm;

ARCHITECTURE behav OF fsm IS
TYPE stateType IS (s1, s2, s3);
SIGNAL currentState, nextState : stateType;

BEGIN

seq: PROCESS(clk, rst) BEGIN
	IF(rst = '1') THEN
		currentState <= s1;
	ELSIF(rising_edge(clk)) THEN
		currentState <= nextState;
	END  IF;
END PROCESS;


comb: PROCESS(currentState, x) BEGIN
	nextState <= currentState;
	z <= '0';
	
	CASE currentState Is
		WHEN s1 =>
			z <= '0';
			IF(x = '1') THEN
				nextState <= s2;
			ELSE
				nextState <= s1;
			END IF;
		WHEN s2 =>
			z <= '0';
			IF(x = '1') THEN
				nextState <= s3;
			ELSE
				nextState <= s1;
			END IF;	
		WHEN s3 =>
			z <= '1';
			IF(x = '1') THEN
				nextState <= s3;
			ELSE
				nextState <= s1;
			END IF;	
		WHEN OTHERS =>
			nextState <= s1;
	END CASE;
END PROCESS;
END behav;