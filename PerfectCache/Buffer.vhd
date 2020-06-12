--Author Ahmed A.Allam
--Date:26/2/2020
Library ieee;
Use ieee.std_logic_1164.all;

Entity IFBuffer IS 
Generic(InstructionPortSize: integer :=64);
port (Input :IN std_logic_vector (InstructionPortSize-1 downto 0);
Output :Out std_logic_vector (InstructionPortSize-1 downto 0);
CLK,RST,Disable:IN std_Logic);
End Entity IFBuffer;


Architecture IFBufferArch of IFBuffer
IS 
Begin
Process(Clk,RST)
Begin
if falling_edge (CLK) Then
if Disable='0' then 
		Output<= Input;
end IF;  
ElsIF RST='1' Then Output <= (Others =>'0');
end IF;  
end Process;
End Architecture IFBufferArch;
