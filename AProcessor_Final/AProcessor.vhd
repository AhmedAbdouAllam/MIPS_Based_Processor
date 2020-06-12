
LIBRARY IEEE;
Use ieee.std_logic_1164.all;
--The following Libraries are added after The edit
Use IEEE.Math_real.all;
Use IEEE.Numeric_std.all;
Entity AProcessor IS 
Port (
---ExtraSignals---------
------in first part not included must be included at the end A.Allam---------
FlagRegContents :OUT std_logic_vector(2 downto 0);
PC_Contents:Out std_logic_vector (31 downto 0);
-------------Registers are watched using memory list------------
IN_Port :IN std_logic_vector (31 downto 0):=X"00000000";
Out_Port :Out std_logic_vector (31 downto 0);
----------Testing to be removed after memory----------------------------

-------------------------------------------------------------------------
RST,CLK,INTR:In std_Logic:='0'
); 
End Entity AProcessor;
Architecture AProcessorArch of AProcessor IS
-------Component decleration of Decode Stage--------------------------------------
Component InstructionFetchingUnit IS 
Port (
Branch_Address,MemoryIntrRstAddress: In Std_Logic_vector (31 downto 0);
ConfirmedBranch,IsIntrRst,RSTBufferIF_ID,PC_Disable,CLK,INT,DisableBufferIF_ID:In Std_Logic;
PC,Instruction :Out Std_Logic_vector (31 downto 0);
PC_content:Out Std_Logic_vector (31 downto 0);
----------------------------------------Added 23/5/2020 Ahmed A.Allam "Signal Transfer Decleration"-----------
PCx_C_OUT:Out Std_Logic_Vector(10 downto 0);
InstrctionX_C_IN:IN Std_Logic_Vector (31 downto 0);
Instruction_Miss,Data_Miss:IN Std_Logic; ---to be used after next step Ahmed A.Allam--------
IsInteruptedSequence:Out Std_Logic
); 
End Component InstructionFetchingUnit;
Component InstructionDecodingUnit IS 
Port (
	ID_EX_RST,CU_Disable,Wr_EnableX,Wr_EnableY,CLK,RST_REG_File,ID_EX_Disable:IN std_Logic;
	Wr_ADDx,Wr_ADDy :IN Std_Logic_Vector (2 downto 0);
	Wr_DataX,Wr_DataY: IN Std_Logic_Vector(31 downto 0);
	PC_in,Instruction_IN:IN Std_Logic_Vector(31 downto 0);
	ReadData1,ReadData2,PC_out,IMM_Value: OUT Std_Logic_Vector(31 downto 0);
	Instruction_Out:Out Std_Logic_Vector(8 downto 0);
	IMM_Shift:Out Std_Logic_Vector(4 downto 0);
	--SETOFControlSignals
	PC_Change,RTI,Is_Shift,Is_OutPort,Save_PC,Is_Swap,SourceIsDest,Is_InPort,Stack_Up,Stack_Down,Is_IMM,Stack_Enable,Memory_Read,Memory_Write,Is_Branch_Zero,Memory_To_Reg,Reg_Write,Is_Branch_Negative,Is_Branch_Carry,ALU_Enable,Is_Branch,Set_Carry,Clear_Carry,Has_SRC2,Has_SRC1,IS_Load_POP: OUT std_logic;
	ALU_OP: OUT std_logic_vector (2 downto 0);
	Flag_Change: OUT std_logic_vector (1 downto 0);
	Extra_Has_Src1,Extra_Has_Src2:out Std_Logic;
	IsMove:Out Std_logic;
	RegContents0,RegContents1,RegContents2,RegContents3,RegContents4,RegContents5,RegContents6,RegContents7:Out std_Logic_Vector(31 downto 0)
); 
End Component InstructionDecodingUnit;
------------------Signals Used---------------------------------------------------
Component ExecutionUnit IS 
Port (
-----Inputs-------
	ReadData1_IN,ReadData2_IN,PC_IN,IMM_Value_IN: IN Std_Logic_Vector(31 downto 0);
	Instruction_IN:IN Std_Logic_Vector(8 downto 0);
	IMM_Shift_IN:IN Std_Logic_Vector(4 downto 0);
	--SETOFControlSignals
	PC_Change_IN,RTI_IN,Is_Shift_IN,Is_OutPort_IN,Save_PC_IN,Is_Swap_IN,SourceIsDest_IN,Is_InPort_IN,Stack_Up_IN,Stack_Down_IN,Is_IMM_IN,Stack_Enable_IN,Memory_Read_IN,Memory_Write_IN,Is_Branch_Zero_IN,Memory_To_Reg_IN,Reg_Write_IN,Is_Branch_Negative_In,Is_Branch_Carry_IN,ALU_Enable_IN,Is_Branch_IN,Set_Carry_IN,Clear_Carry_IN,IS_Load_POP_IN: IN std_logic;
	ReturnFalgs:in std_logic;
	ReturnedFlags:IN std_logic_vector (2 downto 0);
--
	PC_Change,RTI,Save_PC,Is_Swap,Is_InPort,Stack_Up,Stack_Down,Stack_Enable,Memory_Read,Memory_Write,Memory_To_Reg,Reg_Write,IS_Load_POP,Confirmed_branch: OUT std_logic;
	ALU_OP: IN std_logic_vector (2 downto 0);
	Flag_Change: IN std_logic_vector (1 downto 0);
	INPUT_BUS,EX_DEST_DATA,MEM_DEST_DATA,EX_SRCSwap_DATA,MEM_SRCSwap_DATA:IN std_LOGIC_VECTOR(31 downto 0);
	FWDA,FWDB:IN std_logic_vector (2 downto 0);
	RST_FlagReg,RST_EX_MEM_Buffer,CLK,Disable_EX_MEM_Buffer,RST_OUTPORT:in std_logic;
--
	OUTPut_Port :OUT std_logic_vector (31 downto 0);
	ReadData1_OUT,ReadData2_OUT,PC_OUT: OUT Std_Logic_Vector(31 downto 0);
	IMM_Value_OUT: OUT Std_Logic_Vector(15 downto 0);
	OutputFlags:out Std_Logic_Vector(2 downto 0);
	Instruction_OUT: out std_logic_vector (8 downto 0);
	FlagRegContents: out Std_Logic_Vector(2 downto 0);
	IsMove:in Std_logic

); 
End Component ExecutionUnit;
Component MemAndWBUnits IS 
Port (
------Inputs A.Allam--------------
	ReadData1_IN,ReadData2_IN,PC_IN: IN Std_Logic_Vector(31 downto 0);
	IMM_Value_IN: IN Std_Logic_Vector(15 downto 0);
	Instruction_In: In std_logic_vector (8 downto 0);
	EFlags_IN:In std_logic_vector (2 downto 0);
	PC_Change_In,RTI_In,Save_PC_In,Is_Swap_In,Stack_Up_In,Stack_Down_In,Stack_Enable_In,Memory_Read_In,Memory_Write_In,Memory_To_Reg_In,Reg_Write_In:in Std_logic;
	Disable_MEM_WB,RST_MEM_WB,RST,CLK:in std_logic;
	ReturnFlags,Is_OUT_PC_RTI,Is_OUT_PC_INT,Save_In_Stack_INT,Save_IN_STACK_Flag:in Std_logic;
	PC_From_interupt:IN Std_Logic_Vector(31 downto 0);
	Flags_From_Interupt:IN Std_Logic_Vector(2 downto 0);
	ReturnFlags_Out:Out std_Logic;
	Flags_From_Interupt_Out_ToCircuit:Out Std_Logic_Vector(2 downto 0);
------Outputs----------------------
	is_INTR_RST,Write_Enable1,Write_Enable2:Out Std_logic;
	Wr_Add1,Wr_Add2 :Out Std_logic_Vector (2 downto 0);
	Write_Data1,Write_Data2,MemoryBranchAddress:Out Std_logic_Vector (31 downto 0);
-------------Added by Ahmed A.Allam 23/5/2020 ------Cache Implementation Added Signals--------
	MemoryWrite_C_Out,MemoryRead_C_Out :Out Std_Logic;
	FinalAddress_C_OUT:OUT Std_Logic_Vector(10 downto 0);
	FinalData_C_OUT:OUT Std_Logic_Vector (31 downto 0);
	MemDataX_C_IN :IN Std_Logic_Vector(31 downto 0);
	DataMiss:IN Std_Logic;
	IsInProcessInterupt:IN Std_Logic
); 
End Component MemAndWBUnits;

Component MemoryCacheSystem IS 
Port (
	Data_Read,Data_Write,CLK:In Std_Logic;
	Address_Data,Address_Instruction:In Std_Logic_Vector(10 downto 0);
	Data_IN: In Std_Logic_Vector (31 downto 0);
	Miss_data,Miss_Instruction:Out Std_Logic;
	Data_Out,Instruction_Out:Out Std_Logic_Vector(31 downto 0);
	Is_Interupted_Sequence: IN Std_Logic
);
End Component MemoryCacheSystem;


Component HDU IS
GENERIC (n : integer := 3); 
PORT(Is_Load, Has_SRC2,Has_SRC1:IN STD_LOGIC;
SRC2_ADD,SRC1_ADD,LDD_ADD:IN STD_LOGIC_VECTOR(N-1 DOWNTO 0);
Is_Hazard: OUT STD_LOGIC);     
END Component HDU;
Component FW_Unit IS
  GENERIC (n : integer := 3); 
  port(SRC_Swap_MEM,SRC_Swap_EX,Reg_Dest_MEM,Reg_Dest_EX,Reg_SRC_ADD1,Reg_SRC_ADD2 : IN std_logic_vector(n-1 DOWNTO 0) ;
     IS_Swap_EX,IS_Swap_MEM,WB_MEM,WB_EX : IN std_logic ;
     FWD_A,FWD_B : OUT std_logic_vector(2 DOWNTO 0));
end Component FW_Unit;
Component InteruptUnit IS 
port (
INTR,RTI,Clk,RST:IN Std_Logic;
Ret_Flags,Is_Out_RTI,Save_In_St_INT,Save_In_St_Flags,Is_Out_INTR:OUT Std_Logic;
PC_IN_Content,PC_IN_Fetch,PC_IN_Decode:IN Std_Logic_Vector(31 downto 0);
Flags_IN:IN Std_Logic_Vector(2 downto 0);
Flags_To_Save:out Std_Logic_Vector(2 downto 0);
PC_To_Save:Out Std_Logic_Vector(31 downto 0);
DisableHandler:IN Std_Logic;
IsInProcessInterupt:Out Std_Logic

);
End Component InteruptUnit;
Component OneBitBuffer IS 
port (
INPUT:IN Std_logic;
OUTPUT:OUT Std_Logic;

CLK:IN std_Logic);
End Component OneBitBuffer;

---------------Fetching Unit Signals---------------------------------------------
Signal FPC,FInstruction : Std_Logic_vector (31 downto 0):=X"00000000";
-------------------------HDU Signals-----------------------------------------
Signal Hazard_Detected:Std_Logic:='0';----VIP Signal attached to 3 nodes A.Allam


------------------------DecodeUnit Signals-------------------------------------------
signal	DReadData1,DReadData2,DPC_out,DIMM_Value:  Std_Logic_Vector(31 downto 0):=X"00000000";
signal	DInstruction_Out: Std_Logic_Vector(8 downto 0):="000000000";
signal	DIMM_Shift: Std_Logic_Vector(4 downto 0):="00000";
-------------SETOFControlSignals
signal	DPC_Change,DRTI,DIs_ShiftD,DIs_OutPort,DSave_PC,DIs_Swap,DSourceIsDest,DIs_InPort,DStack_Up,DStack_Down,DIs_IMM,DStack_Enable,DMemory_Read,DMemory_Write,DIs_Branch_Zero,DMemory_To_Reg,DReg_Write,DIs_Branch_Negative,DIs_Branch_Carry,DALU_Enable,DIs_Branch,DSet_Carry,DClear_Carry,DHas_SRC2,DHas_SRC1,DIS_Load_POP:std_logic:='0';
signal	DALU_OP:  std_logic_vector (2 downto 0):="000";
signal	DFlag_Change:  std_logic_vector (1 downto 0):="00";
Signal DIsMove:Std_logic:='0';
------------------------ExecuteUnitSignals------------------------------------------

--
signal	EPC_Change,ERTI,ESave_PC,EIs_Swap,EIs_InPort,EStack_Up,EStack_Down,EStack_Enable,EMemory_Read,EMemory_Write,EMemory_To_Reg,EReg_Write,EIS_Load_POP,EConfirmed_branch:  std_logic:='0';


signal FWDA,FWDB: std_logic_vector (2 downto 0):="000";
type RegisterOut is array (0 to 7) of std_logic_vector( 31 downto 0);
Signal RegistersOut: RegisterOut;
--
	
signal	EReadData1_OUT,EReadData2_OUT,EPC_OUT:  Std_Logic_Vector(31 downto 0):=X"00000000";
signal	EIMM_Value_OUT:  Std_Logic_Vector(15 downto 0):=X"0000";
signal	EOutputFlags: Std_Logic_Vector(2 downto 0):="000";
signal	EInstruction_OUT:  std_logic_vector (8 downto 0):="000000000";
signal HasS1,HasS2:Std_logic:='0';
-------------------------Forwarding Unit Signals------------------

-----------------------Special Signals-----------------------------
Signal MemoryIntrRstAddress: Std_Logic_vector (31 downto 0):=X"00000000";
Signal IsIntrRst: Std_Logic:='0';

signal ReturnFalgs: std_logic:='0';
signal ReturnedFlags: std_logic_vector (2 downto 0):="000";
Signal MEM_DEST_DATA,MEM_SRCSwap_DATA: std_LOGIC_VECTOR(31 downto 0):=X"00000000";
constant RST_EX_MEM_Buffer: std_logic :='0';
Signal SRC_Swap_MEM,Reg_Dest_MEM :  std_logic_vector(2 DOWNTO 0):="000";
Signal IS_Swap_MEM,WB_MEM :  std_logic:='0' ;
Signal PC_ContentsS:Std_Logic_Vector (31 downto 0);
Signal FlagRegContentsS:Std_Logic_Vector(2 downto 0);
------------------
signal FlushA,DisableA,FlushB :std_logic:='0';
------------------------Zero set to be removed-----------------------
-----------------------InteruptSignals-------------------------------
	Signal IReturnFlags,Is_OUT_PC_RTI,Is_OUT_PC_INT,Save_In_Stack_INT,Save_IN_STACK_Flag: Std_logic:='0';
	Signal PC_From_interupt: Std_Logic_Vector(31 downto 0):=X"00000000";
	Signal Flags_From_Interupt: Std_Logic_Vector(2 downto 0):="000";

	

--------------Added 23/5/2020 Ahmed A.Allam ---------Memory Cache Related Signals--------
Signal DataRead,DataWrite,Instruction_Miss,Data_Miss,Data_Miss_Bufferd: Std_Logic;
Signal Address_Data,Address_Instruction:Std_Logic_Vector (10 downto 0);
Signal Data_In,Data_Out,Instruction_OUT:Std_Logic_Vector (31 downto 0);
Signal Is_Interupted_Sequence:Std_Logic;
Signal DisableHandler,DisableSeqB,DisableSeqA,DisableSeqA_Buffered:Std_Logic:='0';
Signal IsInProcessInterupt:Std_Logic:='0';
----------------------End Of Declerations------------------------------------------
Begin
FlushA<=EConfirmed_branch or RST or IsIntrRst;
DisableA<=Hazard_Detected or RST;
FlushB<= RST or IsIntrRst;
PC_Contents<=PC_ContentsS;
FlagRegContents<=FlagRegContentsS;
DisableSeqA<=Hazard_Detected or Data_Miss; --to have further considerations
DisableSeqA_Buffered<=Hazard_Detected or Data_Miss_Bufferd; --to have further considerations
DisableSeqB<=Data_Miss;
DisableHandler<=Data_Miss;
-----------AddedComponents---------------------------------------------------------
IFetch:InstructionFetchingUnit Port Map(EReadData1_OUT,MemoryIntrRstAddress,EConfirmed_branch,IsIntrRst,FlushA,DisableSeqA_Buffered,CLK,INTR,DisableSeqA,FPC,FInstruction,PC_ContentsS,Address_Instruction,Instruction_OUT,Instruction_Miss,Data_Miss,Is_Interupted_Sequence);
IDecode:InstructionDecodingUnit Port Map(FlushA,DisableA,WB_MEM,IS_Swap_MEM,CLK,RST,DisableSeqB, Reg_Dest_MEM,SRC_Swap_MEM,MEM_DEST_DATA,MEM_SRCSwap_DATA,FPC,FInstruction,DReadData1,DReadData2,DPC_out,DIMM_Value,DInstruction_Out ,DIMM_Shift,DPC_Change,DRTI,DIs_ShiftD,DIs_OutPort,DSave_PC,DIs_Swap,DSourceIsDest,DIs_InPort,DStack_Up,DStack_Down,DIs_IMM,DStack_Enable,DMemory_Read,DMemory_Write,DIs_Branch_Zero,DMemory_To_Reg,DReg_Write,DIs_Branch_Negative,DIs_Branch_Carry,DALU_Enable,DIs_Branch,DSet_Carry,DClear_Carry,DHas_SRC2,DHas_SRC1,DIS_Load_POP,DALU_OP,DFlag_Change,HasS1,HasS2,DIsMove,RegistersOut(0),RegistersOut(1),RegistersOut(2),RegistersOut(3),RegistersOut(4),RegistersOut(5),RegistersOut(6),RegistersOut(7));
Execute:ExecutionUnit Port Map (DReadData1,DReadData2,DPC_out,DIMM_Value,DInstruction_Out ,DIMM_Shift,DPC_Change,DRTI,DIs_ShiftD,DIs_OutPort,DSave_PC,DIs_Swap,DSourceIsDest,DIs_INPort,DStack_Up,DStack_Down,DIs_IMM,DStack_Enable,DMemory_Read,DMemory_Write,DIs_Branch_Zero,DMemory_To_Reg,DReg_Write,DIs_Branch_Negative,DIs_Branch_Carry,DALU_Enable,DIs_Branch,DSet_Carry,DClear_Carry,DIS_Load_POP,ReturnFalgs,ReturnedFlags,EPC_Change,ERTI,ESave_PC,EIs_Swap,EIs_InPort,EStack_Up,EStack_Down,EStack_Enable,EMemory_Read,EMemory_Write,EMemory_To_Reg,EReg_Write,EIS_Load_POP,EConfirmed_branch,DALU_OP,DFlag_Change,IN_Port,EReadData1_OUT,MEM_DEST_DATA,EReadData2_OUT,MEM_SRCSwap_DATA,FWDA,FWDB,RST,FlushB,CLK,DisableSeqB,RST,Out_Port,EReadData1_OUT,EReadData2_OUT,EPC_OUT,EIMM_Value_OUT,EOutputFlags,EInstruction_OUT,FlagRegContentsS,DIsMove);
Mem_WriteBack:MemAndWBUnits Port Map(EReadData1_OUT,EReadData2_OUT,EPC_OUT,EIMM_Value_OUT,EInstruction_OUT,EOutputFlags,EPC_Change,ERTI,ESave_PC,EIs_Swap,EStack_Up,EStack_Down,EStack_Enable,EMemory_Read,EMemory_Write,EMemory_To_Reg,EReg_Write,'0','0',RST,CLK,IReturnFlags,Is_OUT_PC_RTI,Is_OUT_PC_INT,Save_In_Stack_INT,Save_IN_STACK_Flag,PC_From_interupt,Flags_From_Interupt,ReturnFalgs,ReturnedFlags,IsIntrRst,WB_MEM,IS_Swap_MEM,Reg_Dest_MEM,SRC_Swap_MEM,MEM_DEST_DATA,MEM_SRCSwap_DATA,MemoryIntrRstAddress,DataWrite,DataRead,Address_Data,Data_In,Data_OUT,Data_Miss,IsInProcessInterupt);
Hazard_Unit:HDU Generic Map(3) Port Map(DIS_Load_POP,HasS2,HasS1,FInstruction(21 downto 19),FInstruction(24 downto 22),DInstruction_OUT(2 downto 0),Hazard_Detected);
FWD_Unit:FW_Unit Generic Map(3) Port Map(SRC_Swap_MEM,EInstruction_OUT(8 downto 6),Reg_Dest_MEM,EInstruction_OUT(2 downto 0),DInstruction_Out(8 downto 6),DInstruction_Out(5 downto 3),EIs_Swap,IS_Swap_MEM,WB_MEM,EReg_Write,FWDA,FWDB);
IHU:InteruptUnit Port Map(INTR,DRTI,Clk,RST,IReturnFlags,Is_OUT_PC_RTI,Save_In_Stack_INT,Save_IN_STACK_Flag,Is_OUT_PC_INT,PC_ContentsS,FPC,DPC_out,FlagRegContentsS,Flags_From_Interupt,PC_From_interupt,DisableHandler,IsInProcessInterupt);
DataExtraMiss:OneBitBuffer port map(data_miss,data_miss_bufferd,CLK);
---Added 23/5/2020 Ahmed A.Allam ----Memory Cache Handling System-----------------
System_Memory_Cache:MemoryCacheSystem Port Map (DataRead,DataWrite,CLK,Address_Data,Address_Instruction,Data_In,Data_Miss,Instruction_Miss,Data_out,Instruction_OUT,Is_Interupted_Sequence);
----Added 24/5/2020 to hold data of RST and Interupt to read from Data Memory Ahmed A.Allam--------------


End AProcessorArch;
