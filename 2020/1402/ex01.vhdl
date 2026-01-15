LIBRARY IEEE;

USE IEEE.STD_LOGIC_1164.ALL;

ENTITY comb IS
PORT(	x : IN std_logic_vector(3 DOWNTO 0);
	sel : IN std_logic;
	y : OUT std_logic_vector(2 DOWNTO 0);
	err : OUT std_logic
	);
END comb;

ARCHITECTURE behav OF comb IS
BEGIN
PROCESS(x, sel) BEGIN
 	y <= (OTHERS => '0');
	err <= '0';

	IF(x = "0000") THEN
		err <= '1';
	ELSE
	IF(sel = '1') THEN
		IF(x(3) = '1') THEN
			y <= "100";
		ELSIF(x(2) = '1') THEN
			y <= "011;
		ELSIF(x(1) = '1') THEN
			y <= "010";
		ELSE
			y <= "001";
		END IF;
	ELSE
		IF(x(3) = '1') THEN
			y <= "011
		ELSIF(x(2) = '1') THEN
			y <= "010
		ELSIF(x(1) = '1') THEN
			y <= "001;
		ELSE
			y <= "000;
		END IF;


	END IF;

	END IF;
			
END PROCESS;

END behav;

--gemini

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY comb IS
PORT(	
    x   : IN std_logic_vector(3 DOWNTO 0);
    sel : IN std_logic;
    y   : OUT std_logic_vector(2 DOWNTO 0);
    err : OUT std_logic
);
END comb;
 
ARCHITECTURE behav2 OF comb S
BEGIN
PROCESS(x, sel) 
BEGIN
    -- Reset default
    y <= (OTHERS => '0');
    err <= '0';

    -- Controllo errore zero (comune a tutti)
    IF(x = "0000") THEN
        err <= '1';
    ELSE
        -- Primo bivio: decido che logica usare
        CASE sel IS
            
            -- CASO 1: Logica standard (Priority Encoder classico)
            WHEN '1' =>
                CASE x IS
                    WHEN "0001" => 
                        y <= "000";
                    WHEN "0010" | "0011" => 
                        y <= "001";
                    WHEN "0100" | "0101" | "0110" | "0111" => 
                        y <= "010";
                    WHEN OTHERS => -- Tutto da "1000" in su
                        y <= "011";
                END CASE;

            -- CASO 0: La tua logica "custom"
            WHEN OTHERS => -- sel = '0'
                CASE x IS
                    WHEN "0001" => 
                        y <= "001";
                    -- Qui raggruppi 2, 3 e 4 insieme come nel tuo IF originale
                    WHEN "0010" | "0011" | "0100" => 
                        y <= "010";
                    -- Qui raggruppi 5, 6 e 7
                    WHEN "0101" | "0110" | "0111" => 
                        y <= "011";
                    WHEN OTHERS => -- Tutto il resto (>= 8)
                        y <= "100";
                END CASE;
                
        END CASE;
    END IF;
END PROCESS;

END behav2

