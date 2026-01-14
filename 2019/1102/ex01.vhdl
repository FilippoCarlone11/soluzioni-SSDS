LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY adder IS
PORT (	a, b: IN std_logic_vector(1 DOWNTO 0);
	sum : OUT std_logic_vector(1 DOWNTO 0);
	carry : OUT std_logic
);
END adder;

ARCHITECTURE behav OF adder IS
BEGIN
	sum <= "00" WHEN (a = "00" and b = "00") or (a = "01" and b = "10") or (a = "10" and b = "01") ELSE
		"01" WHEN (a = "00" and b = "01") or (a = "01" and b = "00") or (a = "10" and b = "10") ELSE
		"10" WHEN (a = "00" and b = "10") or (a = "01" and b = "01") or (a = "10" and b = "00") ELSE
		"00";

	carry <= 	'1' WHEN (a = "01" AND b = "10") OR (a = "10" AND b = "01") OR (a = "10" AND b = "10") ELSE
			'0';
		
END behav;

ARCHITECTURE behav2 OF adder IS
	SIGNAL conc : std_logic_vector(3 DOWNTO 0);
BEGIN
	conc <= a & b;

	WITH conc SELECT sum <=
		"00" WHEN "0000",
		"01" WHEN "0001",
		"10" WHEN "0010",
		"01" WHEN "0100",
		"10" WHEN "0101",
		"00" WHEN "0110",
		"10" WHEN "1000",
		"00" WHEN "1001",
		"01" WHEN "1010",
		"00" WHEN OTHERS;

	WITH conc SELECT carry <=
		'1' WHEN "0110" | "1001" | "1010",
		'0' WHEN OTHERS;



END behav2;