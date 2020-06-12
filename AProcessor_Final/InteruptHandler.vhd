
--Author Ahmed A.Allam
--Date:26/2/2020
Library ieee;
Use ieee.std_logic_1164.all;
--The following Libraries are added after The edit
Use IEEE.Math_real.all;
Use IEEE.Numeric_std.all;

Entity InteruptHandler IS 
port (
INTR,RTI,Clk,RST:IN Std_Logic;
Ret_Flags,Is_Out_RTI,Save_In_St_INT,Save_In_St_Flags,Is_Out_INTR:OUT Std_Logic;
PC_IN:IN Std_Logic_Vector(31 downto 0);
Flags_IN:IN Std_Logic_Vector(2 downto 0);
Flags_To_Save:out Std_Logic_Vector(2 downto 0);
PC_To_Save:Out Std_Logic_Vector(31 downto 0);
DisableHandler:IN Std_Logic;
IsInProcessInterupt:Out Std_Logic
);
End Entity InteruptHandler;


Architecture InteruptHandlerArch of InteruptHandler
IS
TYPE InteruptBuffer IS ARRAY(0 TO 31) of std_logic_vector(2 DOWNTO 0);
Signal IBuffer:InteruptBuffer;
Signal Head_Pointer,TailPointer,Added_Tail:Std_Logic_Vector(4 downto 0):="00000";
Signal Not_Tail_Pointer:Std_Logic_Vector(4 downto 0);
Signal Difference:Std_Logic_Vector(4 downto 0);
Signal TailPointerOne,TailPointerTwo,TailPointerThree,HeadOne:Std_Logic_Vector(4 downto 0);
Signal IsNotEmpty:Std_Logic;
Signal Instruction:Std_Logic_Vector(2 downto 0);
Signal InWork :Std_Logic:='0';
Component my_nadder IS
GENERIC (n : integer := 32); 
PORT (a, b : IN std_logic_vector(n-1 DOWNTO 0) ;
 cin : IN std_logic; 
 s : OUT std_logic_vector(n-1 DOWNTO 0); 
 cout : OUT std_logic);
END Component my_nadder; 
Begin
Process(Clk,RST)
Begin
if RST='1' then
Head_Pointer<="00000";
TailPointer<="00000";
elsif Rising_Edge (clk) then
----------------Read Inputs--------------------------	
	if INTR='1' then
		
		TailPointer<=TailPointerThree;
		IBuffer(to_integer(Unsigned(TailPointer)))<="001";
		IBuffer(to_integer(Unsigned(TailPointerOne)))<="010";
		IBuffer(to_integer(Unsigned(TailPointerTwo)))<="011";
	elsif  DisableHandler='0' and RTI='1' then
		TailPointer<=TailPointerTwo;
		IBuffer(to_integer(Unsigned(TailPointer)))<="100";
		IBuffer(to_integer(Unsigned(TailPointerOne)))<="101";


	end if;
	if Instruction="001" and InWork='0'  then 
		PC_To_Save<=PC_IN ;
		InWork<='1';
	elsif  Instruction="011" then InWork<='0';
	end if;
elsif Falling_Edge(CLK) then
		if DisableHandler='0' and RST='0' and IsNotEmpty='1'
			then Instruction<=IBuffer(to_integer(Unsigned(Head_Pointer)));
				Head_Pointer<=HeadOne;
			
			--	if Instruction="001" then PC_To_Save<=PC_IN ;
				
				--end if;
		elsif DisableHandler='1' and RST='0' and IsNotEmpty='1' and (Instruction="011" or Instruction="101")
			then 
				if Instruction="011" then Instruction<="010" ;
				elsif Instruction="101" then Instruction<="100" ;
				end if;	
		elsif DisableHandler='1' and RST='0' and IsNotEmpty='1' and (Instruction="010" or Instruction="100" or Instruction="001")
			then 
				if Instruction="010" then Instruction<="010" ;
				elsif Instruction="100" then Instruction<="100" ;
				elsif Instruction="001" then Instruction<="001";
				end if;		
			
		else Instruction<="000";

		end if;
	

end if;
end Process;
Not_Tail_Pointer<=Not TailPointer;
DifferenceGetter:my_nadder Generic Map(5) Port Map(Head_Pointer,Not_Tail_Pointer,'1',Difference);
IsNotEmpty<=Difference(0) or Difference(1) or Difference (2) or Difference (3) or Difference (4);
TailOneGetter:my_nadder Generic Map(5) Port Map(TailPointer,"00001",'0',TailPointerOne);
TailTwoGetter:my_nadder Generic Map(5) Port Map(TailPointer,"00010",'0',TailPointerTwo);
TailThreeGetter:my_nadder Generic Map(5) Port Map(TailPointer,"00011",'0',TailPointerThree);
HeadOneGetter:my_nadder Generic Map(5) Port Map(Head_Pointer,"00001",'0',HeadOne);
Is_Out_INTR<='1' when Instruction="001"
else '0';
Save_In_St_Flags<='1' when Instruction="010" 
else '0';
Flags_To_Save<=Flags_IN when Instruction="010" 
else "000";
Save_In_St_INT<='1' when Instruction="010"
else '1' when Instruction="011"
else '0';

Is_Out_RTI<='1' when Instruction="100"
else '0';
Ret_Flags<='1' when Instruction="101" 
else '0';
IsInProcessInterupt<=IsNotEmpty;
End Architecture InteruptHandlerArch;