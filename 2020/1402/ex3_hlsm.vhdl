LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY hlsm IS
PORT(	clk, rst, b, e, d: IN std_logic;
	i : IN std_logic_vector(15 DOWNTO 0);
	o : OUT std_logic_vector(15 DOWNTO 0)
);
END hlsm;

ARCHITECTURE behav OF hlsm IS
TYPE stateType IS (idle, compute);
SIGNAL currentState, nextState : stateType;
SIGNAL offset, next_offset, enc, next_enc : std_logic_vector(15 DOWNTO 0);
 
BEGIN

seqProc: PROCESS(rst, clk) BEGIN
	IF(rst = '1') THEN
		currentState <= idle;
		offset <= (OTHERS => '0');
		enc <= (OTHERS => '0');
	ELSIF(rising_edge(clk)) THEN
		currentState<= nextState;
		offset <= next_offset;
		enc <= next_enc;
	END IF;
END PROCESS;

combProc: PROCESS(currentState, b, e, d, i, offset, enc) BEGIN
	nextState <= currentState;
	next_offset <= offset;
	next_enc <= enc;

	CASE currentState IS
		WHEN idle =>
			nextState <= compute;

		WHEN compute =>
			IF(b = '1') THEN
				next_offset <= i;
				nextState <= compute;
			ELSIF(e = '1') THEN
				next_enc <= std_logic_vector(resize(signed(i)+signed(offset), 16));
				nextState <= compute;
			ELSIF(d = '1') THEN
				next_enc <= std_logic_vector(resize(signed(i)-signed(offset), 16));
				nextState <= compute;
			END IF;
		WHEN OTHERS =>
			nextState <= idle;
	END CASE;
END PROCESS;

	o <= enc;

END behav;