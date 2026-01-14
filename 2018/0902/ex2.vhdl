LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY FSM IS 
	PORT ( clk, rst, start : IN std_logic;
		data_out : OUT std_logic ));
END FSM;

ARCHITECTURE behav OF FSM IS
	TYPE stateType IS (idle, s1, s2, s3, s4, s5, s6, s7, s8);
	SIGNAL currentState, nextState : stateType;
	
BEGIN

	seqProc: PROCESS(clk) BEGIN
		IF (rising_edge(clk)) THEN
			IF (rst = '1') THEN
				currentState <= idle;
			ELSE
				currentState <= nextState;
			END IF;
		END IF;
	END PROCESS;

	combProc: PROCESS(currentState, start) BEGIN
		nextState <= currentState;
		data_out <= '0';
		CASE currentState IS
			WHEN idle =>
				IF (start = '1') THEN
					nextState <= s1;
				ELSE
					nextState <= idle;
				END IF;
			WHEN s1 =>
				data_out <= '1';
				nextState <= s2;
			WHEN s2 =>
				data_out <= '0';
				nextState <= s3;
			WHEN s3 =>
				data_out <= '1';
				nextState <= s4;
			WHEN s4 =>
				data_out <= '0';
				nextState <= s5;
			WHEN s5 =>
				data_out <= '1';
				nextState <= s6;
			WHEN s6 =>
				data_out <= '0';
				nextState <= s7;
			WHEN s7 =>
				data_out <= '1';
				nextState <= s8;
			WHEN s8 =>
				data_out <= '0';
				IF(start = '1') THEN  --allows multiple preamble
					nextState <= s1;
				ELSE
					nextState <= idle;
				END IF;
		END CASE;
	END PROCESS;

END behav;