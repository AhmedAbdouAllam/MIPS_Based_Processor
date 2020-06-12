--Author Ahmed A.Allam
--Date:26/2/2020
--
--
Library ieee;
Use ieee.std_logic_1164.all;

Entity SignExtend IS 
port (Input :IN std_logic_vector (15 downto 0);

Output :Out std_logic_vector (31 downto 0));
End Entity SignExtend;

--
--

Architecture SignExtendArch of SignExtend
IS 
Begin
Output(15 downto 0)<= Input;

Loop1: for i in 16 to 31 Generate
Begin
Output(i)<=Input(15);
End Generate;

End Architecture SignExtendArch;
