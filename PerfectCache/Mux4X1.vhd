LIBRARY IEEE;
Use ieee.std_logic_1164.all;

Entity MUXFourByOne IS 
Generic (n: integer :=32);
Port (Input1,Input2,Input3,Input4: In std_logic_vector (n-1 downto 0) ;
OutPut: Out std_logic_vector (n-1 downto 0) ;
Sel:IN std_logic_vector(1 downto 0)
); 
End Entity MUXFourByOne;
Architecture ArchMUXFourByOne of MUXFourByOne IS
Begin
Output<= Input1 when Sel="00"
else Input2 when Sel="01"
else Input3 when Sel="10"
else Input4;
End ArchMUXFourByOne;
