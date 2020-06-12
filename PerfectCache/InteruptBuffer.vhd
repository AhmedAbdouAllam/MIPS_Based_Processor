
--Author Ahmed A.Allam
--Date:26/2/2020
Library ieee;
Use ieee.std_logic_1164.all;

Entity InteruptBuffer IS 
port (
INTR_IN:IN Std_logic;
INTR_Out:OUT Std_Logic;

CLK,RST:IN std_Logic);
End Entity InteruptBuffer;


Architecture InteruptBufferArch of InteruptBuffer
IS 
Begin
Process(Clk,RST)
Begin
if RST='1' Then 
INTR_Out<='0';
ElsIF falling_edge (CLK) Then 
		INTR_Out<=INTR_IN;  
end IF;  
end Process;
End Architecture InteruptBufferArch;