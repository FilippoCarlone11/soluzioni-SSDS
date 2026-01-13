LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY hlsm IS 
PORT (	clk, rst, start : IN std_logic;
	n : IN std_logic_vector(2 DOWNTO 0);
	ready : OUT std_logic;
	data_out: OUT std_logic_vector(12 DOWNTO 0));
END hlsm;

ARCHITECTURE behav OF hlsm IS
	TYPE stateType IS (idle, compute, solve);
	SIGNAL currentState, nextState : stateType;
	SIGNAL cnt, nextCnt : std_logic_vector( 3 DOWNTO 0);
	SIGNAL fact, nextFact : std_logic_vector(12 DOWNTO 0);
BEGIN

	seqPart : PROCESS (clk, rst) BEGIN
		IF (rst  ='1') THEN
			currentState <= idle;
			fact <= (OTHERS => '0');
			cnt <= (OTHERS => '0');
		ELSIF(rising_edge(clk)) THEN
			currentState <= nextState;
			cnt <= nextCnt;
			fact <= nextFact;
		END IF;
	END PROCESS;

	combPart: PROCESS(currentState, start, cnt, n, fact) BEGIN
		data_out <= (OTHERS => '0');
		ready <= '0';
		nextState <= currentState;
		nextCnt <= cnt;
		nextFact <= fact;
		CASE currentState IS
			WHEN idle =>
				nextCnt <= std_logic_vector(to_unsigned(2, 4));
				nextFact <= std_logic_vector(to_unsigned(1, 13));
				IF (start = '1') THEN
					nextState <= compute;
				ELSE
					nextState <= idle;
				END IF;
			WHEN compute =>
				IF( unsigned(cnt) <= unsigned(n)) THEN
					nextFact <= std_logic_vector( resize(unsigned(fact) * unsigned(cnt), 13));
					nextCnt <= std_logic_vector(unsigned(cnt)+1);
					nextState <= compute;
				ELSE
					nextState <= solve;
				END IF;
			WHEN solve =>
				nextState <= idle;
				ready <= '1';
				data_out <= fact;
		END CASE;
	END PROCESS;


END behav;