Library ieee;
Use ieee.std_logic_1164.all;
Entity MemoryCacheSystem IS 
Port (
Data_Read,Data_Write,CLK:In Std_Logic;
Address_Data,Address_Instruction:In Std_Logic_Vector(10 downto 0);
Data_IN: In Std_Logic_Vector (31 downto 0);
Miss_data,Miss_Instruction:Out Std_Logic;
Data_Out,Instruction_Out:Out Std_Logic_Vector(31 downto 0);
Is_Interupted_Sequence: IN Std_Logic
);
End Entity MemoryCacheSystem;

Architecture MemoryCacheSystemArch of MemoryCacheSystem IS
Component CacheController IS 
port (
---------From Instruction Memory--------------
Address_Instruction:IN std_Logic_Vector (10 downto 0);
---------From Data Memory---------------------
Address_Data:IN std_Logic_Vector (10 downto 0);
Data_Read,Data_Write:In Std_Logic;
Miss_Instruction,Miss_Data:Out Std_Logic;
Write_Memory,Read_Memory,DutyRD:Out Std_logic:='0';
Address_Memory:Out Std_Logic_Vector (10 downto 0):="00000000000";
MEM_Status_Out:Out Std_Logic_Vector (1 downto 0):="00";
Acknowledge_Memory,CLK,Double_Line_Instr:IN Std_Logic;
Is_Interupted_Sequence:IN Std_Logic
);
End Component CacheController;
Component DataCachee IS 
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
End Component DataCachee;
Component InstructionCachee IS 
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
End Component InstructionCachee;
Component MainMemory IS
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

END Component MainMemory;
Signal MainBus:Std_Logic_Vector (127 downto 0):=X"00000000000000000000000000000000";
---For test purpose
Signal BusOutMem,BusOutDataCache:Std_Logic_Vector (127 downto 0):=X"00000000000000000000000000000000";
-------------
Signal MemoryRead,MemoryWrite,Ack,Miss_DataX,Miss_InstructionX,Double_word_Instr:std_logic:='0';
Signal MemoryAddress:Std_Logic_Vector(10 downto 0);
Signal MemStatus:Std_Logic_Vector (1 downto 0):="00";
Signal DutyRd:Std_Logic:='0';
Begin
Miss_Data<=Miss_DataX;
Miss_Instruction<=Miss_InstructionX;
Cache_Controller:CacheController Port Map (Address_Instruction,Address_Data,Data_Read,Data_Write,Miss_InstructionX,Miss_DataX,MemoryWrite,MemoryRead,DutyRd,MemoryAddress,MemStatus,Ack,CLK,Double_word_Instr,Is_Interupted_Sequence);
Main_Memory:MainMemory port map(CLK,MemoryWrite,MemoryRead,MemoryAddress,Ack,MainBus,BusOutMem,Is_Interupted_Sequence,Miss_DataX);
DataCache:DataCachee port map(Miss_DataX,Data_Read,Data_Write,CLK,Data_IN,Data_Out,Address_Data,MemStatus,Ack,MainBus,BusOutDataCache);
InstructionCache:InstructionCachee port map(Miss_InstructionX,CLK,Instruction_Out,Address_Instruction,MemStatus,Ack,Double_word_Instr,DutyRd,MainBus);

---------------------Bus Conflict Handler------------------
MainBus<=BusOutDataCache when MemStatus="11"
else BusOutMem;










End MemoryCacheSystemArch; 
