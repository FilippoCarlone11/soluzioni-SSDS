LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY calc IS
PORT(	clk, rst, start : IN std_logic;
	x : IN std_logic_vector(15 DOWNTO 0);
	done : OUT std_logic;
	l : OUT std_logic_vector(3 DOWNTO 0)
);
END calc;

ARCHITECTURE behav OF calc IS 
TYPE stateType IS (idle, compute, finish);
SIGNAL currentState, nextState : stateType;
SIGNAL reg, nextReg : std_logic_vector (15 DOWNTO 0);
SIGNAL cnt, nextCnt : std_logic_vector (3 DOWNTO 0);

BEGIN

seqProc: PROCESS(clk) BEGIN
	IF(rising_edge(clk)) THEN
		IF(rst = '1') THEN 
			currentState <= idle;
			cnt <= (OTHERS => '0');
			reg <= (OTHERS => '0');
		ELSE
			currentState <= nextState;
			cnt <= nextCnt;
			reg <= nextReg;
		END IF;
	END IF;
END PROCESS;

combProcess: PROCESS(currentState, start, x, reg, cnt) BEGIN
	nextState <= currentState;
	nextCnt <= cnt;
	nextReg <= reg;
	done <= '0';


	CASE currentState IS
		WHEN idle =>
			nextCnt <= (OTHERS => '0');
			nextReg <= std_logic_vector(to_unsigned(2, 16));
			IF(start = '1') THEN
				nextState <= compute;
			ELSE
				nextState <= idle;
			END IF;
		WHEN compute =>
			IF(unsigned(x) < unsigned(reg)) THEN
				nextState <= finish;
			ELSE
				nextReg <= reg(14 DOWNTO 0) & '0';
				nextCnt <= std_logic_vector(unsigned(cnt) +1 );
				nextState <= compute;
			END IF;
			
		WHEN finish =>
			done <= '1';
			nextState <= idle;
	END CASE;

END PROCESS;

	l <= cnt;

END behav;