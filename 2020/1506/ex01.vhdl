LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY comb IS
PORT(	pressure: IN std_logic_vector(4 DOWNTO 0);
	t : out std_logic
);
END comb;

ARCHITECTURE behav OF comb IS
BEGIN

PROCESS(pressure) BEGIN
	IF(pressure(4) = '1') THEN
		t <= '0';
	ELSE
		t <= '1';
	END IF;

END PROCESS;

END behav;

ARCHITECTURE behav2 OF comb IS
BEGIN

PROCESS(pressure) BEGIN
	CASE pressure(4) IS
		WHEN '1' =>
			t <= '0';
		WHEN '0' =>
			t <= '1';
	END CASE;

END PROCESS;

END behav2;