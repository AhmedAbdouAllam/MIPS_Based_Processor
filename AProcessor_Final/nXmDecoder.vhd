--Author Ahmed A.Allam
--Date:26/2/2020
--Edited:27/2/2020 Original Code Edited Parts are Commented
--The code is edited to make a generic Decoder instead of 2X4 Decoder 
--You can find the old file saved as nXmDecoderCopy.VHD

--
--

Library ieee;
Use ieee.std_logic_1164.all;
--The following Libraries are added after The edit
Use IEEE.Math_real.all;
Use IEEE.Numeric_std.all;
--
--

Entity nXmDecoder IS 
Generic(m: integer :=16); --Where n here is the number of Outputs
port (Input :IN std_logic_vector ((Natural(log2(real(m)))-1) downto 0);
Enable: IN Std_logic;
Output :Out std_logic_vector (m-1 downto 0));
End Entity nXmDecoder;

--
--

Architecture nXmDecoderArch of nXmDecoder
IS 
--Signal X : Std_Logic_vector (Natural(log2(real(n))) downto 0);
Begin
--X(Natural(log2(real(n)))<=Enable;
--X(((Natural(log2(real(n)))-1) downto 0)<=Input;
--With X Select
--Output <="0001" when "100",
--"0010" when "101",
--"0100" when "110",
--"1000" when "111",
--"0000" when Others;
Output<= (Natural(to_integer(Unsigned(Input)))=>'1',Others=>'0') when Enable='1'
Else (Others=>'0');
End Architecture nXmDecoderArch;