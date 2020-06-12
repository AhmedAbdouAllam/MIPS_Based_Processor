
Library ieee;
Use ieee.std_logic_1164.all;

Entity Latch IS 
port (
InputData,Disable:IN Std_Logic ;
CLK,RST:IN Std_Logic; ---It was supposed to be a latch :'D
OutputData:Out Std_Logic
);
End Entity Latch;


Architecture LatchArch of Latch
IS 
Begin
Process(Disable,CLK)
Begin
if RST='1' then  
	OutputData<='1';
elsif	Rising_Edge (CLK) then
	if Disable='0'
		then OutputData<=InputData;
	end if;
end if;
end Process;
End Architecture LatchArch;