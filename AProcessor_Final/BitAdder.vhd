
Library ieee;
Use ieee.std_logic_1164.all;

Entity BitAdder IS 
Port (A: In std_logic ;
B: In std_logic ; 
Cout : Out std_Logic;
Cin : In Std_logic;
Output: Out std_logic); 
End Entity BitAdder;

Architecture ArchBitAdder of BitAdder IS
Begin
Output <= A xor B Xor Cin;
Cout <= (A and B) or (cin and (A Xor B));
End ArchBitAdder; 