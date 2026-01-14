LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY comb IS
PORT(	bcd : IN std_logic_vector(3 DOWNTO 0);
	d : OUT std_logic_vector(3 DOWNTO 0)
	);
END comb;

ARCHITECTURE behav OF comb IS
BEGIN
	PROCESS(bcd) BEGIN
		IF(bcd = "0000") THEN
			d <= "1001"; 
		ELSIF(bcd = "0001") THEN
			d <= "1000";
		ELSIF(bcd = "0010") THEN
			d <= "0111";
		ELSIF(bcd = "0011") THEN
			d <= "0110";	
		ELSIF(bcd = "0100") THEN
			d <= "0101";
		ELSIF(bcd = "0101") THEN
			d <= "0100";
		ELSIF(bcd = "0110") THEN
			d <= "0011";
		ELSIF(bcd = "0111") THEN
			d <= "0010";
		ELSIF(bcd = "1000") THEN
			d <= "0001";
		ELSIF(bcd = "1001") THEN
			d <= "0000";
		ELSE
			d <= "----";
		END IF;
	END PROCESS;
END behav;

ARCHITECTURE behav2 OF comb IS
BEGIN
	PROCESS(bcd) BEGIN
		CASE bcd IS
			WHEN "0000"=>
				d <= "1001";
			WHEN "0001"=>
				d <= "1000";
			WHEN "0010"=>
				d <= "0111";
			WHEN "0011"=>
				d <= "0110";
			WHEN "0100"=>
				d <= "0101";
			WHEN "0101"=>
				d <= "0100";
			WHEN "0110"=>		
				d <= "0011";	
			WHEN "0111"=>
				d <= "0010";
			WHEN "1000"=>
				d <= "0001";
			WHEN "1001"=>
				d <= "0000";
			WHEN OTHERS => 
				d <= "----";

		END CASE;
	END PROCESS;
END behav2;