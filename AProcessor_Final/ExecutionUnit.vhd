LIBRARY IEEE;
Use ieee.std_logic_1164.all;
--The following Libraries are added after The edit
Use IEEE.Math_real.all;
Use IEEE.Numeric_std.all;
Entity ExecutionUnit IS 
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
End Entity ExecutionUnit;
Architecture ExecutionUnitUnitArch of ExecutionUnit IS
-------Component decleration of Execute Stage--------------------------------------
component MUXEightByOne IS 
Generic (n: integer :=32);
Port (Input1,Input2,Input3,Input4,Input5,Input6,Input7,Input8: In std_logic_vector (n-1 downto 0) ;
OutPut: Out std_logic_vector (n-1 downto 0) ;
Sel:IN std_logic_vector(2 downto 0)
); 
end component MUXEightByOne;

Component MUXFourByOne IS 
Generic (n: integer :=32);
Port (Input1,Input2,Input3,Input4: In std_logic_vector (n-1 downto 0) ;
OutPut: Out std_logic_vector (n-1 downto 0) ;
Sel:IN std_logic_vector(1 downto 0)
); 
End Component MUXFourByOne;

component FlagRegister IS 
port (
FlagRegisterEnable:In std_logic_vector (1 downto 0); 
--Here first one is zero and negative and the other is carry note that you have to modify CU OpCodes -Ahmed A.Allam-
ReturnFlags,CLR_sign,CLR_Carry,CLR_zero,RST,Set_Carry,CLK: in std_logic;
Returned_Saved_Flags:in std_logic_vector(2 downto 0);
Carry_Flag,Zero_flag,Neg_Flag :OUT std_Logic;
ALU_Zero_Flag,ALU_Carry_Flag,ALU_Neg_Flag:IN std_logic
);
End component FlagRegister;
Component MUXTwoByOne IS 
Generic (n: integer :=32);
Port (Input1,Input2: In std_logic_vector (n-1 downto 0) ;
OutPut: Out std_logic_vector (n-1 downto 0) ;
Sel:IN std_logic
); 
End Component MUXTwoByOne;

Component AndGate IS 
port (A,B:IN Std_Logic;
Output:OUT Std_Logic);
End Component AndGate;

Component OrGate IS 
port (
A,B:IN Std_Logic;
Output:OUT Std_Logic 
);
End Component OrGate;
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

Component ALU IS
  GENERIC (n : integer := 32); 
  port(A,B : IN std_logic_vector(n-1 DOWNTO 0); 
    SEL : IN std_logic_vector(2 DOWNTO 0);
    ALU_EN : IN std_logic;
    IS_Shift : IN std_logic; 
    ALU_OUTPUT : OUT std_logic_vector(n-1 DOWNTO 0);
    Carry_Flag : OUT std_logic;
    Zero_Flag : OUT std_logic;
    Negative_Flag : OUT std_logic
);
end Component ALU;


Component Outport IS 
Generic(n: integer :=16);
port (Input :IN std_logic_vector (n-1 downto 0);
Output :Out std_logic_vector (n-1 downto 0);
CLK,RST,Enable :IN std_Logic);
End Component Outport;
----------------------End Of Declerations------------------------------------------

signal Output_MUX_FWDA,Output_MUX_FWDB,ALU_Immediate_Output,Read_Data2x,ALU_OutputX,IMM_Shift_FULL:Std_logic_Vector(31 downto 0);
signal Confirmed_Zero_X,Confirmed_Neg_X,Confirmed_Carry_X,Confirmed_Branch_X,ZeroFlag,CarryFlag,NegFlag,OutPut_Or_CLR_Carry:Std_logic;
Signal Confirmed_Neg_Y,Confirmed_Carry_Y,Confirmed_Zero_Y : std_logic;
Signal ALU_Inport_Sel,IMM_Move:Std_logic_Vector (31 downto 0);
Signal OutputFlagsX:Std_Logic_Vector(2 downto 0);
signal MUX_IMM_SEL :std_Logic_vector(1 downto 0);
constant zeros :std_logic_Vector(31 downto 0):=X"00000000";
constant lowZeros :Std_Logic_Vector(26 downto 0):="000000000000000000000000000";
Constant HalfZeros :Std_Logic_Vector (15 downto 0):=X"0000";
---------------------------------------------------------------------------------
--Buffer Signals
Signal B_Control_In,B_Control_Out:Std_Logic_Vector( 16 downto 0);
Signal B_Data_In,B_Data_Out:Std_Logic_Vector(82 downto 0);
Signal B_InstructionIn,B_InstructionOut:Std_Logic_Vector(40 downto 0);
---------------------------------------------------------------------------------
Begin
IMM_Shift_FULL<=lowZeros&IMM_Shift_IN;
MUX_IMM_SEL<=Is_Shift_IN&Is_IMM_IN;
IMM_Move<=HalfZeros&IMM_Value_IN(15 downto 0);
-----------AddedComponents---------------------------------------------------------
OR_CLR_Carry :OrGate port Map(Clear_Carry_IN,Confirmed_Carry_Y,OutPut_Or_CLR_Carry);
CCR:FlagRegister port map(Flag_Change,ReturnFalgs,Confirmed_Neg_Y,OutPut_Or_CLR_Carry,Confirmed_Zero_Y,RST_FlagReg,Set_Carry_IN,CLK,ReturnedFlags,OutputFlagsX(2),OutputFlagsX(0),OutputFlagsX(1),ZeroFlag,CarryFlag,NegFlag);
MainALU:ALU generic map(32) port map(Output_MUX_FWDA,Read_Data2x,ALU_OP,ALU_Enable_IN,Is_Shift_IN,ALU_Immediate_Output,CarryFlag,ZeroFlag,NegFlag); 
Output_PortX:Outport generic map (32) port map(ALU_Immediate_Output,OUTPut_Port,CLK,RST_OUTPORT,Is_OutPort_IN);
MUX_Inport:MUXTwoByOne Generic Map(32) port map(ALU_Immediate_Output,INPUT_BUS,ALU_Inport_Sel,Is_InPort_IN);
AndConfirmedZero:AndGate Port map(OutputFlagsX(0),Is_Branch_Zero_IN,Confirmed_Zero_X);
AndConfirmedCarry:AndGate Port Map(OutputFlagsX(2),Is_Branch_Carry_IN,Confirmed_Carry_X);
AndConfirnedNeg:AndGate Port Map(OutputFlagsX(1),Is_Branch_Negative_In,Confirmed_Neg_X);
Confirmed_Branch_X<=Confirmed_Zero_X or Confirmed_Carry_X or Confirmed_Neg_X or Is_Branch_IN;
MUXFWDA:MUXEightByOne generic Map (32) port map(ReadData1_IN,EX_DEST_DATA,MEM_DEST_DATA,EX_DEST_DATA,EX_SRCSwap_DATA,MEM_DEST_DATA,MEM_SRCSwap_DATA,Zeros,Output_MUX_FWDA,FWDA);
MUXFWDB:MUXEightByOne generic Map (32) port map(ReadData2_IN,EX_DEST_DATA,MEM_DEST_DATA,EX_DEST_DATA,EX_SRCSwap_DATA,MEM_DEST_DATA,MEM_SRCSwap_DATA,Zeros,Output_MUX_FWDB,FWDB);
MUXIMM:MUXFourByOne generic Map (32) port map (Output_MUX_FWDB,IMM_Value_IN,IMM_Shift_FULL,zeros,Read_Data2x,MUX_IMM_SEL);
EX_MEM_Buffer:GeneralBuffer Generic Map(41,83,17) port map (B_InstructionIn,B_InstructionOut,B_Data_In,B_Data_Out,B_Control_In,B_Control_Out,CLK,RST_EX_MEM_Buffer,Disable_EX_MEM_Buffer);
MuxLDD:MUXTwoByOne Generic Map(32) port map(ALU_Inport_Sel,IMM_Move,ALU_OutputX,IsMove);
-------------------InputBufferSignalGrouping---------------------------------------
B_InstructionIn(31 downto 0)<=PC_IN;
B_InstructionIn(40 downto 32)<=Instruction_IN;
PC_OUT<=B_InstructionOut(31 downto 0);
Instruction_OUT<=B_InstructionOut(40 downto 32);

B_Data_In(31 downto 0)<=ALU_OutputX;
B_Data_In(63 downto 32)<=Read_Data2x;
B_Data_In(79 downto 64)<=IMM_Value_IN(15 downto 0);
B_Data_In(82 downto 80)<=OutputFlagsX;
ReadData1_OUT<=B_Data_Out(31 downto 0);
ReadData2_OUT<=B_Data_Out(63 downto 32);
IMM_Value_OUT<=B_Data_Out(79 downto 64);
OutputFlags<=B_Data_Out(82 downto 80);
FlagRegContents<=OutputFlagsX;
B_Control_In (0) <=PC_Change_in;
B_Control_In (1) <=RTI_in;
B_Control_In (2) <=Save_PC_in;
B_Control_In (3) <=Is_Swap_in;
B_Control_In (4) <=Is_InPort_in;
B_Control_In (5) <=Stack_Up_in;
B_Control_In (6) <=Stack_Down_in;
B_Control_In (7) <=Stack_Enable_in;
B_Control_In (8) <=Memory_Read_in;
B_Control_In (9) <=Memory_Write_in;
B_Control_In (10) <=Memory_To_Reg_in;
B_Control_In (11) <=Reg_Write_in;
B_Control_In (12) <=IS_Load_POP_in;
B_Control_In (13) <=Confirmed_branch_x;
B_Control_In (14) <=Confirmed_Zero_X;
B_Control_In (15) <=Confirmed_Neg_X;
B_Control_In (16) <=Confirmed_Carry_X;

PC_Change<=B_Control_Out (0) ;
RTI<=B_Control_Out (1) ;
Save_PC<=B_Control_Out (2) ;
Is_Swap<=B_Control_Out (3) ;
Is_InPort<=B_Control_Out (4) ;
Stack_Up<=B_Control_Out (5) ;
Stack_Down<=B_Control_Out (6) ;
Stack_Enable<=B_Control_Out (7) ;
Memory_Read<=B_Control_Out (8) ;
Memory_Write<=B_Control_Out (9) ;
Memory_To_Reg<=B_Control_Out (10) ;
Reg_Write<=B_Control_Out (11) ;
IS_Load_POP<=B_Control_Out (12) ;
Confirmed_branch<=B_Control_Out (13) ;
Reg_Write<=B_Control_Out (11) ;
IS_Load_POP<=B_Control_Out (12) ;
Confirmed_branch<=B_Control_Out (13) ;

Confirmed_Zero_Y<=B_Control_Out (14) ;
Confirmed_Neg_Y<=B_Control_Out (15) ;
Confirmed_Carry_Y<=B_Control_Out (16) ;
-------------------------------------------------------
End architecture ExecutionUnitUnitArch;