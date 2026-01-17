LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY unit IS
PORT(	Inp, memory_output : IN std_logic_vector(15 DOWNTO 0);
	go, clk, rst : IN std_logic;
	memory_en, finish : OUT std_logic;
	counter : OUT std_logic_vector( 10 DOWNTO 0);
	memory_address : OUT std_logic_vector(9 DOWNTO 0)
);
END unit;


ARCHITECTURE hlsm OF unit IS
TYPE stateType IS (idle, access, achieved_val, result);
SIGNAL currentState, nextState : stateType;
SIGNAL eq, next_eq : std_logic_vector (10 DOWNTO 0);
SIGNAL address, next_address : unsigned(10 DOWNTO 0);

BEGIN

seq: PROCESS(clk) BEGIN
	IF(rising_edge(clk)) THEN
		IF(rst ='1') THEN
			currentState <= idle;
			eq <= (OTHERS => '0');
			address <= (OTHERS => '0');
		ELSE
			currentState <= nextState;
			eq <= next_eq;
			address <= next_address;
		END IF;
	END IF;
END PROCESS;

comb: PROCESS(currentState, Inp, memory_output, go, eq, address) 
BEGIN
	nextState <= currentState;
	next_eq <= eq;
	next_address <= address;
	memory_address <= (OTHERS => '0');
	memory_en <= '0';
	finish <= '0';
        counter <= std_logic_vector(eq);

	CASE currentState IS
		WHEN idle =>
			next_eq <= (others => '0');
                	next_address <= (others => '0');
			IF(go ='1') THEN
				nextState <= access;
			ELSE
				nextState <= idle;
			END IF;
		WHEN access =>  
			memory_address <= std_logic_vector(address(9 DOWNTO 0));
			memory_en <= '1';
			nextState <= achieved_val;
		WHEN achieved_val =>
			next_address <= address + 1;
			IF(unsigned(memory_output) = unsigned(Inp)) THEN
				next_eq <= std_logic_vector(unsigned(eq) + 1);
			END IF;
			IF(address = 1023) THEN
				nextState <= result;
			ELSE
				nextState <= access;
			END IF; 
		WHEN result =>
			finish <= '1';
			counter <= eq;
		WHEN OTHERS =>
			nextState <= idle;

	END CASE;


END PROCESS;


END hlsm;