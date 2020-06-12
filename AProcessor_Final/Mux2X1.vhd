LIBRARY IEEE;
Use ieee.std_logic_1164.all;

Entity MUXTwoByOne IS 
Generic (n: integer :=32);
Port (Input1,Input2: In std_logic_vector (n-1 downto 0) ;
OutPut: Out std_logic_vector (n-1 downto 0) ;
Sel:IN std_logic
); 
End Entity MUXTwoByOne;
Architecture ArchMUXTwoByOne of MUXTwoByOne IS
Begin
Output<= Input1 when Sel='0'
else Input2;
End ArchMUXTwoByOne;