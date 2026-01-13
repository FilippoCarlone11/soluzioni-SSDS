LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY HLSM IS
	PORT ( clk, rst, start: IN std_logic;
		data_out : OUT std_logic);
END HLSM;

ARCHITECTURE behav OF HLSM IS
	TYPE stateType IS (idle, working);
	SIGNAL cnt, next_cnt : std_logic_vector(2 DOWNTO 0);
	SIGNAL enable_counter, end_counter, reset_counter : std_logic;
	SIGNAL currentState, nextState : stateType;
BEGIN
	controllerSeq: PROCESS( clk) BEGIN
		IF (rising_edge(clk)) THEN
			IF (rst = '1') THEN
				currentState <= idle;
			ELSE
				currentState <= nextState;
			END IF;
		END IF;
	END PROCESS;

	controllerComb: PROCESS(currentState, start) BEGIN
		nextState <= currentState;
		data_out <= '0';
		enable_counter <= '0';
		reset_counter <= '0';
		CASE currentState IS
			WHEN idle =>
				reset_counter <= '1';
				IF(start = '1') THEN
					nextState <= working;
				ELSE
					nextState <= idle;
				END IF;
			WHEN working =>
				enable_counter <= '1';
				IF(end_counter = '1') THEN
					IF (start = '1') THEN
						reset_counter <= '1';
						nextState <= working;
					ELSE
						nextState <= idle;
					END IF;
				END IF;
		END CASE;
	END PROCESS;

	datapathSeq: PROCESS(clk) BEGIN
		IF (rising_edge(clk)) THEN
			IF (rst = '1') THEN
				cnt <= (OTHERS => '0');
			ELSE
				cnt <= next_cnt;
			END IF;
		END IF;
	END PROCESS;

	datapathComb: PROCESS(cnt, enable_counter, reset_counter) BEGIN
		next_cnt <= cnt; 
		end_counter <= '0';
		IF(cnt = "111") THEN
			end_counter <= '1';
		END IF;

		IF (reset_counter = '1') THEN 
			next_cnt <= (OTHERS => '0');
		ELSIF(enable_counter = '1') THEN
			next_cnt <= std_logic_vector(unsigned(cnt) + 1);
		END IF;
		
	END PROCESS;
	
	data_out <= NOT cnt(0) WHEN (currentState = working) ELSE '0';
END behav;