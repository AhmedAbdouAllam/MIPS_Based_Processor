LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;
--Note that n represents size=2*n and m represents code word size
ENTITY DataMemory IS
Generic(n: integer :=6 ; m: integer:=32);
PORT 
(
	clk : IN std_logic;
	MemoryWrite : IN std_logic;
	Address : IN std_logic_vector(n-1 DOWNTO 0);
	Input : IN std_logic_vector(2*m-1 DOWNTO 0);
	Output : OUT std_logic_vector(2*m-1 DOWNTO 0) 
);
END ENTITY DataMemory;

ARCHITECTURE DataMemoryArch OF DataMemory IS
TYPE ram_type IS ARRAY(0 TO (2**n)-1) of std_logic_vector(m-1 DOWNTO 0);
SIGNAL ram : ram_type;
Signal Address_ONE:Std_Logic_Vector(10 downto 0);
Constant One:Std_Logic_Vector(10 downto 0):="00000000001";
Component AdderFetch IS 
Generic (n: integer :=32);
Port (A: In std_logic_vector (n-1 downto 0) ;
B: In std_logic_vector (n-1 downto 0) ;
F: Out std_logic_vector (n-1 downto 0)); 
End Component AdderFetch;
BEGIN
PROCESS(clk) IS
BEGIN
IF rising_edge(clk) THEN
	IF MemoryWrite = '1' THEN
		ram(to_integer(Unsigned(Address))) <= Input(m-1 downto 0);
		ram(to_integer(Unsigned(Address_ONE))) <= Input(2*m-1 downto m);
	END IF;
END IF;

END PROCESS;
	Output(m-1 downto 0) <= ram(to_integer(Unsigned(Address)));
	Output(2*m-1 downto m) <= ram(to_integer(Unsigned(Address_ONE)));
AddressAdder:AdderFetch Generic Map(11) port map(Address,One,Address_ONE);
END DataMemoryArch; 
