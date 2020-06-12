
--Author Ahmed A.Allam
--Date:26/2/2020
Library ieee;
Use ieee.std_logic_1164.all;
--The following Libraries are added after The edit
Use IEEE.Math_real.all;
Use IEEE.Numeric_std.all;

Entity InteruptUnit IS 
port (
INTR,RTI,Clk,RST:IN Std_Logic;
Ret_Flags,Is_Out_RTI,Save_In_St_INT,Save_In_St_Flags,Is_Out_INTR:OUT Std_Logic;
PC_IN_Content,PC_IN_Fetch,PC_IN_Decode:IN Std_Logic_Vector(31 downto 0);
Flags_IN:IN Std_Logic_Vector(2 downto 0);
Flags_To_Save:out Std_Logic_Vector(2 downto 0);
PC_To_Save:Out Std_Logic_Vector(31 downto 0);
DisableHandler:IN Std_Logic

);
End Entity InteruptUnit;


Architecture InteruptUnitArch of InteruptUnit
IS
Component InteruptHandler IS 
port (
INTR,RTI,Clk,RST:IN Std_Logic;
Ret_Flags,Is_Out_RTI,Save_In_St_INT,Save_In_St_Flags,Is_Out_INTR:OUT Std_Logic;
PC_IN:IN Std_Logic_Vector(31 downto 0);
Flags_IN:IN Std_Logic_Vector(2 downto 0);
Flags_To_Save:out Std_Logic_Vector(2 downto 0);
PC_To_Save:Out Std_Logic_Vector(31 downto 0);
DisableHandler:IN Std_Logic
);
End Component InteruptHandler;
Component InteruptBuffer IS 
port (
INTR_IN:IN Std_logic;
INTR_Out:OUT Std_Logic;

CLK,RST:IN std_Logic);
End Component InteruptBuffer;
--Signal ID_INTR,
Signal IF_INTR:Std_Logic;
Signal ZeroD,ZeroF:Std_Logic;
Signal PC_Used:Std_Logic_Vector(31 downto 0);
Begin

BufferIF:InteruptBuffer Port Map(INTR,IF_INTR,CLK,RST);
--BufferID:InteruptBuffer Port Map(IF_INTR,ID_INTR,CLK,RST);
IHU:InteruptHandler Port Map(IF_INTR,RTI,Clk,RST,Ret_Flags,Is_Out_RTI,Save_In_St_INT,Save_In_St_Flags,Is_Out_INTR,PC_Used,Flags_IN,Flags_To_Save,PC_To_Save,DisableHandler);
ZeroD<='1' when PC_IN_Decode=X"00000000"
else '0';
ZeroF<='1' when PC_IN_Fetch=X"00000000"
else '0';
PC_Used<=PC_IN_Decode when ZeroD='0'
else PC_IN_Fetch when ZeroF='0'
else PC_IN_Content;




End Architecture InteruptUnitArch;
