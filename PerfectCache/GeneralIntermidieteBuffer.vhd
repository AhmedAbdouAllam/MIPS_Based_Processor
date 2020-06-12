--Author Ahmed A.Allam
--Date:26/2/2020
Library ieee;
Use ieee.std_logic_1164.all;

Entity GeneralBuffer IS 
Generic(InstructionPortSize: integer :=4 ;DataPortSize:integer :=4  ; ControlPortSize:integer :=4 );
port (
InputInstruction :IN std_logic_vector (InstructionPortSize-1 downto 0);
OutputInstruction :Out std_logic_vector (InstructionPortSize-1 downto 0);

InputData :IN std_logic_vector (DataPortSize-1 downto 0);
OutputData :Out std_logic_vector (DataPortSize-1 downto 0);

InputControl :IN std_logic_vector (ControlPortSize-1 downto 0);
OutputControl :Out std_logic_vector (ControlPortSize-1 downto 0);

CLK,RST,Disable:IN std_Logic);
End Entity GeneralBuffer;


Architecture GeneralBufferArch of GeneralBuffer
IS 
Begin
Process(Clk,RST)
Begin
if RST='1' Then OutputControl <= (Others =>'0');
OutputData <= (Others =>'0');
OutputInstruction <= (Others =>'0');
ElsIF falling_edge (CLK) Then 
		if Disable='0' then
		OutputControl<= InputControl;
		OutputData<= InputData;
		OutputInstruction<= InputInstruction;
end IF;  
end IF;  
end Process;
End Architecture GeneralBufferArch;
