LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY hlsm IS 
PORT (	start, clk, rst: IN std_logic;
	order: IN std_logic_vector(3 DOWNTO 0);
	ready: OUT std_logic;
	data_out : OUT std_logic_vector(9 DOWNTO 0)
);
END hlsm;

ARCHITECTURE behav OF hlsm IS
	TYPE stateType IS (idle, compute, end_pr);
	SIGNAL currentState, nextState : stateType;
	SIGNAL fib1, fib2, new_fib1, new_fib2 : std_logic_vector(9 DOWNTO 0);
	SIGNAL cnt, new_cnt : std_logic_vector(3 DOWNTO 0);
BEGIN
	seqLogic: PROCESS(clk, rst) BEGIN
		IF(rst = '1') THEN
			currentState <= idle;
			fib1 <= (OTHERS => '0');
			fib2 <= std_logic_vector(to_unsigned(1, 10));
			cnt <= std_logic_vector(to_unsigned(1, 4));
		ELSIF (rising_edge(clk)) THEN
			currentState <= nextState;
			fib1 <= new_fib1;
			fib2 <= new_fib2;
			cnt <= new_cnt;
		END IF;
	END PROCESS;

	combLogic: PROCESS(currentState, start, cnt, order, fib1, fib2) BEGIN
		nextState <= currentState;
		new_fib1 <= fib1;
		new_fib2 <= fib2;
		new_cnt <= cnt;
		ready <= '0';
		data_out <= (OTHERS => '0');

		CASE currentState IS
			WHEN idle =>
				new_fib1 <= (OTHERS => '0');
				new_fib2 <= std_logic_vector(to_unsigned(1, 10));
				new_cnt <= std_logic_vector(to_unsigned(1, 4));
				IF (start = '1') THEN
					nextState <= compute;
				ELSE
					nextState <= idle;
				END IF;
			WHEN compute =>
				new_cnt <= std_logic_vector(unsigned(cnt) +1);
				IF (unsigned(cnt) < unsigned(order)) THEN
					new_fib1 <= fib2;
					new_fib2 <= std_logic_vector(unsigned(fib1) + unsigned(fib2));
					nextState <= compute;
				ELSE
					nextState <= end_pr;
				END IF;
			WHEN end_pr =>
				ready <= '1';
				data_out <= fib2;
				nextState <= idle;
		END CASE;
	END PROCESS;

END ARCHITECTURE;


