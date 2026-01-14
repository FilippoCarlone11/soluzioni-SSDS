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


BEGIN

	seqProc: PROCESS(clk, rst) BEGIN
		IF(rst = '1') THEN
			currentState <= idle;
			cnt <= std_logic_vector(to_unsigned(1, 4));
			p0 <= (OTHERS => '0');
			p1 <= std_logic_vector(to_unsigned(1, 8));
		ELSIF(rising_edge(clk)) THEN
			currentState <= nextState;
			cnt <= nextCnt;
			p0 <= nextP0;
			p1 <= nextP1;
		END IF;
	END PROCESS;

	combProc: PROCESS(currentState, start, n, cnt, p0, p1) BEGIN
		nextState <= currentState;
		nextP0 <= p0;
		nextP1 <= p1;
		nextCnt <= cnt;
		ready <= '0';

		P <= (OTHERS => '0');
		CASE currentState IS
			WHEN idle =>
				nextCnt <= std_logic_vector(to_unsigned(1, 4));
				nextP0 <= (OTHERS => '0');
				nextP1 <= std_logic_vector(to_unsigned(1, 8));
				IF(start = '1') THEN
					nextState <= compute;
				ELSE
					nextState <= idle;
				END IF;
			WHEN compute =>
				IF(unsigned(cnt) < unsigned(n)) THEN
					nextCnt <= std_logic_vector(unsigned(cnt)+1);
					nextP0 <= p1;
					nextP1 <= std_logic_vector(resize(2*unsigned(p1)+unsigned(p0),8));
				ELSE
					nextState <= solved;
				END IF;
			WHEN solved =>	
				nextState <= idle;
				ready <= '1';
				P <= p1;
		END CASE;
		
	END PROCESS;

END behav;