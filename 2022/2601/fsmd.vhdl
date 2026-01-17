LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY hlsm IS
PORT(	clk, rst, start: IN std_logic;
	x, y : IN std_logic_vector(7 DOWNTO 0);
	q, r: OUT std_logic_vector(7 DOWNTO 0);
	ready : OUT std_logic);
END hlsm;

ARCHITECTURE behav OF hlsm IS
TYPE stateType IS (idle, compute, s_end);
SIGNAL currentState, nextState : stateType;
SIGNAL quotient, nextQuotient, reminder, nextReminder, value, nextValue : std_logic_vector(7 DOWNTO 0);
SIGNAL enable_calc,enable_reminder, enable_q, clear, load_value: std_logic;
BEGIN

seqContr: PROCESS(clk, rst) BEGIN
	IF(rst = '1') THEN
		currentState <= idle;
	ELSIF(rising_edge(clk)) THEN
		currentState <= nextState;
	END IF;
END PROCESS;

seqDatapath: PROCESS(clk, rst) BEGIN
	IF(rst = '1') THEN
		quotient <= (OTHERS => '0');
		reminder <= (OTHERS => '0');
		value <= (OTHERS => '0');
	ELSIF(rising_edge(clk)) THEN
			quotient <= nextQuotient;
			reminder <= nextReminder;
			value <= nextValue;

	END IF;
END PROCESS;


comb: PROCESS(currentState, start, enable_q) BEGIN
	nextState <= currentState;
	ready <= '0';
	enable_reminder <= '0';
	enable_calc <= '0';
	clear <= '0';
	
	CASE currentState IS
		WHEN idle =>
			clear <= '1';
			IF(start = '1') THEN
				nextState <= compute;
				load_value <= '1';
				
			ELSE
				nextState <= idle;
			END IF;
		WHEN compute =>
			IF(enable_q) THEN
				enable_calc <= '1';
				nextState <= compute;
			ELSE	
				enable_reminder <= '1';
				nextState <= s_end;
			END IF;
		WHEN s_end =>
			ready <= '1';
			nextState <= idle;
		WHEN OTHERS =>
			nextState <= idle;
	END CASE;
END PROCESS;

combDatapath: PROCESS(enable_calc, value, y, quotient, enable_reminder, x) BEGIN
	enable_q <= '0';
	nextValue<= value;
	nextQuotient <= quotient;
	nextReminder <= reminder;
	

	IF(enable_calc = '1') THEN
		nextValue <= std_logic_vector(unsigned(value) - unsigned(y));
		nextQuotient <= std_logic_vector(unsigned(quotient) +1); 
	END IF;

	IF(enable_reminder = '1') THEN
		nextReminder <= value;
	END IF;
	
	IF(unsigned(value) >= unsigned(y)) THEN
		enable_q <= '1';
	END IF;
	
	IF(load_value = '1') THEN
		nextValue <= x;
	END IF;
		
	IF(clear = '1') THEN
			nextQuotient <= (OTHERS => '0');
			nextReminder <= (OTHERS => '0');
			nextValue <= (OTHERS => '0');
	END IF;
	
END PROCESS;
	q <= quotient;
	r <= reminder;
END behav;