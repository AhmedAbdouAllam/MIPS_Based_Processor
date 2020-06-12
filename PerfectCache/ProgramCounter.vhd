--Author Ahmed A.Allam
--Date:26/2/2020
Library ieee;
Use ieee.std_logic_1164.all;

Entity ProgramCounter IS 
Generic(n: integer :=32);
port (Input :IN std_logic_vector (n-1 downto 0);
Output :Out std_logic_vector (n-1 downto 0):=(Others=>'0');
CLK,Disable :IN std_Logic);
End Entity ProgramCounter;


Architecture ProgramCounterArch of ProgramCounter
IS 
Begin
Process(Clk)
Begin
	IF rising_edge (CLK) Then 
	If Disable='0' then Output<= Input;
end If;
end IF;  
end Process;
End Architecture ProgramCounterArch;
