LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY comb IS
PORT(	x : IN std_logic_vector(3 DOWNTO 0);
	z : OUT std_logic_vector(3 DOWNTO 0)
);
END comb;

ARCHITECTURE behav OF comb IS BEGIN

	PROCESS(x) BEGIN
        IF    (x = "0000") THEN z <= "0011";
        ELSIF (x = "0001") THEN z <= "0100"; 
        ELSIF (x = "0010") THEN z <= "0101";
        ELSIF (x = "0011") THEN z <= "0110"; 
        ELSIF (x = "0100") THEN z <= "0111";
        ELSIF (x = "0101") THEN z <= "1000"; 
        ELSIF (x = "0110") THEN z <= "1001";
        ELSIF (x = "0111") THEN z <= "1010"; 
        ELSIF (x = "1000") THEN z <= "1011";
        ELSIF (x = "1001") THEN z <= "1100";
        ELSE 
            z <= "0000"; 
        END IF;

	END PROCESS;

END behave;