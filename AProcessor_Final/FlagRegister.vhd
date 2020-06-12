--Author Ahmed A.Allam
--Date:26/2/2020
Library ieee;
Use ieee.std_logic_1164.all;

Entity FlagRegister IS 
port (
FlagRegisterEnable:In std_logic_vector (1 downto 0); 
--Here first one is zero and negative and the other is carry note that you have to modify CU OpCodes -Ahmed A.Allam-
ReturnFlags,CLR_sign,CLR_Carry,CLR_zero,RST,Set_Carry,CLK: in std_logic;
Returned_Saved_Flags:in std_logic_vector(2 downto 0);
Carry_Flag,Zero_flag,Neg_Flag :OUT std_Logic;
ALU_Zero_Flag,ALU_Carry_Flag,ALU_Neg_Flag:IN std_logic
);
End Entity FlagRegister;


Architecture FlagRegisterArch of FlagRegister
IS 
Begin
Process(Clk,RST)
Begin
if RST='1' Then 
Carry_Flag<='0';
Zero_flag<='0';
Neg_Flag<='0';
ElsIF rising_edge (CLK) Then 
--------------------------------------------
If ReturnFlags='1' then 
Carry_Flag<=Returned_Saved_Flags(2);
Zero_flag<=Returned_Saved_Flags(0);
Neg_Flag<=Returned_Saved_Flags(1);
ElsIF Set_Carry='1' and CLR_Zero='0'and CLR_sign='0' then Carry_Flag<='1';
ElsIF Set_Carry='1' and CLR_Zero='1'and CLR_sign='0' then
Carry_Flag<='1';
Zero_Flag<='0';
ElsIF Set_Carry='1' and CLR_Zero='0'and CLR_sign='1' then
Carry_Flag<='1';
Neg_Flag<='0';
ELSIF FlagRegisterEnable="10" and CLR_Carry='0' then 
Zero_flag<=ALU_Zero_Flag;
Neg_flag<=ALU_Neg_Flag;
ELSIF FlagRegisterEnable="10" and CLR_Carry='1' then 
Zero_flag<=ALU_Zero_Flag;
Neg_flag<=ALU_Neg_Flag;
Carry_flag<='0';
ELSIF FlagRegisterEnable="11" then 
Zero_flag<=ALU_Zero_Flag;
Neg_flag<=ALU_Neg_Flag;
Carry_Flag<=ALU_Carry_Flag;
ElsIF CLR_Carry='1' then Carry_Flag<='0';
ElsIF CLR_Zero='1' then Zero_Flag<='0';
ElsIF CLR_sign='1' then Neg_Flag<='0';
end If;
-----------------------------
end IF;  
end Process;
End Architecture FlagRegisterArch;
