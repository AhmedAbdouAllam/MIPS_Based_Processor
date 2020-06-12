library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ALU IS
  GENERIC (n : integer := 32); 
  port(A,B : IN std_logic_vector(n-1 DOWNTO 0); 
    SEL : IN std_logic_vector(2 DOWNTO 0);
    ALU_EN : IN std_logic;
    IS_Shift : IN std_logic; 
    ALU_OUTPUT : OUT std_logic_vector(n-1 DOWNTO 0);
    Carry_Flag : OUT std_logic;
    Zero_Flag : OUT std_logic;
    Negative_Flag : OUT std_logic
);
   end ALU;

ARCHITECTURE My_ALU OF ALU IS

COMPONENT my_nadder IS
GENERIC (n : integer := 32); 
PORT (a,b : IN std_logic_vector(n-1 DOWNTO 0) ;
 cin : IN std_logic; 
 s : OUT std_logic_vector(n-1 DOWNTO 0); 
 cout : OUT std_logic);
END COMPONENT;

SIGNAL bmod : std_logic_vector(n-1 DOWNTO 0); --modified B operandd
SIGNAL myout : std_logic_vector(n-1 DOWNTO 0); --Output of Adder
SIGNAL cinmod : std_logic; --modified Cin 
SIGNAL mybit : std_logic; --Carry Flag
SIGNAL myshiftl : unsigned(n-1 DOWNTO 0);--output of shift fn
SIGNAL myshiftr : unsigned(n-1 DOWNTO 0);--output of shift fn
SIGNAL aluout : std_logic_vector(n-1 DOWNTO 0); --Output of Adder
--SIGNAL carryright : std_logic;
--SIGNAL carryleft : integer;



BEGIN

--carryright <=A(to_integer(unsigned(B))) WHEN ALU_EN='1' AND SEL="001" AND IS_Shift='1'
--ELSE '0';
--carryleft <=to_integer(unsigned(B))  WHEN ALU_EN='1' AND SEL="000" AND IS_Shift='1'
--ELSE 0;
myshiftl <= shift_left(unsigned(A),to_integer(unsigned(B))); 
myshiftr <= shift_right(unsigned(A),to_integer(unsigned(B))); 

bmod <= B WHEN SEL="000" --ADD UPDATED
ELSE NOT B WHEN SEL="001" --SUB UPDATED
ELSE (others=>'0') WHEN SEL="100" --INC UPDATED
ELSE (others=>'1') WHEN SEL="101" --DEC UPDATED
ELSE (others=>'0');

cinmod <= '0' WHEN SEL="000" --ADD UPDATED
ELSE '1' WHEN SEL="001" --SUB UPDATED
ELSE '1' WHEN SEL="100" --INC UPDATED
ELSE '0' WHEN SEL="101" --DEC UPDATED
ELSE '0';

u0: my_nadder GENERIC MAP (32) PORT MAP (A,bmod,cinmod,myout,mybit);

aluout <= A WHEN ALU_EN='0'
ELSE NOT A WHEN ALU_EN='1' AND SEL="110" AND IS_Shift='0' --UPDATED 
ELSE A AND B WHEN ALU_EN='1' AND SEL="010" AND IS_Shift='0' --UPDATED
ELSE A OR B WHEN ALU_EN='1' AND SEL="011" AND IS_Shift='0' --UPDATED
ELSE myout WHEN ALU_EN='1' AND SEL="000" AND IS_Shift='0' --ADD UPDATED
ELSE myout WHEN ALU_EN='1' AND SEL="001" AND IS_Shift='0' --SUB UPDATED
ELSE myout WHEN ALU_EN='1' AND SEL="100" AND IS_Shift='0' --INC UPDATED
ELSE myout WHEN ALU_EN='1' AND SEL="101" AND IS_Shift='0' --DEC UPDATED
ELSE std_logic_vector(myshiftl) WHEN ALU_EN='1' AND SEL="000" AND IS_Shift='1' --SHL UPDATED
ELSE std_logic_vector(myshiftr) WHEN ALU_EN='1' AND SEL="001" AND IS_Shift='1' --SHR UPDATED
ELSE (others=>'0');

Carry_Flag <= mybit WHEN ALU_EN='1' AND SEL="000" AND IS_Shift='0' --ADD UPDATED
ELSE mybit WHEN ALU_EN='1' AND SEL="001" AND IS_Shift='0' --SUB UPDATED
ELSE mybit WHEN ALU_EN='1' AND SEL="100" AND IS_Shift='0' --INC UPDATED
ELSE mybit WHEN ALU_EN='1' AND SEL="101" AND IS_Shift='0' --DEC UPDATED
ELSE A(n-to_integer(unsigned(B))) WHEN ALU_EN='1' AND SEL="000" AND IS_Shift='1' --SHL UPDATED
ELSE A(to_integer(unsigned(B))-1) WHEN ALU_EN='1' AND SEL="001" AND IS_Shift='1' --SHR UPDATED
ELSE '0'; 

ALU_OUTPUT <=aluout;

Negative_Flag <= '1' WHEN aluout(n-1)='1'
ELSE '0';

Zero_Flag <= '1' WHEN to_integer(unsigned(aluout))=0
ELSE '0';



END ARCHITECTURE My_ALU;