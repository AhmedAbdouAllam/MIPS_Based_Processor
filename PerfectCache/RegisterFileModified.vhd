--Author Ahmed A.Allam
--Date:26/2/2020
--Edited:27/2/2020 Original Code Edited Parts are Commented
--The code is edited to make a more generic Register File which enables the possibility to change the number of registers "m" 
--You can find the old file saved as nXmDecoderCopy.VHD
--Edited 12/3/2020 To be Adapted to the project requirements
--Attached a photo of new design
Library ieee;
Use ieee.std_logic_1164.all;
--The following Libraries are added after The edit
Use IEEE.Math_real.all;
Use IEEE.Numeric_std.all;

--Till now number of Registers must be of order of 2 as the program may rise an error 
Entity RegFile IS 
Generic(n: integer :=32 ; m:integer:=8);
port (
DataBusXRd,DataBusYRd: Out Std_Logic_Vector (n-1 downto 0);
DataBusXWr,DataBusYWr: In Std_Logic_Vector (n-1 downto 0);
CLK,Rst,EnableWrX,EnableWrY :In Std_Logic;
ReadAddressX ,WriteAddressX,ReadAddressY ,WriteAddressY :IN Std_Logic_Vector ((Natural(log2(real(m)))-1) downto 0); ----To  be edited
---Added for simulation Purposes
RegContents0,RegContents1,RegContents2,RegContents3,RegContents4,RegContents5,RegContents6,RegContents7:Out std_Logic_Vector(n-1 downto 0)
);
End Entity RegFile;

Architecture RegFileArch of RegFile
IS 

Signal EnableReg,EnableTSBX,EnableTSBY,EnableRegX,EnableRegY :Std_Logic_Vector (m-1 downto 0);
--Signal DataBus:  Std_Logic_Vector (n-1 downto 0);
--The following Line is commented Instead We will use array as shown after the comment
--Signal RegOut0,RegOut1,RegOut2,RegOut3 : std_logic_vector (n-1 downto 0);
type RegisterOut is array (0 to m-1) of std_logic_vector( n-1 downto 0);
Signal RegistersOut: RegisterOut;
Signal Databus: RegisterOut;
Component nBitRegister IS 
Generic(n: integer :=16);
port (Input :IN std_logic_vector (n-1 downto 0);
Output :Out std_logic_vector (n-1 downto 0);
CLK,RST,Enable :IN std_Logic);
End Component nBitRegister;

Component nXmDecoder IS 
Generic(m: integer :=16); --Where n here is the number of Outputs
port (Input :IN std_logic_vector ((Natural(log2(real(m)))-1) downto 0);
Enable: IN Std_logic;
Output :Out std_logic_vector (m-1 downto 0));
End Component nXmDecoder;

Component nTriStateBuffer IS 
Generic(n: integer :=32);
port (Input :IN std_logic_vector (n-1 downto 0);
Output :Out std_logic_vector (n-1 downto 0);
Enable :IN std_Logic);
End Component nTriStateBuffer;
Begin
DestinationDecoderX:nXmDecoder Generic Map(m) Port Map(WriteAddressX,EnableWrX,EnableRegX);
SourceDecoderX:nXmDecoder Generic Map(m) Port Map(ReadAddressX,'1',EnableTSBX);
DestinationDecoderY:nXmDecoder Generic Map(m) Port Map(WriteAddressY,EnableWrY,EnableRegY);
SourceDecoderY:nXmDecoder Generic Map(m) Port Map(ReadAddressY,'1',EnableTSBY);
RegContents0<=RegistersOut(0);
RegContents1<=RegistersOut(1);
RegContents2<=RegistersOut(2);
RegContents3<=RegistersOut(3);
RegContents4<=RegistersOut(4);
RegContents5<=RegistersOut(5);
RegContents6<=RegistersOut(6);
RegContents7<=RegistersOut(7);

Loop1: for i in 0 to m-1 Generate
Begin
TSBx: nTriStateBuffer Generic Map(n) Port Map(RegistersOut(i),DatabusXRd,EnableTSBX(i));
TSBy: nTriStateBuffer Generic Map(n) Port Map(RegistersOut(i),DatabusYRd,EnableTSBY(i));
EnableReg(i)<=EnableRegX(i) or EnableRegY(i);
Databus(i)<= DatabusYWr when EnableRegY(i)='1' and EnableRegX(i)='0'
Else DataBusXWr;
RegX: nBitRegister Generic Map(n) Port Map (Databus(i),RegistersOut(i),CLK,RST,EnableReg(i));
End Generate;

End Architecture RegFileArch;

