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

BEGIN

seq: PROCESS(clk, rst) BEGIN
	IF(rst = '1') THEN
		currentState <= idle;
		quotient <= (OTHERS => '0');
		reminder <= (OTHERS => '0');
		value <= (OTHERS => '0');
	ELSIF(rising_edge(clk)) THEN
		currentState <= nextState;
		quotient <= nextQuotient;
		reminder <= nextReminder;
		value <= nextValue;
	END IF;
END PROCESS;

comb: PROCESS(currentState, start, x, y, value, quotient) BEGIN
	nextState <= currentState;
	nextValue<= value;
	nextQuotient <= quotient;
	nextReminder <= reminder;
	ready <= '0';
	
	CASE currentState IS
		WHEN idle =>
		nextQuotient <= (OTHERS => '0');
		nextReminder <= (OTHERS => '0');
		nextValue <= (OTHERS => '0');
			IF(start = '1') THEN
				nextState <= compute;
				nextValue <= x;
			ELSE
				nextState <= idle;
			END IF;
		WHEN compute =>
			IF(unsigned(value) >= unsigned(y)) THEN
				nextValue <= std_logic_vector(unsigned(value) - unsigned(y));
				nextQuotient <= std_logic_vector(unsigned(quotient) +1); 
				nextState <= compute;
			ELSE
				nextReminder <= value;
				nextState <= s_end;
			END IF;
		WHEN s_end =>
			ready <= '1';
			nextState <= idle;
		WHEN OTHERS =>
			nextState <= idle;
	END CASE;
END PROCESS;

	q <= quotient;
	r <= reminder;
END behav;