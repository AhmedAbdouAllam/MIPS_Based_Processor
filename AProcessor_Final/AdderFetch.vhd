Library ieee;
Use ieee.std_logic_1164.all;

Entity AdderFetch IS 
Generic (n: integer :=32);
Port (A: In std_logic_vector (n-1 downto 0) ;
B: In std_logic_vector (n-1 downto 0) ;
F: Out std_logic_vector (n-1 downto 0)); 
End Entity AdderFetch;

Architecture ArchAdderFetch of AdderFetch IS
Component BitAdder IS
Port ( A: In std_logic ;
B: In std_logic ; 
Cout : Out std_Logic;
Cin : In Std_logic;
Output: Out std_logic); 
End Component BitAdder;
Signal Expand: Std_Logic_Vector (n-1 downto 0);
Begin
B0Adder: BitAdder Port Map(A(0),B(0),Expand(0),'0',F(0));
Loop1: for i in 1 to n-1 Generate
BxAdder: BitAdder Port Map (A(i),B(i),Expand(i),Expand(i-1),F(i));
End Generate;
End ArchAdderFetch; 
