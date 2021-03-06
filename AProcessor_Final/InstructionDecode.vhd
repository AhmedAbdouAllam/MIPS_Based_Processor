
LIBRARY IEEE;
Use ieee.std_logic_1164.all;
--The following Libraries are added after The edit
Use IEEE.Math_real.all;
Use IEEE.Numeric_std.all;
Entity InstructionDecodingUnit IS 
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
End Entity InstructionDecodingUnit;
Architecture InstructionDecodingUnitArch of InstructionDecodingUnit IS
-------Component decleration of Decode Stage--------------------------------------

Component ControlUnit is 
	port (
	ip: IN std_logic_vector (6 downto 0);
	disable: IN std_logic;
	PC_Change,RTI,Is_Shift,Is_OutPort,Save_PC,Is_Swap,SourceIsDest,Is_InPort,Stack_Up,Stack_Down,Is_IMM,Stack_Enable,Memory_Read,Memory_Write,Is_Branch_Zero,Memory_To_Reg,Reg_Write,Is_Branch_Negative,Is_Branch_Carry,ALU_Enable,Is_Branch,Set_Carry,Clear_Carry,Has_SRC2,Has_SRC1,IS_Load_POP: OUT std_logic;
	ALU_OP: OUT std_logic_vector (2 downto 0);
	Flag_Change: OUT std_logic_vector (1 downto 0);
	IsMove:Out Std_logic
);
end Component ControlUnit;
---

Component RegFile IS 
Generic(n: integer :=32 ; m:integer:=8);
port (
	DataBusXRd,DataBusYRd: Out Std_Logic_Vector (n-1 downto 0);
	DataBusXWr,DataBusYWr: In Std_Logic_Vector (n-1 downto 0);
	CLK,Rst,EnableWrX,EnableWrY :In Std_Logic;
	ReadAddressX ,WriteAddressX,ReadAddressY ,WriteAddressY :IN Std_Logic_Vector ((Natural(log2(real(m)))-1) downto 0); ----To  be edited
	RegContents0,RegContents1,RegContents2,RegContents3,RegContents4,RegContents5,RegContents6,RegContents7:Out std_Logic_Vector(n-1 downto 0)
);
End Component RegFile;
------
Component GeneralBuffer IS 
Generic(InstructionPortSize: integer :=4 ;DataPortSize:integer :=4  ; ControlPortSize:integer :=4 );
port (
	InputInstruction :IN std_logic_vector (InstructionPortSize-1 downto 0);
	OutputInstruction :Out std_logic_vector (InstructionPortSize-1 downto 0);

	InputData :IN std_logic_vector (DataPortSize-1 downto 0);
	OutputData :Out std_logic_vector (DataPortSize-1 downto 0);

	InputControl :IN std_logic_vector (ControlPortSize-1 downto 0);
	OutputControl :Out std_logic_vector (ControlPortSize-1 downto 0);

	CLK,RST,Disable:IN std_Logic);
End Component GeneralBuffer;
---
Component MUXTwoByOne IS 
	Generic (n: integer :=32);
	Port (Input1,Input2: In std_logic_vector (n-1 downto 0) ;
	OutPut: Out std_logic_vector (n-1 downto 0) ;
	Sel:IN std_logic
); 
End Component MUXTwoByOne;
---
Component InstructionConcatenator IS 
	port (InputInstruction :IN std_logic_vector (8 downto 0);
	SrcIsDest,IsSwap: IN Std_logic;
	OutputInstruction :Out std_logic_vector (8 downto 0));
End Component InstructionConcatenator;
------
Component SignExtend IS 
port (
	Input :IN std_logic_vector (15 downto 0);
	Output :Out std_logic_vector (31 downto 0));
End Component SignExtend;
------------------Signals Used---------------------------------------------------
Signal ReadData1x,ReadData2x,IMMx: Std_Logic_Vector(31 downto 0);
Signal IMM_Shiftx :Std_Logic_vector (4 downto 0);
Signal Instructionx:Std_Logic_Vector(8 downto 0);
signal MUX_Out:Std_Logic_Vector(2 downto 0);
--CU Signals
Signal PC_Changex,RTIx,Is_Shiftx,Is_OutPortx,Save_PCx,Is_Swapx,SourceIsDestx,Is_InPortx,Stack_Upx,Stack_Downx,Is_IMMx,Stack_Enablex,Memory_Readx,Memory_Writex,Is_Branch_Zerox,Memory_To_Regx,Reg_Writex,Is_Branch_Negativex,Is_Branch_Carryx,ALU_Enablex,Is_Branchx,Set_Carryx,Clear_Carryx,Has_SRC2x,Has_SRC1x,IS_Load_POPx:  std_logic;
Signal ALU_OPx:  std_logic_vector (2 downto 0);
Signal Flag_Changex:  std_logic_vector (1 downto 0);
Signal isMovex:std_logic;
-----------Update sizes and Update Generic Map of Buffer at the end....
Signal B_Control_In,B_Control_Out,B_Control_x:Std_Logic_Vector(31 downto 0);
constant Zero_Control:Std_Logic_Vector(31 downto 0):="00000000000000000000000000000000";
Signal B_Data_In,B_Data_Out:Std_Logic_Vector(100 downto 0);
Signal B_InstructionIn,B_InstructionOut:Std_Logic_Vector(40 downto 0);
Signal ModifiedInstruction :Std_logic_vector (6 downto 0);
Signal ModifiedDisable:Std_logic;
----------------------End Of Declerations------------------------------------------
Begin
-----------AddedComponents---------------------------------------------------------
Concatenator:InstructionConcatenator Port Map(Instruction_IN(24 downto 16),SourceIsDestx,Is_Swapx,Instructionx);
Data_Address_Two_Mux:MUXTwoByOne Generic Map(3) Port Map(Instruction_In(21 downto 19),Instruction_IN(18 downto 16),Mux_Out,Is_Swapx);
Main_Reg_File:RegFile Generic Map(32,8) Port Map(ReadData1x,ReadData2x,Wr_DataX,Wr_DataY,CLK,RST_REG_File,Wr_EnableX,Wr_EnableY,Instruction_IN(24 downto 22),Wr_ADDx,Mux_Out,Wr_ADDy,RegContents0,RegContents1,RegContents2,RegContents3,RegContents4,RegContents5,RegContents6,RegContents7);
IMM_Sign_Extend:SignExtend Port Map(Instruction_IN(15 downto 0),IMMx);
Main_Control_Unit:ControlUnit port map(Instruction_IN(31 downto 25),'0',PC_Changex,RTIx,Is_Shiftx,Is_OutPortx,Save_PCx,Is_Swapx,SourceIsDestx,Is_InPortx,Stack_Upx,Stack_Downx,Is_IMMx,Stack_Enablex,Memory_Readx,Memory_Writex,Is_Branch_Zerox,Memory_To_Regx,Reg_Writex,Is_Branch_Negativex,Is_Branch_Carryx,ALU_Enablex,Is_Branchx,Set_Carryx,Clear_Carryx,Has_SRC2x,Has_SRC1x,IS_Load_POPx,ALU_OPx,Flag_Changex,IsMovex);
ID_EX_Buffer:GeneralBuffer generic map (41,101,32) port map(B_InstructionIn,B_InstructionOut,B_Data_In,B_Data_Out,B_Control_x,B_Control_Out,CLK,ID_EX_RST,ID_EX_Disable);
MUXCU:MUXTwoByOne Generic Map(32) port map(B_Control_In,Zero_Control,B_Control_x,CU_Disable);
-------------------InputBufferSignalGrouping---------------------------------------
B_InstructionIn(31 downto 0)<=PC_in;
B_InstructionIn(40 downto 32)<=Instructionx;
IMM_Shiftx<=Instruction_IN(20 downto 16);
B_Data_In (31 downto 0)<=ReadData1x;
B_Data_In (63 downto 32)<=ReadData2x;
B_Data_In (95 downto 64)<=IMMx;
B_Data_In (100 downto 96)<=IMM_Shiftx;
B_Control_In (0) <=PC_Changex;
B_Control_In (1) <=RTIx;
B_Control_In (2) <=Is_Shiftx;
B_Control_In (3) <=Is_OutPortx;
B_Control_In (4) <=Save_PCx;
B_Control_In (5) <=Is_Swapx;
B_Control_In (6) <=SourceIsDestx;
B_Control_In (7) <=Is_InPortx;
B_Control_In (8) <=Stack_Upx;
B_Control_In (9) <=Stack_Downx;
B_Control_In (10) <=Is_IMMx;
B_Control_In (11) <=Stack_Enablex;
B_Control_In (12) <=Memory_Readx;
B_Control_In (13) <=Memory_Writex;
B_Control_In (14) <=Is_Branch_Zerox;
B_Control_In (15) <=Memory_To_Regx;
B_Control_In (16) <=Reg_Writex;
B_Control_In (17) <=Is_Branch_Negativex;
B_Control_In (18) <=Is_Branch_Carryx;
B_Control_In (19) <=ALU_Enablex;
B_Control_In (20) <=Is_Branchx;
B_Control_In (21) <=Set_Carryx;
B_Control_In (22) <=Clear_Carryx;
Extra_Has_Src1<=Has_SRC1x;
Extra_Has_Src2<=Has_SRC2x;
B_Control_In (23) <=Has_SRC2x;
B_Control_In (24) <=Has_SRC1x;
B_Control_In (25) <=IS_Load_POPx;
B_Control_In (26) <=ALU_OPx(2);
B_Control_In (27) <=ALU_OPx(1);
B_Control_In (28) <=ALU_OPx(0);
B_Control_In (29) <=Flag_Changex(1);
B_Control_In (30) <=Flag_Changex(0);
B_Control_In (31) <=IsMovex;
-------------------------------------
-------------------OutputBufferSignalUnGrouping--------------------------------------
PC_OUT<=B_InstructionOut(31 downto 0);
Instruction_Out<=B_InstructionOut(40 downto 32);
ReadData1<=B_Data_out (31 downto 0);
ReadData2<=B_Data_out (63 downto 32);
IMM_Value<=B_Data_out (95 downto 64);
IMM_Shift<=B_Data_OUT(100 downto 96);
PC_Change<=B_Control_Out (0) ;
RTI<=B_Control_Out (1) ;
Is_Shift<=B_Control_Out (2) ;
Is_OutPort<=B_Control_Out (3) ;
Save_PC<=B_Control_Out (4) ;
Is_Swap<=B_Control_Out (5) ;
SourceIsDest<=B_Control_Out (6) ;
Is_InPort<=B_Control_Out (7) ;
Stack_Up<=B_Control_Out (8) ;
Stack_Down<=B_Control_Out (9) ;
Is_IMM<=B_Control_Out (10) ;
Stack_Enable<=B_Control_Out (11) ;
Memory_Read<=B_Control_Out (12) ;
Memory_Write<=B_Control_Out (13) ;
Is_Branch_Zero<=B_Control_Out (14) ;
Memory_To_Reg<=B_Control_Out (15) ;
Reg_Write<=B_Control_Out (16) ;
Is_Branch_Negative<=B_Control_Out (17) ;
Is_Branch_Carry<=B_Control_Out (18) ;
ALU_Enable<=B_Control_Out (19) ;
Is_Branch<=B_Control_Out (20) ;
Set_Carry<=B_Control_Out (21) ;
Clear_Carry<=B_Control_Out (22) ;
Has_SRC2<=B_Control_Out (23) ;
Has_SRC1<=B_Control_Out (24) ;
IS_Load_POP<=B_Control_Out (25) ;
ALU_OP(2)<=B_Control_Out (26) ;
ALU_OP(1)<=B_Control_Out (27) ;
ALU_OP(0)<=B_Control_Out (28) ;
Flag_Change(1)<=B_Control_Out (29) ;
Flag_Change(0)<=B_Control_Out (30) ;
IsMove<=B_Control_Out (31) ;
-------------------------------------------------------
End InstructionDecodingUnitArch;