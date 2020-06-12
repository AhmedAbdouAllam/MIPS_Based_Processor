LIBRARY IEEE;
Use ieee.std_logic_1164.all;

Entity MemAndWBUnits IS 
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
	Write_Data1,Write_Data2,MemoryBranchAddress:Out Std_logic_Vector (31 downto 0)
); 
End Entity MemAndWBUnits;
Architecture MemAndWBUnitsArch of MemAndWBUnits IS
----------------Components----------------------
Component DataMemory IS
Generic(n: integer :=6 ; m: integer:=32);
PORT 
(
	clk : IN std_logic;
	MemoryWrite : IN std_logic;
	Address : IN std_logic_vector(n-1 DOWNTO 0);
	Input : IN std_logic_vector(2*m-1 DOWNTO 0);
	Output : OUT std_logic_vector(2*m-1 DOWNTO 0)  
);
END Component DataMemory;
Component StackPointer IS 
port (Sp_UP,SP_Down,RST,CLK: IN std_logic;
Output :Out std_logic_vector (31 downto 0));
End Component StackPointer;
Component MUXTwoByOne IS 
Generic (n: integer :=32);
Port (Input1,Input2: In std_logic_vector (n-1 downto 0) ;
OutPut: Out std_logic_vector (n-1 downto 0) ;
Sel:IN std_logic
); 
End Component MUXTwoByOne;
Component AdderFetch IS 
Generic (n: integer :=32);
Port (A: In std_logic_vector (n-1 downto 0) ;
B: In std_logic_vector (n-1 downto 0) ;
F: Out std_logic_vector (n-1 downto 0)); 
End Component AdderFetch;

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



--------------------------EndOfComponents-------------------------
Signal SP_output_Address :Std_Logic_Vector (31 downto 0);
signal Stack_UP,Stack_Down,PreFinalSelector:std_Logic;
Signal EA_Store,EA_Load,Selected_EA:Std_Logic_Vector(31 downto 0);
Signal PreFinalAddress,AfterInterupt,FinalAddress:Std_Logic_Vector(31 downto 0);
Signal Added_PC,ALU_PC,PC_Flag,FlagsToSave,FinalData:Std_Logic_Vector(31 downto 0);
Signal MemoryRead,MemoryWrite: Std_Logic;
--------------------------Signals---------------------------------
Constant StoreZeros:Std_Logic_Vector(11 downto 0):="000000000000";
Constant InteruptAddress: Std_logic_Vector(31 downto 0):=X"00000002";
Constant RstAddress: Std_logic_Vector(31 downto 0):=X"00000000";
Constant One:Std_logic_Vector(31 downto 0):=X"00000001";
Constant FlagZeros:Std_logic_Vector(28 downto 0):="00000000000000000000000000000";
--------------------------Buffered Signals ---------------------------------------
Signal MemDatax,MemDatay,ALUOutPut_Y:Std_logic_Vector(31 downto 0);
Signal isINTRx:Std_logic;
Signal B_Control_In,B_Control_Out,B_Control_x:Std_Logic_Vector(3 downto 0);
Signal B_Data_In,B_Data_Out:Std_Logic_Vector(99 downto 0);
Signal B_InstructionIn,B_InstructionOut:Std_Logic_Vector(5 downto 0);
Signal Memory_To_Reg_y:Std_logic;
Signal	Flags_From_Interupt_Out:Std_Logic_Vector(2 downto 0);
--------------------------EndOfSignals----------------------------

Begin
-------------------------Getting Address-------------------------------------------------------
Stack_UP<=Stack_Up_In or Is_OUT_PC_RTI or ReturnFlags;
Stack_Down<=Stack_Down_In or Save_In_Stack_INT;
PreFinalSelector<=Stack_Enable_In or Save_In_Stack_INT or ReturnFlags or Is_OUT_PC_RTI;
EA_Store<= StoreZeros&Instruction_In(3 downto 0)&IMM_Value_IN;
EA_Load<=StoreZeros&Instruction_In(6 downto 3)&IMM_Value_IN;
FlagsToSave<=FlagZeros&Flags_From_Interupt;
Flags_From_Interupt_Out<=MemDatax(2 downto 0);
---Added_Components-----
SP:StackPointer port map(Stack_UP,Stack_Down,RST,CLK,SP_output_Address);
MUX_Load_Store:MUXTwoByOne generic map(32) Port Map(EA_Store,EA_Load,Selected_EA,Memory_Read_In);
Mux_PreFinalAddress:MUXTwoByOne generic map(32) Port Map(Selected_EA,SP_output_Address,PreFinalAddress,PreFinalSelector);
Mux_InteruptedAddress:MUXTwoByOne generic map(32) Port Map(PreFinalAddress,InteruptAddress,AfterInterupt,Is_OUT_PC_INT);
Mux_RstAddress:MUXTwoByOne generic map(32) Port Map(AfterInterupt,RstAddress,FinalAddress,RST);
-------------------------Getting Data---------------------------------------------------------
Adder_PC:AdderFetch generic map (32) port map(PC_IN,One,Added_PC);
Mux_ALU_PC:MUXTwoByOne generic map(32) Port Map(ReadData1_IN,Added_PC,ALU_PC,Save_PC_In);
MUX_PC_Flag:MUXTwoByOne generic map(32) Port Map(PC_From_interupt,FlagsToSave,PC_Flag,Save_IN_STACK_Flag);
Mux_Data_Final:MUXTwoByOne generic map(32) Port Map(ALU_PC,PC_Flag,FinalData,Save_In_Stack_INT);
--------------------------------The following you must do when you replace with cache A.Allam--------------
---1) you have to change memory size with the documented 2)You have to get the miss signal V.I 3)you have to use the memory read signal that will be ignored for now
MemoryRead<= Memory_Read_In or RST or ReturnFlags or Is_OUT_PC_RTI or Is_OUT_PC_INT;  ---VI A.Allam---not used as for now--
MemoryWrite<=Memory_Write_In or Save_In_Stack_INT;
DataMemoryNoChache: DataMemory Generic Map(11,16) Port Map(CLK,MemoryWrite,FinalAddress(10 downto 0),FinalData,MemDatax);
isINTRx<=PC_Change_In or Is_OUT_PC_RTI or Is_OUT_PC_INT or RST;
MEMWB_Buffer:GeneralBuffer Generic Map (6,100,4) Port Map(B_InstructionIn,B_InstructionOut,B_Data_In,B_Data_Out,B_Control_x,B_Control_Out,CLK,'0','0');
B_Control_IN(0)<=Memory_To_Reg_In;
B_Control_IN(1)<=Reg_Write_In;
B_Control_IN(2)<=Is_Swap_In;
B_Control_IN(3)<=ReturnFlags;
B_Control_x<=B_Control_IN when RST='0'
else (Others=>'0');
B_Data_In(31 downto 0)<=MemDatax;
B_Data_In(63 downto 32)<=ReadData1_IN;
B_Data_In(95 downto 64)<=ReadData2_IN;
B_Data_In(98 downto 96)<=Flags_From_Interupt_Out;
B_Data_In(99)<=isINTRx;
B_InstructionIn (2 downto 0)<=Instruction_In(2 downto 0);
B_InstructionIn (5 downto 3)<=Instruction_In(8 downto 6);
Memory_To_Reg_y<=B_Control_OUT(0);
Write_Enable1<=B_Control_OUT(1);
Write_Enable2<=B_Control_OUT(2) ;
ReturnFlags_Out<=B_Control_OUT(3);
MEMDataY<=B_Data_OUT(31 downto 0);
ALUOutPut_Y<=B_Data_OUT(63 downto 32);
Write_Data2<=B_Data_OUT(95 downto 64);
Flags_From_Interupt_Out_ToCircuit <=B_Data_OUT(98 downto 96);
is_INTR_RST <=B_Data_OUT(99);
Wr_Add1 <=B_InstructionOut (2 downto 0);
 Wr_Add2 <=B_InstructionOut (5 downto 3);
MemoryBranchAddress<= MEMDataY;
Mux_FinalWriteback:MUXTwoByOne generic map(32) Port Map(ALUOutPut_Y,MEMDataY,Write_Data1,Memory_To_Reg_y);

End MemAndWBUnitsArch;
