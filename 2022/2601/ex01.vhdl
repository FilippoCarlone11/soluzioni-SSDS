LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY comb IS
PORT(	x: IN std_logic_vector(3 DOWNTO 0);
	y: OUT std_logic_vector(3 DOWNTO 0)
);
END comb;

ARCHITECTURE behav OF comb IS
BEGIN
	PROCESS(x) BEGIN
		IF(x = "0000") THEN y <= "0101";
		ELSIF(x = "0001") THEN y <= "0110";
		ELSIF(x = "0010") THEN y <= "0111";
		ELSIF(x = "0011") THEN y <= "1000";
		ELSIF(x = "0100") THEN y <= "1001";
		ELSIF(x = "0101") THEN y <= "1010";
		ELSIF(x = "0110") THEN y <= "1011";
		ELSIF(x = "0111") THEN y <= "1100";
		ELSIF(x = "1000") THEN y <= "1101";
		ELSIF(x = "1001") THEN y <= "1110";
		ELSIF(x = "1010") THEN y <= "1111";
		ELSIF(x = "1011") THEN y <= "0000";
		ELSIF(x = "1100") THEN y <= "0001";
		ELSIF(x = "1101") THEN y <= "0010";
		ELSIF(x = "1110") THEN y <= "0011";
		ELSIF(x = "1111") THEN y <= "0100";
		ELSE y <= "0000";
		END IF;
	END PROCESS;

END behav;

ARCHITECTURE behav2 OF comb IS
BEGIN
PROCESS(x) BEGIN
	CASE x IS
		WHEN "0000" => y <= "0101";
		WHEN "0001" => y <= "0110";
		WHEN "0010" => y <= "0111";
		WHEN "0011" => y <= "1000";
		WHEN "0100" => y <= "1001";
		WHEN "0101" => y <= "1010";
		WHEN "0110" => y <= "1011";
		WHEN "0111" => y <= "1100";
		WHEN "1000" => y <= "1101";
		WHEN "1001" => y <= "1110";
		WHEN "1010" => y <= "1111";
		WHEN "1011" => y <= "0000";
		WHEN "1100" => y <= "0001";
		WHEN "1101" => y <= "0010";
		WHEN "1110" => y <= "0011";
		WHEN "1111" => y <= "0100";
		WHEN OTHERS => y <= "0000";
	END CASE;
END PROCESS;
END behav2;