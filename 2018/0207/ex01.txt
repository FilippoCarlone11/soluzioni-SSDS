LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY comb IS
PORT(	bcd : IN std_logic_vector(3 DOWNTO 0);
	output : OUT std_logic_vector(3 DOWNTO 0)
	);
END ENTITY;

ARCHITECTURE behav OF comb IS
BEGIN
	output <= 	"0000" WHEN bcd = "0000" ELSE
			"0111" WHEN bcd = "0001" ELSE
			"0110" WHEN bcd = "0010" ELSE
			"0101" WHEN bcd = "0011" ELSE
			"0100" WHEN bcd = "0100" ELSE
			"1011" WHEN bcd = "0101" ELSE
			"1010" WHEN bcd = "0110" ELSE
			"1001" WHEN bcd = "0111" ELSE
			"1000" WHEN bcd = "1000" ELSE
			"1111" WHEN bcd = "1001" ELSE "0000";
END behav;

ARCHITECTURE behav2 OF comb IS
BEGIN
	WITH bcd SELECT output <=
		"0000" WHEN "0000",
		"0111" WHEN "0001",
		"0110" WHEN "0010",
		"0101" WHEN "0011",
		"0100" WHEN "0100",
		"1011" WHEN "0101",
		"1010" WHEN "0110",
		"1001" WHEN "0111",
		"1000" WHEN "1000",
		"1111" WHEN "1001",
		"0000" WHEN OTHERS;
END behav2;