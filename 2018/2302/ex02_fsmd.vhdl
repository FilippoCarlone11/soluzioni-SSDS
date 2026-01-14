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
	SIGNAL clear, cnt_enable, cnt_max, enable_calc: std_logic;

BEGIN
	seqController: PROCESS(clk, rst) BEGIN
		IF( rst = '1') THEN
			currentState <= idle;
		ELSIF(rising_edge(clk)) THEN
			currentState <= nextState;
		END IF;
	END  PROCESS;
	
	combController: PROCESS(currentState, start, cnt_max) BEGIN
		nextState <= currentState;
		ready <= '0';

		clear <= '0';
		cnt_enable <= '0';
		enable_calc <= '0'; 
		CASE currentState IS
			WHEN idle =>
				clear <= '1';
				IF (start = '1') THEN
					nextState <= compute;
				ELSE
					nextState <= idle;
				END IF;
			WHEN compute =>
				cnt_enable <= '1';
				IF(cnt_max = '1') THEN
					nextState <= end_pr;
				ELSE
					nextState<= compute;
					enable_calc <= '1';
				END IF;
					
			WHEN end_pr =>
				ready <= '1';
				nextState <= idle;
		END CASE;
	END  PROCESS;

	outputProc: PROCESS(currentState, fib2)
    	BEGIN
        	ready <= '0';
        	data_out <= (OTHERS => '0');

        	IF (currentState = end_pr) THEN
            		ready <= '1';
            		data_out <= fib2;
        	END IF;
    	END PROCESS;
	
	seqDatapath: PROCESS(clear, clk) BEGIN
		
		IF(rising_edge(clk)) THEN
			IF( clear = '1') THEN
				cnt <= std_logic_vector(to_unsigned(1, 4));
				fib1 <= (OTHERS => '0');
				fib2 <= std_logic_vector(to_unsigned(1, 10));
			ELSE
				cnt <= new_cnt;
				fib1 <= new_fib1;
				fib2 <= new_fib2;
			END IF;
		END IF;
	END  PROCESS;

	combDatapath: PROCESS(enable_calc, cnt_enable, cnt, order, fib1, fib2) BEGIN
		new_fib2 <= fib2;
		new_fib1 <= fib1;
		new_cnt <= cnt;
		cnt_max <= '0';
		
		IF(enable_calc = '1') THEN
			new_fib2 <= std_logic_vector(unsigned(fib1) + unsigned(fib2));
			new_fib1 <= fib2;
		END IF;

		IF (cnt_enable = '1') THEN
			new_cnt <= std_logic_vector(unsigned(cnt)+1);
		END IF;

		IF(unsigned(cnt) < unsigned(order)) THEN
			cnt_max <= '0';
		ELSE
			cnt_max <= '1';
		END IF;
	END PROCESS;
END behav;