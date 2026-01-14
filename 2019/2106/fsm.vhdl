LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY machine IS
PORT (	rst, clk, start, stop : IN std_logic;
	run : OUT std_logic
);
END machine;

ARCHITECTURE point2 OF machine IS
TYPE stateType IS (idle, running);
SIGNAL currentState, nextState : stateType;

BEGIN

seqProc: PROCESS(clk, rst) BEGIN
	IF(rst ='1') THEN
		currentState <= idle;
	ELSIF(rising_edge(clk)) THEN
		currentState <= nextState;
	END IF;
END PROCESS;

combProcess: PROCESS(currentState, start, stop) BEGIN
	nextState	<= currentState;
	run <= '0';
	CASE currentState IS
		WHEN idle =>
			IF(start = '1') THEN
				nextState <= running;
			ELSE
				nextState <= idle;
			END IF;
		WHEN running =>
			run <= '1';
			IF(stop = '1') THEN
				nextState <= idle;
			ELSE
				nextState <= running;
			END IF;
	END CASE;
END PROCESS;
END point2;


ARCHITECTURE point3 OF machine IS
TYPE stateType IS (idle, running);
SIGNAL currentState : stateType;

BEGIN
PROCESS(clk, rst) BEGIN
	IF(rst ='1') THEN
		currentState <= idle;
		run <= '0';
	ELSIF(rising_edge(clk)) THEN
		run <= '0';
		CASE currentState IS
			WHEN idle =>
				IF(start = '1') THEN
					currentState <= running;
				ELSE
					currentState <= idle;
				END IF;
			WHEN running =>
				run <= '1';
				IF(stop = '1') THEN
					currentState <= idle;
				ELSE
					currentState <= running;
				END IF;
		END CASE;
	END IF;
	
	
END PROCESS;
END point3;

ARCHITECTURE point4 OF machine IS
TYPE stateType IS (idle, running);
SIGNAL currentState : stateType;

BEGIN
PROCESS(clk, rst) BEGIN
	

	IF(rst ='1') THEN
		currentState <= idle;
		run <= '0';
	ELSIF(rising_edge(clk)) THEN
		run <= '0';
		CASE currentState IS
		WHEN idle =>
			IF(start = '1') THEN
				currentState <= running;
				run <= '1';
			ELSE
				currentState <= idle;
			END IF;
		WHEN running =>
			run <= '1';
			IF(stop = '1') THEN
				currentState <= idle;
				run <= '0';
			ELSE
				currentState <= running;
			END IF;
	END CASE;
	END IF;
	
	
END PROCESS;
END point4;

