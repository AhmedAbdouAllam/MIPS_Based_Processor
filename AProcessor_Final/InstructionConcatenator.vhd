
--Author Ahmed A.Allam
--Date:26/2/2020
--
--

Library ieee;
Use ieee.std_logic_1164.all;

--
-- 24 23 22 -21 20 19 -18 17 16
--8 7 6 -- 5 4 3 -- 2 1 0
Entity InstructionConcatenator IS 
port (InputInstruction :IN std_logic_vector (8 downto 0);
SrcIsDest,IsSwap: IN Std_logic;
OutputInstruction :Out std_logic_vector (8 downto 0));
End Entity InstructionConcatenator;

--
--

Architecture InstructionConcatenatorArch of InstructionConcatenator
IS 
Begin
OutputInstruction(8 downto 6)<=InputInstruction(8 downto 6);
OutputInstruction(5 downto 3)<= InputInstruction (5 downto 3) when isSwap='0'
else InputInstruction (2 downto 0) when IsSwap='1';

OutputInstruction(2 downto 0)<= InputInstruction (8 downto 6) when SrcIsDest='1'
else InputInstruction (2 downto 0) when SrcIsDest='0';

End Architecture InstructionConcatenatorArch;