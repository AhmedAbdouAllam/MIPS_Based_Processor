--Author Ahmed A.Allam
--Date:7/5/2020
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;

Entity InstructionCachee IS 
port (
InstrMiss,CLK:IN Std_Logic;
InstrOut:OUT Std_Logic_Vector(31 downto 0);
InstrAddress:IN Std_Logic_Vector(10 downto 0);
MemStatus:IN Std_Logic_Vector (1 downto 0);
Ack:In std_Logic;
Double_word_Instr:Out Std_Logic;
DutyRD :In Std_Logic;
DataIN_MainMemory:IN Std_Logic_Vector(127 downto 0) :=X"00000000000000000000000000000000"
);
End Entity InstructionCachee;


Architecture InstructionCacheArch of InstructionCachee
IS 
Component AdderFetch IS 
Generic (n: integer :=32);
Port (A: In std_logic_vector (n-1 downto 0) ;
B: In std_logic_vector (n-1 downto 0) ;
F: Out std_logic_vector (n-1 downto 0)); 
End Component AdderFetch;
TYPE InstrCacheType IS ARRAY(0 TO 31,0 To 7) of std_logic_vector(15 DOWNTO 0);
Signal InstructionCache :InstrCacheType:=(Others =>(X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000"));
Signal InstrAddressOne: std_logic_vector(10 downto 0);
Constant One:Std_Logic_Vector (10 downto 0):="00000000001";
Begin

Process(Clk)
Begin
if Rising_edge (Clk) then
	if MemStatus="01" and Ack='1' then 
		-----Script Generated Code-------------
		if DutyRD='0' then
			InstructionCache(to_integer(Unsigned(InstrAddress(7 downto 3))),0)<=DataIN_MainMemory(15 downto 0);
			InstructionCache(to_integer(Unsigned(InstrAddress(7 downto 3))),1)<=DataIN_MainMemory(31 downto 16);
			InstructionCache(to_integer(Unsigned(InstrAddress(7 downto 3))),2)<=DataIN_MainMemory(47 downto 32);
			InstructionCache(to_integer(Unsigned(InstrAddress(7 downto 3))),3)<=DataIN_MainMemory(63 downto 48);
			InstructionCache(to_integer(Unsigned(InstrAddress(7 downto 3))),4)<=DataIN_MainMemory(79 downto 64);
			InstructionCache(to_integer(Unsigned(InstrAddress(7 downto 3))),5)<=DataIN_MainMemory(95 downto 80);
			InstructionCache(to_integer(Unsigned(InstrAddress(7 downto 3))),6)<=DataIN_MainMemory(111 downto 96);
			InstructionCache(to_integer(Unsigned(InstrAddress(7 downto 3))),7)<=DataIN_MainMemory(127 downto 112);
		elsif DutyRD='1' then
			InstructionCache(to_integer(Unsigned(InstrAddressOne(7 downto 3))),0)<=DataIN_MainMemory(15 downto 0);
			InstructionCache(to_integer(Unsigned(InstrAddressOne(7 downto 3))),1)<=DataIN_MainMemory(31 downto 16);
			InstructionCache(to_integer(Unsigned(InstrAddressOne(7 downto 3))),2)<=DataIN_MainMemory(47 downto 32);
			InstructionCache(to_integer(Unsigned(InstrAddressOne(7 downto 3))),3)<=DataIN_MainMemory(63 downto 48);
			InstructionCache(to_integer(Unsigned(InstrAddressOne(7 downto 3))),4)<=DataIN_MainMemory(79 downto 64);
			InstructionCache(to_integer(Unsigned(InstrAddressOne(7 downto 3))),5)<=DataIN_MainMemory(95 downto 80);
			InstructionCache(to_integer(Unsigned(InstrAddressOne(7 downto 3))),6)<=DataIN_MainMemory(111 downto 96);
			InstructionCache(to_integer(Unsigned(InstrAddressOne(7 downto 3))),7)<=DataIN_MainMemory(127 downto 112);
		

		end if;
		-------end of script1------
	end if;	

end if;
End Process;
InstrOut(31 downto 16)<=InstructionCache(to_integer(Unsigned(InstrAddress(7 downto 3))),to_integer(Unsigned(InstrAddress(2 downto 0)))) when InstrMiss='0'
else X"0000";
InstrOut(15 downto 0)<=InstructionCache(to_integer(Unsigned(InstrAddressOne(7 downto 3))),to_integer(Unsigned(InstrAddressOne(2 downto 0)))) when InstrMiss='0'
else X"0000";
Double_word_Instr<=InstructionCache(to_integer(Unsigned(InstrAddress(7 downto 3))),to_integer(Unsigned(InstrAddress(2 downto 0))))(15);
InstructionAdder:AdderFetch generic map(11) port map(InstrAddress,One,InstrAddressOne);
End Architecture InstructionCacheArch;
