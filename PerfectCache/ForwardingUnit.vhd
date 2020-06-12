
library ieee;
use ieee.std_logic_1164.all;

entity FW_Unit IS
  GENERIC (n : integer := 3); 
  port(SRC_Swap_MEM,SRC_Swap_EX,Reg_Dest_MEM,Reg_Dest_EX,Reg_SRC_ADD1,Reg_SRC_ADD2 : IN std_logic_vector(n-1 DOWNTO 0) ;
     IS_Swap_EX,IS_Swap_MEM,WB_MEM,WB_EX : IN std_logic ;
     FWD_A,FWD_B : OUT std_logic_vector(2 DOWNTO 0));
   end FW_Unit;

ARCHITECTURE My_FW_Unit OF FW_Unit IS

BEGIN
  
FWD_A <="100" WHEN WB_EX ='1' AND IS_Swap_EX ='1' AND Reg_SRC_ADD1=SRC_Swap_EX
ELSE "011" WHEN WB_EX ='1' AND IS_Swap_EX ='1' AND Reg_SRC_ADD1=Reg_Dest_EX 
ELSE "001" WHEN WB_EX ='1' AND Reg_SRC_ADD1=Reg_Dest_EX
ELSE "110" WHEN WB_MEM ='1' AND IS_Swap_MEM ='1' AND Reg_SRC_ADD1=SRC_Swap_MEM
ELSE "101" WHEN WB_MEM ='1' AND IS_Swap_MEM ='1' AND Reg_SRC_ADD1=Reg_Dest_MEM
ELSE "010" WHEN WB_MEM ='1' AND Reg_SRC_ADD1=Reg_Dest_MEM
ELSE "000";

FWD_B <="100" WHEN WB_EX ='1' AND IS_Swap_EX ='1' AND Reg_SRC_ADD2=SRC_Swap_EX
ELSE "011" WHEN WB_EX ='1' AND IS_Swap_EX ='1' AND Reg_SRC_ADD2=Reg_Dest_EX 
ELSE "001" WHEN WB_EX ='1' AND Reg_SRC_ADD2=Reg_Dest_EX
ELSE "110" WHEN WB_MEM ='1' AND IS_Swap_MEM ='1' AND Reg_SRC_ADD2=SRC_Swap_MEM
ELSE "101" WHEN WB_MEM ='1' AND IS_Swap_MEM ='1' AND Reg_SRC_ADD2=Reg_Dest_MEM
ELSE "010" WHEN WB_MEM ='1' AND Reg_SRC_ADD2=Reg_Dest_MEM
ELSE "000";

END ARCHITECTURE My_FW_Unit;

 





