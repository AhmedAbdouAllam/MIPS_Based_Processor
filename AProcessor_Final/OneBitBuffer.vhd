
--Author Ahmed A.Allam
--Date:26/2/2020
Library ieee;
Use ieee.std_logic_1164.all;

Entity OneBitBuffer IS 
port (
INPUT:IN Std_logic;
OUTPUT:OUT Std_Logic;

CLK:IN std_Logic);
End Entity OneBitBuffer;


Architecture OneBitBufferArch of OneBitBuffer
IS 
Begin
Process(Clk)
Begin
IF rising_edge (CLK) Then 
		OUTPUT<=INPUT;  
end IF;  
end Process;
End Architecture OneBitBufferArch;
