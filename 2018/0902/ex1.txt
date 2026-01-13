LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY TM2B IS
	PORT(	x : IN std_logic_vector(6 DOWNTO 0);
		z: OUT std_logic_vector(2 DOWNTO 0) );
END TM2B;

ARCHITECTURE behav OF TM2B IS
BEGIN
	PROCESS(x) BEGIN
		IF(x = "0000000") THEN
			z <= (OTHERS => '0');
		ELSIF (x = "0000001") THEN
			z <= "001";
		ELSIF (x = "0000011") THEN
			z <= "010"; 
		ELSIF (x = "0000111") THEN
			z <= "011"; 
		ELSIF (x = "0001111") THEN
			z <= "100"; 
		ELSIF (x = "0011111") THEN
			z <= "101"; 
		ELSIF (x = "0111111") THEN
			z <= "110"; 
		ELSIF (x = "1111111") THEN
			z <= "111";  
		ELSE 
			z <= "000";
		END IF;
	END PROCESS;
END behav;

ARCHITECTURE behav2 OF TM2B IS
BEGIN
	PROCESS(x) BEGIN
		CASE x IS
			WHEN "0000000" =>
				z <= (OTHERS => '0');
		WHEN "0000001" =>
			z <= "001";
		WHEN "0000011" =>
			z <= "010"; 
		WHEN "0000111" =>
			z <= "011"; 
		WHEN "0001111" =>
			z <= "100"; 
		WHEN "0011111" =>
			z <= "101"; 
		WHEN "0111111" =>
			z <= "110"; 
		WHEN "1111111" =>
			z <= "111";  
		WHEN OTHERS =>
			z <= "000";
		END CASE;
	END PROCESS;
END behav2;