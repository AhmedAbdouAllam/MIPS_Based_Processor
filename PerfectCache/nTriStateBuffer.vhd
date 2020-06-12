--Author Ahmed A.Allam
--Date:26/2/2020
Library ieee;
Use ieee.std_logic_1164.all;

Entity nTriStateBuffer IS 
Generic(n: integer :=32);
port (Input :IN std_logic_vector (n-1 downto 0);
Output :Out std_logic_vector (n-1 downto 0);
Enable :IN std_Logic);
End Entity nTriStateBuffer;


Architecture nTriStateBufferArch of nTriStateBuffer
IS 
Begin
Output <= Input when Enable ='1'
Else (Others => 'Z') ;
End Architecture nTriStateBufferArch;
