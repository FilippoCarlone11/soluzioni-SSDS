LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY comb IS
PORT(	m: IN std_logic_vector(3 DOWNTO 0);
	C: OUT std_logic
);
END comb;

ARCHITECTURE behav OF comb IS
BEGIN
	PROCESS (m) BEGIN
		IF(m = "0001" OR m = "0010" OR m = "0100" OR m = "1000" OR m = "0000") THEN
			C <= '0';
		ELSE
			C <= '1';
		END IF;
	END PROCESS;

END behav;

ARCHITECTURE behav2 OF comb IS
BEGIN
	PROCESS (m) BEGIN
		CASE m IS
			WHEN "0001" | "0010" | "0100" | "1000" | "0000"=>
				C <= '0';
		WHEN OTHERS =>
			C <= '1';
		END CASE;
	END PROCESS;

END behav2;