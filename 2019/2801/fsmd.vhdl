LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY pell IS
PORT(	clk, rst, start : IN std_logic;
	n : IN std_logic_vector(2 DOWNTO 0);
	ready : OUT std_logic;
	P : OUT std_logic_vector(7 DOWNTO 0)
);
END pell;

ARCHITECTURE behav OF pell IS
	TYPE stateType IS (idle, compute, solved);
	SIGNAL currentState, nextState : stateType;
	SIGNAL p0, p1, nextP0, nextP1 : std_logic_vector( 7 DOWNTO 0);
	SIGNAL cnt, nextCnt : std_logic_vector(3 DOWNTO 0);
	SIGNAL clear, enable_cnt, cnt_max, ready_p : std_logic;

BEGIN
	seqContr: PROCESS(clk, rst) BEGIN
		IF(rst = '1') THEN
			currentState <= idle;
		ELSIF(rising_edge(clk)) THEN
			currentState <= nextState;
		END IF;
	END PROCESS;

	combController: PROCESS(currentState, start, n, cnt_max) BEGIN 
		nextState <= currentState;
		ready <= '0';
		enable_cnt <= '0';
		clear <= '0';
		ready_p <= '0';
		
		CASE currentState IS
			WHEN idle =>
				clear <= '1';
				IF(start = '1') THEN
					nextState <= compute;
				ELSE
					nextState <= idle;
				END IF;
			WHEN compute =>
				enable_cnt <= '1';

				IF(cnt_max = '1') THEN
					nextState <= solved;
				ELSE
					nextState <= compute;
				END IF;
			WHEN solved =>	
				nextState <= idle;
				ready <= '1';
				ready_p <= '1';
		END CASE;

		
	END PROCESS;

	PROCESS(ready_p, p1) BEGIN
		IF(ready_p = '1') THEN
			P <= p1;
		ELSE
			P <= (OTHERS => '0');
		END IF;
	END PROCESS;

	seqDatapath: PROCESS(clk, rst) BEGIN
		IF(rst = '1') THEN
			cnt <= (OTHERS => '0');
			p0 <= (OTHERS => '0');
			p1 <= (OTHERS => '0');
		ELSIF(rising_edge(clk)) THEN
			IF(clear = '1') THEN
				cnt <= std_logic_vector(to_unsigned(1, 4));
				p0 <= (OTHERS => '0');
				p1 <= std_logic_vector(to_unsigned(1, 8));
			ELSE
				cnt <= nextCnt;
				p0 <= nextP0;
				p1 <= nextP1;
			END IF;
		END IF;
	END PROCESS;

	combDatapath: PROCESS(clear, enable_cnt, cnt, n, p1, p0) BEGIN
		cnt_max <= '0';
		nextCnt <= cnt;
		nextP0 <= p0;
		nextP1 <= p1;

		IF(enable_cnt = '1') THEN
			nextCnt <= std_logic_vector(unsigned(cnt)+1);
			nextP0 <= p1;
			nextP1 <= std_logic_vector(resize(2*unsigned(p1)+unsigned(p0),8));
		END IF;
		
		IF(unsigned(cnt) < unsigned(n)) THEN
			cnt_max <= '0';		
		ELSE
			cnt_max <= '1';
		END IF;
		
	END PROCESS;

	
END behav;