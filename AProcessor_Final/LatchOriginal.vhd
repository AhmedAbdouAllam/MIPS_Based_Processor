Library ieee;
Use ieee.std_logic_1164.all;

Entity LatchOriginal IS 
port (
	InputData,Disable:IN Std_Logic ;
	OutputData:Out Std_Logic
);
End Entity LatchOriginal;


Architecture LatchOriginalArch of LatchOriginal
IS 
Begin
Process(Disable)
Begin

	if Disable='0'
		then OutputData<=InputData;
	end if;

end Process;
End Architecture LatchOriginalArch;