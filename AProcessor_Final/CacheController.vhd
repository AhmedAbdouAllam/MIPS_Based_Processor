--Author Ahmed A.Allam
--Date:23/5/2020

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;

Entity CacheController IS 
port (
---------From Instruction Memory--------------
Address_Instruction:IN std_Logic_Vector (10 downto 0);
---------From Data Memory---------------------
Address_Data:IN std_Logic_Vector (10 downto 0);
Data_Read,Data_Write:In Std_Logic;
Miss_Instruction,Miss_Data:Out Std_Logic;
Write_Memory,Read_Memory,DutyRD:Out Std_logic:='0';
Address_Memory:Out Std_Logic_Vector (10 downto 0):="00000000000";
MEM_Status_Out:Out Std_Logic_Vector (1 downto 0):="00";
Acknowledge_Memory,CLK,Double_Line_Instr:IN Std_Logic;
Is_Interupted_Sequence:IN Std_Logic


);
End Entity CacheController;


Architecture CacheControllerArch of CacheController
IS 
TYPE Controller_type_I IS ARRAY(0 TO 31) of std_logic_vector(3 DOWNTO 0);
TYPE Controller_type_D IS ARRAY(0 TO 31) of std_logic_vector(4 DOWNTO 0);
Signal Instruction_Status:Controller_type_I:=(Others=>"0000");
Signal Data_Status:Controller_type_D:=(Others=>"00000");
Signal MemStatus:Std_Logic_Vector (1 downto 0):="00"; ---00 Idle,01 Serving DC ,10 Serving IC
Signal Instruction_IN,Instruction_In2:Std_Logic_Vector(3 downto 0);
Signal Data_IN:Std_Logic_Vector(4 downto 0);
Signal Miss_DataX,Miss_InstructionX,Miss_InstructionY,Duty_Instruction_Miss,DutyRDX:std_logic:='0';
Signal Address_Instruction_One: std_logic_vector(10 downto 0);
Constant OneAddress:std_logic_vector(10 downto 0):="00000000001";
Component AdderFetch IS 
Generic (n: integer :=32);
Port (A: In std_logic_vector (n-1 downto 0) ;
B: In std_logic_vector (n-1 downto 0) ;
F: Out std_logic_vector (n-1 downto 0)); 
End Component AdderFetch;
Begin

Process(Clk)
Begin
if Rising_edge (Clk) then ---end 173
------Added 23/5/2020 Ahmed A.Allam 
if Is_Interupted_Sequence='0' or  Miss_DataX='1' then
	if Acknowledge_Memory='1' then
		if MemStatus="11" then 
			MemStatus<="10";
			Write_Memory<='0';
			Read_Memory<='1';
			Address_Memory<=Address_Data(10 downto 3)&"000";
		elsif MemStatus="10" then 
			MemStatus<="00"; ---needs further consideration Ahmed A.Allam
			Write_Memory<='0';
			Read_Memory<='0';
			if Data_Read='1' then
				Data_Status(to_integer(Unsigned(Address_Data(7 downto 3))))(4)<='1';
				Data_Status(to_integer(Unsigned(Address_Data(7 downto 3))))(3)<='0';
				Data_Status(to_integer(Unsigned(Address_Data(7 downto 3))))(2 downto 0)<=Address_Data(10 downto 8);
			elsif Data_Write='1' then
				Data_Status(to_integer(Unsigned(Address_Data(7 downto 3))))(4)<='1';
				Data_Status(to_integer(Unsigned(Address_Data(7 downto 3))))(3)<='1';
				Data_Status(to_integer(Unsigned(Address_Data(7 downto 3))))(2 downto 0)<=Address_Data(10 downto 8);
			end if;
		elsif MemStatus="01" then 
			MemStatus<="00";---needs further consideration Ahmed A.Allam
			Write_Memory<='0';
			Read_Memory<='0';
			if Duty_Instruction_Miss='0' then
				Instruction_Status(to_integer(Unsigned(Address_Instruction(7 downto 3))))(3)<='1';
				Instruction_Status(to_integer(Unsigned(Address_Instruction(7 downto 3))))(2 downto 0)<=Address_Instruction(10 downto 8);
			else 
				Instruction_Status(to_integer(Unsigned(Address_Instruction_One(7 downto 3))))(3)<='1';
				Instruction_Status(to_integer(Unsigned(Address_Instruction_One(7 downto 3))))(2 downto 0)<=Address_Instruction_One(10 downto 8);
			end if;
		end if;
	
	elsif MemStatus="00" then
		if Miss_DataX='1' and Data_In(3)='1' then 
			MemStatus<="11";
			Write_Memory<='1';
			Read_Memory<='0';
			Address_Memory<=Data_Status(to_integer(Unsigned(Address_Data(7 downto 3))))(2 downto 0)&Address_Data(7 downto 3)&"000";
		elsif Miss_DataX='1' then  
			MemStatus<="10";
			Write_Memory<='0';
			Read_Memory<='1';
			Address_Memory<=Address_Data(10 downto 3)&"000";		
		elsif Miss_InstructionX='1' then 
			MemStatus<="01"; 
			Write_Memory<='0';
			Read_Memory<='1';
			
			if Duty_Instruction_Miss='0' then Address_Memory<=Address_Instruction(10 downto 3)&"000";		
			elsif Duty_Instruction_Miss='1' then 
				Address_Memory<=Address_Instruction_One(10 downto 3)&"000";	
				DutyRDX<='1';
			end if;
		
		end if;
	end if;
elsif Is_Interupted_Sequence='1' and Miss_DataX='0' then MemStatus<="00";
end if;
	if Data_Write='1' and Miss_DataX='0'
		then Data_Status(to_integer(Unsigned(Address_Data(7 downto 3))))(3)<='1';
	end if;

elsif falling_edge (Clk) then 
	if Acknowledge_Memory='1' then DutyRDX<='0'; 
	end if;

end if;
end Process;
--------------------------------------Miss Sequence------------------------------
Data_In<=Data_Status(to_integer(Unsigned(Address_Data(7 downto 3))));
Instruction_In<=Instruction_Status(to_integer(Unsigned(Address_Instruction(7 downto 3))));
Instruction_In2<=Instruction_Status(to_integer(Unsigned(Address_Instruction_One(7 downto 3))));
Miss_InstructionY<='0' when Instruction_In(3)='1' and Instruction_In(2 downto 0)=Address_Instruction(10 downto 8)
else '1';
Duty_Instruction_Miss<='1' when  Instruction_In(3)='1' and Instruction_In(2 downto 0)=Address_Instruction(10 downto 8) and Double_Line_Instr='1' and (not (Instruction_In2(3)='1' and Instruction_In2(2 downto 0)=Address_Instruction_One(10 downto 8) ))
else '0';

------------------------Data Sequence assuming always even address------------------------------
Miss_DataX<='0' when (Data_In(4)='1' and Data_In(2 downto 0)=Address_Data(10 downto 8))
else '1' when (Data_Read='1' or Data_Write ='1');
DutyRD<=DutyRDX;
---------------------------------------------OutputSignals--------------------
Miss_Data<=Miss_DataX;
MEM_Status_Out<=MemStatus;
Miss_InstructionX<=Miss_InstructionY or Duty_Instruction_Miss;
Miss_Instruction<=Miss_InstructionX;
AdderAddress:AdderFetch generic map(11) port map(Address_Instruction,OneAddress,Address_Instruction_One);
----------------------------------------------
End Architecture CacheControllerArch;
