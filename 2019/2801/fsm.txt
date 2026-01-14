LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY recognizer IS 
PORT(	en, x, rst, clk: IN std_logic;
	z: OUT std_logic_vector(1 DOWNTO 0)
);
END recognizer;

ARCHITECTURE behav OF recognizer IS
	TYPE stateType IS (idle, get1,get11, get0);
	SIGNAL currentState, nextState : stateType;
BEGIN

	seqProc: PROCESS(clk) BEGIN
		IF(rising_edge(clk)) THEN
			IF(rst ='1') THEN
				currentState <= idle;
			ELSE
				currentState <= nextState;
			END IF;
		END IF;
	END PROCESS;

	combProc: PROCESS(currentState, en, x) BEGIN
		nextState <= currentState;
		z <= (OTHERS => '0');

		IF(en = '0') THEN
			nextState <= idle;
		ELSE
		CASE currentState IS
			WHEN idle =>
				z <= (OTHERS => '0');
				IF(x = '1') THEN
					nextState <= get1;
				ELSE
					nextState <= get0;
				END IF;
			
			WHEN get1 =>
				IF(x = '1') THEN
					nextState <= get11;
				ELSE
					nextState <= get0;
				END IF;
			WHEN get11 =>
				IF(x = '1') THEN
					nextState <= get11;
					z <= "10";
				ELSE
					nextState <= get0; 
				END IF;
			WHEN get0 =>
				IF(x = '1') THEN
					nextState <= get1;
				ELSE
					nextState <= get0; 
					z <= "01";
				END IF;
			END CASE;
		END IF;
		
	END PROCESS;

END behav;