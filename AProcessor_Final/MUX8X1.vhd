LIBRARY IEEE;
Use ieee.std_logic_1164.all;

Entity MUXEightByOne IS 
Generic (n: integer :=32);
Port (Input1,Input2,Input3,Input4,Input5,Input6,Input7,Input8: In std_logic_vector (n-1 downto 0) ;
OutPut: Out std_logic_vector (n-1 downto 0) ;
Sel:IN std_logic_vector(2 downto 0)
); 
End Entity MUXEightByOne;
Architecture ArchMUXEightByOne of MUXEightByOne IS
Begin
Output<= Input1 when Sel="000"
else Input2 when Sel="001"
else Input3 when Sel="010"
else Input4 when Sel="011"
else Input5 when Sel="100"
else Input6 when Sel="101"
else Input7 when Sel="110"
else Input8;
End ArchMUXEightByOne;
