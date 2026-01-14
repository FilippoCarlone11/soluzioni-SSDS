LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY primeDet IS
    PORT( 
        n : IN std_logic_vector(3 DOWNTO 0);
        z : OUT std_logic
    );
END primeDet;

ARCHITECTURE bh OF primeDet IS
BEGIN
    
    -- Formula implementata (include 1 come primo): 
    -- n0(n2 XOR n1) + NOT n3 * (n0 + NOT n2 * n1)
    
    z <= ( n(0) AND (n(2) XOR n(1)) ) OR ( NOT n(3) AND ( n(0) OR (NOT n(2) AND n(1)) ) );

END bh;