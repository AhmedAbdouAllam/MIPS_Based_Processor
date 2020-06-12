--Author Ahmed A.Allam
--Date:26/2/2020
Library ieee;
Use ieee.std_logic_1164.all;

Entity Outport IS 
Generic(n: integer :=16);
port (Input :IN std_logic_vector (n-1 downto 0);
Output :Out std_logic_vector (n-1 downto 0);
CLK,RST,Enable :IN std_Logic);
End Entity Outport;


Architecture OutportArch of Outport
IS 
Begin
Process(Clk,RST)
Begin
if RST='1' Then Output <= (Others =>'0');
ElsIF rising_edge (CLK) Then 
If Enable='1' then Output<= Input;
end If;
end IF;  
end Process;
End Architecture OutportArch;
