LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY fsm IS
PORT(x, clk, rst : IN std_logic;
	z : OUT std_logic
);
END fsm;

ARCHITECTURE moore OF fsm IS
TYPE stateType IS (S_000, S_001, S_010, S_011, S_100, S_101, S_110, S_111);
SIGNAL currentState, nextState : stateType;
BEGIN

seq: PROCESS(clk, rst) BEGIN
	IF(rst = '1') THEN
		currentState <= S_000;
	ELSIF(rising_edge(clk)) THEN
		currentState <= nextState;
	END IF;
END PROCESS;

comb: PROCESS(currentState, x) BEGIN
	nextState <= currentState;
	z <= '0';

	CASE currentState IS
		WHEN S_000 =>
			IF(x = '1') THEN
				nextState <= S_001;
			ELSE
				nextState <= S_000;
			END IF;
		WHEN S_001 =>
			IF(x = '1') THEN
				nextState <= S_011;
			ELSE
				nextState <= S_010;
			END IF;
		WHEN S_010 =>
			IF(x = '1') THEN
				nextState <= S_101;
			ELSE
				nextState <= S_100;
			END IF;
		WHEN S_011 =>
			IF(x = '1') THEN
				nextState <= S_111;
			ELSE
				nextState <= S_110;
			END IF;
		WHEN S_100 =>
			z <= '1';
			IF(x = '1') THEN
				nextState <= S_001;
			ELSE
				nextState <= S_000;
			END IF;
		WHEN S_101 =>
			z <= '1';
			IF(x = '1') THEN
				nextState <= S_011;
			ELSE
				nextState <= S_010;
			END IF;
		WHEN S_110 =>
			z <= '1';
			IF(x = '1') THEN
				nextState <= S_101;
			ELSE
				nextState <= S_100;
			END IF;
		WHEN S_111 =>
			z <= '1';
			IF(x = '1') THEN
				nextState <= S_111;
			ELSE
				nextState <= S_110;
			END IF;
		WHEN OTHERS =>
			nextState <= S_000;
	END CASE;

END PROCESS;
END moore;