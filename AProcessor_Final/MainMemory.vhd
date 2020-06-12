LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;
--Note that n represents size=2*n and m represents code word size
ENTITY MainMemory IS
PORT 
(
	clk : IN std_logic;
	MemoryWrite,MemoryRead : IN std_logic;
	Address : IN std_logic_vector(10 DOWNTO 0);
	Ack: Out std_logic:='0';
	DataIN_MainMemory : In std_logic_vector(127 DOWNTO 0):=X"00000000000000000000000000000000";
	DataOUT_MainMemory : out std_logic_vector(127 DOWNTO 0):=X"00000000000000000000000000000000";
	Is_Interupted_Sequence,Data_Miss:IN Std_Logic
);
END ENTITY MainMemory;

ARCHITECTURE MainMemoryArch OF MainMemory IS
TYPE ram_type IS ARRAY(0 TO 2047) of std_logic_vector(15 DOWNTO 0);
SIGNAL ram : ram_type;
Signal AckX:std_Logic:='0';
Signal Counter:Std_Logic_Vector (1 downto 0):="00";
Signal CounterOne:Std_Logic_Vector (1 downto 0);
Constant Terminator:Std_Logic_Vector (1 downto 0):="10"; --To be change if there is a delay.
Constant One :Std_Logic_Vector (1 downto 0):="01";

Component AdderFetch IS 
Generic (n: integer :=32);
Port (A: In std_logic_vector (n-1 downto 0) ;
B: In std_logic_vector (n-1 downto 0) ;
F: Out std_logic_vector (n-1 downto 0)); 
End Component AdderFetch;

BEGIN
PROCESS(clk) IS
BEGIN
IF falling_edge(clk) THEN
if Is_Interupted_Sequence='0' or Data_Miss='1' then
	If AckX='1' then AckX<='0';
	elsIF MemoryWrite = '1' THEN
		if Counter =Terminator then
			AckX<='1';
			Counter<="00";
			ram((to_integer(Unsigned(Address(10 downto 3))) * 8)+0)<=DataIN_MainMemory(15 downto 0);
			ram((to_integer(Unsigned(Address(10 downto 3))) * 8)+1)<=DataIN_MainMemory(31 downto 16);
			ram((to_integer(Unsigned(Address(10 downto 3))) * 8)+2)<=DataIN_MainMemory(47 downto 32);
			ram((to_integer(Unsigned(Address(10 downto 3))) * 8)+3)<=DataIN_MainMemory(63 downto 48);
			ram((to_integer(Unsigned(Address(10 downto 3))) * 8)+4)<=DataIN_MainMemory(79 downto 64);
			ram((to_integer(Unsigned(Address(10 downto 3))) * 8)+5)<=DataIN_MainMemory(95 downto 80);
			ram((to_integer(Unsigned(Address(10 downto 3))) * 8)+6)<=DataIN_MainMemory(111 downto 96);
			ram((to_integer(Unsigned(Address(10 downto 3))) * 8)+7)<=DataIN_MainMemory(127 downto 112);
		else
			Counter<= CounterOne;	

		end if;
	elsIF MemoryRead = '1' THEN
		if Counter =Terminator then
			AckX<='1';
			Counter<="00";
			DataOUT_MainMemory(15 downto 0)<=ram((to_integer(Unsigned(Address(10 downto 3))) * 8)+0);
			DataOUT_MainMemory(31 downto 16)<=ram((to_integer(Unsigned(Address(10 downto 3))) * 8)+1);
			DataOUT_MainMemory(47 downto 32)<=ram((to_integer(Unsigned(Address(10 downto 3))) * 8)+2);
			DataOUT_MainMemory(63 downto 48)<=ram((to_integer(Unsigned(Address(10 downto 3))) * 8)+3);
			DataOUT_MainMemory(79 downto 64)<=ram((to_integer(Unsigned(Address(10 downto 3))) * 8)+4);
			DataOUT_MainMemory(95 downto 80)<=ram((to_integer(Unsigned(Address(10 downto 3))) * 8)+5);
			DataOUT_MainMemory(111 downto 96)<=ram((to_integer(Unsigned(Address(10 downto 3))) * 8)+6);
			DataOUT_MainMemory(127 downto 112)<=ram((to_integer(Unsigned(Address(10 downto 3))) * 8)+7);
		else
			Counter<= CounterOne;

		end if;
	END IF;
elsif Is_Interupted_Sequence='1' and Data_Miss='0' then Counter<="00";
end if;
END IF;

END PROCESS;
	Ack<=AckX;
	CounterAdder:AdderFetch generic map (2) port map (Counter,One,CounterOne);
END MainMemoryArch; 
