--Author Ahmed A.Allam
--Date:7/5/2020
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;

Entity DataCachee IS 
port (
DataMiss,Memory_Read,Memory_Write,CLK:IN Std_Logic;
DataIN:IN Std_Logic_Vector(31 downto 0); 
DataOut:OUT Std_Logic_Vector(31 downto 0);
DataAddress:IN Std_Logic_Vector(10 downto 0);
MemStatus:IN Std_Logic_Vector (1 downto 0);
Ack:In std_Logic;
DataIN_MainMemory:In Std_Logic_Vector(127 downto 0) :=X"00000000000000000000000000000000";
DataOUT_MainMemory:OUT Std_Logic_Vector(127 downto 0) :=X"00000000000000000000000000000000"
);
End Entity DataCachee;


Architecture DataCacheArch of DataCachee
IS 
Component AdderFetch IS 
Generic (n: integer :=32);
Port (A: In std_logic_vector (n-1 downto 0) ;
B: In std_logic_vector (n-1 downto 0) ;
F: Out std_logic_vector (n-1 downto 0)); 
End Component AdderFetch;
TYPE DataCacheType IS ARRAY(0 TO 31,0 To 7) of std_logic_vector(15 DOWNTO 0);
Signal DataCache :DataCacheType:=(Others =>(X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000",X"0000"));
Signal RealRead,RealWrite:Std_Logic:='0';
Signal OffsetOne :Std_Logic_Vector (2 downto 0);
Constant One :Std_Logic_Vector(2 downto 0):="001";
Begin

Process(Clk)
Begin
if Rising_edge (Clk) then
	if MemStatus="10" and Ack='1' then 
		-----Script Generated Code-------------
		DataCache(to_integer(Unsigned(DataAddress(7 downto 3))),0)<=DataIN_MainMemory(15 downto 0);
		DataCache(to_integer(Unsigned(DataAddress(7 downto 3))),1)<=DataIN_MainMemory(31 downto 16);
		DataCache(to_integer(Unsigned(DataAddress(7 downto 3))),2)<=DataIN_MainMemory(47 downto 32);
		DataCache(to_integer(Unsigned(DataAddress(7 downto 3))),3)<=DataIN_MainMemory(63 downto 48);
		DataCache(to_integer(Unsigned(DataAddress(7 downto 3))),4)<=DataIN_MainMemory(79 downto 64);
		DataCache(to_integer(Unsigned(DataAddress(7 downto 3))),5)<=DataIN_MainMemory(95 downto 80);
		DataCache(to_integer(Unsigned(DataAddress(7 downto 3))),6)<=DataIN_MainMemory(111 downto 96);
		DataCache(to_integer(Unsigned(DataAddress(7 downto 3))),7)<=DataIN_MainMemory(127 downto 112);
		-------end of script1------
	elsif MemStatus="11"  then 
		--Script 2-------------------
		DataOUT_MainMemory(15 downto 0)<=DataCache(to_integer(Unsigned(DataAddress(7 downto 3))),0);
		DataOUT_MainMemory(31 downto 16)<=DataCache(to_integer(Unsigned(DataAddress(7 downto 3))),1);
		DataOUT_MainMemory(47 downto 32)<=DataCache(to_integer(Unsigned(DataAddress(7 downto 3))),2);
		DataOUT_MainMemory(63 downto 48)<=DataCache(to_integer(Unsigned(DataAddress(7 downto 3))),3);
		DataOUT_MainMemory(79 downto 64)<=DataCache(to_integer(Unsigned(DataAddress(7 downto 3))),4);
		DataOUT_MainMemory(95 downto 80)<=DataCache(to_integer(Unsigned(DataAddress(7 downto 3))),5);
		DataOUT_MainMemory(111 downto 96)<=DataCache(to_integer(Unsigned(DataAddress(7 downto 3))),6);
		DataOUT_MainMemory(127 downto 112)<=DataCache(to_integer(Unsigned(DataAddress(7 downto 3))),7);
		
----end of script2------------
	end if;	

elsif Falling_edge (Clk) then
     	if RealWrite='1' then
		DataCache(to_integer(Unsigned(DataAddress(7 downto 3))),to_integer(Unsigned(DataAddress(2 downto 0))))<=DataIn(15 downto 0);
		DataCache(to_integer(Unsigned(DataAddress(7 downto 3))),to_integer(Unsigned(OffsetOne)))<=DataIn(31 downto 16);
	end if;

end if;
End Process;
RealRead<=(not DataMiss) and Memory_Read;
RealWrite<=(not DataMiss) and Memory_Write;
DataOut(15 downto 0)<=DataCache(to_integer(Unsigned(DataAddress(7 downto 3))),to_integer(Unsigned(DataAddress(2 downto 0))));
DataOut(31 downto 16)<=DataCache(to_integer(Unsigned(DataAddress(7 downto 3))),to_integer(Unsigned(OffsetOne)));
OffsetGetter:AdderFetch Generic Map(3) Port Map (DataAddress(2 downto 0),one,OffsetOne);

End Architecture DataCacheArch;
