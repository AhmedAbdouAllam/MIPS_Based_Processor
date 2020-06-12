LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;
--Note that n represents size=2*n and m represents code word size
ENTITY InstructionMemory IS
Generic(n: integer :=20 ; m: integer:=16);
PORT 
(
	Address : IN std_logic_vector(n-1 DOWNTO 0);
	Output : OUT std_logic_vector(2*m-1 DOWNTO 0)
);
END ENTITY InstructionMemory;

ARCHITECTURE InstructionMemoryArch OF InstructionMemory IS
TYPE ram_type IS ARRAY(0 TO (2**n)-1) of std_logic_vector(m-1 DOWNTO 0);
SIGNAL ram : ram_type;
BEGIN
        

	Output(m-1 downto 0) <= ram(to_integer(Unsigned(Address))+1);	
	Output(2*m-1 downto m) <= ram(to_integer(Unsigned(Address)));



END InstructionMemoryArch; 
