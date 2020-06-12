LIBRARY IEEE;
Use ieee.std_logic_1164.all;

Entity InstructionFetchingUnit IS 
Port (
Branch_Address,MemoryIntrRstAddress: In Std_Logic_vector (31 downto 0);
ConfirmedBranch,IsIntrRst,RSTBufferIF_ID,PC_Disable,CLK,INT,DisableBufferIF_ID:In Std_Logic;
PC,Instruction :Out Std_Logic_vector (31 downto 0);
PC_content:Out Std_Logic_vector (31 downto 0)
); 
End Entity InstructionFetchingUnit;
Architecture InstructionFetchingUnitArch of InstructionFetchingUnit IS
----------------Components----------------------
Component AdderFetch IS 
	Generic (n: integer :=32);
	Port (A: In std_logic_vector (n-1 downto 0) ;
	B: In std_logic_vector (n-1 downto 0) ;
	F: Out std_logic_vector (n-1 downto 0)); 
End Component AdderFetch;

Component ProgramCounter IS 
	Generic(n: integer :=32);
	port (Input :IN std_logic_vector (n-1 downto 0);
	Output :Out std_logic_vector (n-1 downto 0);
	CLK,Disable :IN std_Logic);
End Component ProgramCounter;

Component IFBuffer IS 
	Generic(InstructionPortSize: integer :=64);
	port (Input :IN std_logic_vector (InstructionPortSize-1 downto 0);
	Output :Out std_logic_vector (InstructionPortSize-1 downto 0);
	CLK,RST,Disable:IN std_Logic);
End Component IFBuffer;

Component InstructionMemory IS
Generic(n: integer :=20 ; m: integer:=16);
PORT 
(
	Address : IN std_logic_vector(n-1 DOWNTO 0);
	Output : OUT std_logic_vector(2*m-1 DOWNTO 0)
);
END Component InstructionMemory;
Component MUXTwoByOne IS 
Generic (n: integer :=32);
	Port (Input1,Input2: In std_logic_vector (n-1 downto 0) ;
	OutPut: Out std_logic_vector (n-1 downto 0) ;
	Sel:IN std_logic
); 
End Component MUXTwoByOne;
--------------------------EndOfComponents-------------------------

--------------------------Signals---------------------------------
Signal Out_MUX_ToADD,Out_MUX_INTR_RST,OUT_ADDER,Out_MUX_Branch,PCx,Instructionx :Std_logic_Vector(31 downto 0) ;
constant One :Std_Logic_Vector(31 downto 0):=X"00000001";
constant Two :Std_Logic_Vector(31 downto 0):=X"00000002";
signal Input_IF_ID,Output_IF_ID :STD_LOGIC_VECTOR(63 downto 0);
--------------------------EndOfSignals----------------------------

Begin
---Added_Components-----
Adder: AdderFetch Generic Map(32) Port Map(PCx,Out_MUX_ToADD,OUT_ADDER);
--------------------------
Mux_Branch:MUXTwoByOne Port Map(Out_ADDER,Branch_Address,Out_MUX_Branch,ConfirmedBranch);
Mux_INTR_RST:MUXTwoByOne Port Map(Out_MUX_Branch,MemoryIntrRstAddress,Out_MUX_INTR_RST,IsIntrRst);
Mux_Adder:MUXTwoByOne Port Map(One,Two,Out_MUX_ToADD,Instructionx(31));
--------------------------------
ProgCounter:ProgramCounter generic MAP (32) Port Map(Out_MUX_INTR_RST,PCx,CLK,PC_Disable);
-------------Input Address Will be changed when the size is Modified---------------
-------------But leave it for now as it is A.Allam---------------------------------
InstrMem:InstructionMemory Generic Map(11,16) Port Map(Pcx(10 downto 0),Instructionx);
Input_IF_ID(63 downto 32)<=Instructionx;
Input_IF_ID(31 downto 0)<=PCx;
Instruction<=Output_IF_ID(63 downto 32);
PC<=Output_IF_ID(31 downto 0);
PC_content<=PCX;
IF_ID_Buffer: IFBuffer Generic Map(64) Port Map (Input_IF_ID,Output_IF_ID,CLK,RSTBufferIF_ID,DisableBufferIF_ID);
End InstructionFetchingUnitArch;
