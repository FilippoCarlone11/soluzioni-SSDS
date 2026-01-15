LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY hlsm IS
PORT(	clk, rst : IN std_logic;
	temperature, threshold: IN std_logic_vector(15 DOWNTO 0);
	alarm : OUT std_logic);
END hlsm;

ARCHITECTURE behav OF hlsm IS
    TYPE stateType IS (idle, measure);
    SIGNAL currentState, nextState : stateType;
    
    SIGNAL t0, t1, t2, t3, next_t0, next_t1, next_t2, next_t3 : std_logic_vector(15 DOWNTO 0);
    SIGNAL shift_en, thr_on : std_logic;
BEGIN

seqContr: PROCESS(clk, rst) BEGIN
	IF(rst = '1') THEN
		currentState <= idle;
	ELSIF(rising_edge(clk)) THEN
		currentState <= nextState;
	END IF;
END PROCESS;

combContr : PROCESS(currentState) BEGIN
	nextState <= currentState;
	shift_en <= '0';

	CASE currentState IS 
		WHEN idle =>
			nextState <= measure;
		WHEN measure =>
			shift_en <= '1';
			nextState <= measure;	
		WHEN OTHERS =>
            		nextState <= idle;

	END CASE;

END PROCESS;


seqDatapath: PROCESS(clk, rst) BEGIN
	IF(rst = '1') THEN
            	t0 <= (OTHERS => '0');
            	t1 <= (OTHERS => '0');
            	t2 <= (OTHERS => '0');
            	t3 <= (OTHERS => '0');
	ELSIF(rising_edge(clk)) THEN
            	t0 <= next_t0;
            	t1 <= next_t1;
            	t2 <= next_t2;
            	t3 <= next_t3;
	END IF;
END PROCESS;

combDatapath: PROCESS(shift_en,t0, t1, t2, t3, temperature, threshold)
	VARIABLE v_sum : unsigned(17 DOWNTO 0);
    	VARIABLE v_avg : unsigned(15 DOWNTO 0);
BEGIN
	v_sum := (OTHERS => '0');
        v_avg := (OTHERS => '0');

	thr_on <= '0';
	next_t0 <= t0;
        next_t1 <= t1;
        next_t2 <= t2;
        next_t3 <= t3;

	IF(shift_en = '1') THEN
		next_t3 <= t2;
                next_t2 <= t1;
                next_t1 <= t0;
                next_t0 <= temperature; 
	END IF;

	v_sum := resize(unsigned(t0), 18) + 
                    resize(unsigned(t1), 18) + 
                    resize(unsigned(t2), 18) + 
                    resize(unsigned(temperature), 18);
    
    	v_avg := v_sum(17 DOWNTO 2);
	IF (v_avg > unsigned(threshold)) THEN
                    thr_on <= '1';
                ELSE
                    thr_on <= '0';
        END IF;

END PROCESS;

alarm <= thr_on;


END behav;