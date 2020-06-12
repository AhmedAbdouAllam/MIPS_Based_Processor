Library ieee;
use ieee.std_logic_1164.all;


entity ControlUnit is 
	port (
	ip: IN std_logic_vector (6 downto 0);
	disable: IN std_logic;
	PC_Change,
	RTI,
	Is_Shift,
	Is_OutPort,
	Save_PC,
	Is_Swap,
	SourceIsDest,
	Is_InPort,
	Stack_Up,
	Stack_Down,
	Is_IMM,
	Stack_Enable,
	Memory_Read,
	Memory_Write,
	Is_Branch_Zero,
	Memory_To_Reg,
	Reg_Write,
	Is_Branch_Negative,
	Is_Branch_Carry,
	ALU_Enable,
	Is_Branch,
	Set_Carry,
	Clear_Carry,
	Has_SRC2,
	Has_SRC1,
	IS_Load_POP
	: OUT std_logic;
	ALU_OP: OUT std_logic_vector (2 downto 0);
	Flag_Change: OUT std_logic_vector (1 downto 0);
	IsMove:Out Std_logic
);
end entity ControlUnit;


Architecture ControlUnitArch of ControlUnit is 
begin

	ALU_OP <= "000" when disable = '1' else 
	"000" when ip = "0000000" else
	"000" when ip = "0000101" else
	"000" when ip = "0000100" else
	"110" when ip = "0010100" else
	"100" when ip = "0011000" else
	"101" when ip = "0011001" else
	"000" when ip = "0010110" else
	"000" when ip = "0010111" else
	"000" when ip = "0100110" else
	"000" when ip = "0100000" else
	"001" when ip = "0100001" else
	"010" when ip = "0100010" else
	"011" when ip = "0100011" else
	"000" when ip = "1100000" else
	"000" when ip = "0101000" else
	"001" when ip = "0101001" else
	"000" when ip = "1100001" else
	"000" when ip = "0110000" else
	"000" when ip = "0110001" else
	"000" when ip = "1110000" else
	"000" when ip = "1110001" else
	"000" when ip = "0111100" else
	"000" when ip = "0111101" else
	"000" when ip = "0111110" else
	"000" when ip = "0111111" else
	"000" when ip = "1110100" else
	"000" when ip = "1110110" else
	"000" when ip = "1110111";
	
	PC_Change <= '0' when disable = '1' 
	else  '0' when ip = "0000000" else
	'0' when ip = "0000101" else
	'0' when ip = "0000100" else
	'0' when ip = "0010100" else
	'0' when ip = "0011000" else
	'0' when ip = "0011001" else
	'0' when ip = "0010110" else
	'0' when ip = "0010111" else
	'0' when ip = "0100110" else
	'0' when ip = "0100000" else
	'0' when ip = "0100001" else
	'0' when ip = "0100010" else
	'0' when ip = "0100011" else
	'0' when ip = "1100000" else
	'0' when ip = "0101000" else
	'0' when ip = "0101001" else
	'0' when ip = "1100001" else
	'0' when ip = "0110000" else
	'0' when ip = "0110001" else
	'0' when ip = "1110000" else
	'0' when ip = "1110001" else
	'0' when ip = "0111100" else
	'0' when ip = "0111101" else
	'0' when ip = "0111110" else
	'0' when ip = "0111111" else
	'0' when ip = "1110100" else
	'1' when ip = "1110110" else
	'0' when ip = "1110111";
	
	Clear_Carry <= '0' when disable = '1' 
	else  '0' when ip = "0000000" else
	'0' when ip = "0000101" else
	'1' when ip = "0000100" else
	'0' when ip = "0010100" else
	'0' when ip = "0011000" else
	'0' when ip = "0011001" else
	'0' when ip = "0010110" else
	'0' when ip = "0010111" else
	'0' when ip = "0100110" else
	'0' when ip = "0100000" else
	'0' when ip = "0100001" else
	'0' when ip = "0100010" else
	'0' when ip = "0100011" else
	'0' when ip = "1100000" else
	'0' when ip = "0101000" else
	'0' when ip = "0101001" else
	'0' when ip = "1100001" else
	'0' when ip = "0110000" else
	'0' when ip = "0110001" else
	'0' when ip = "1110000" else
	'0' when ip = "1110001" else
	'0' when ip = "0111100" else
	'0' when ip = "0111101" else
	'0' when ip = "0111110" else
	'0' when ip = "0111111" else
	'0' when ip = "1110100" else
	'0' when ip = "1110110" else
	'0' when ip = "1110111";
	
	
	Set_Carry <= '0' when disable = '1' 
	else  '0' when ip = "0000000" else
	'1' when ip = "0000101" else
	'0' when ip = "0000100" else
	'0' when ip = "0010100" else
	'0' when ip = "0011000" else
	'0' when ip = "0011001" else
	'0' when ip = "0010110" else
	'0' when ip = "0010111" else
	'0' when ip = "0100110" else
	'0' when ip = "0100000" else
	'0' when ip = "0100001" else
	'0' when ip = "0100010" else
	'0' when ip = "0100011" else
	'0' when ip = "1100000" else
	'0' when ip = "0101000" else
	'0' when ip = "0101001" else
	'0' when ip = "1100001" else
	'0' when ip = "0110000" else
	'0' when ip = "0110001" else
	'0' when ip = "1110000" else
	'0' when ip = "1110001" else
	'0' when ip = "0111100" else
	'0' when ip = "0111101" else
	'0' when ip = "0111110" else
	'0' when ip = "0111111" else
	'0' when ip = "1110100" else
	'0' when ip = "1110110" else
	'0' when ip = "1110111";

	Is_Branch <= '0' when disable = '1' 
	else  '0' when ip = "0000000" else
	'0' when ip = "0000101" else
	'0' when ip = "0000100" else
	'0' when ip = "0010100" else
	'0' when ip = "0011000" else
	'0' when ip = "0011001" else
	'0' when ip = "0010110" else
	'0' when ip = "0010111" else
	'0' when ip = "0100110" else
	'0' when ip = "0100000" else
	'0' when ip = "0100001" else
	'0' when ip = "0100010" else
	'0' when ip = "0100011" else
	'0' when ip = "1100000" else
	'0' when ip = "0101000" else
	'0' when ip = "0101001" else
	'0' when ip = "1100001" else
	'0' when ip = "0110000" else
	'0' when ip = "0110001" else
	'0' when ip = "1110000" else
	'0' when ip = "1110001" else
	'0' when ip = "0111100" else
	'0' when ip = "0111101" else
	'0' when ip = "0111110" else
	'1' when ip = "0111111" else
	'1' when ip = "1110100" else
	'0' when ip = "1110110" else
	'0' when ip = "1110111";


	
	ALU_Enable <= '0' when disable = '1' 
	else  '0' when ip = "0000000" else
	'0' when ip = "0000101" else
	'0' when ip = "0000100" else
	'1' when ip = "0010100" else
	'1' when ip = "0011000" else
	'1' when ip = "0011001" else
	'0' when ip = "0010110" else
	'0' when ip = "0010111" else
	'0' when ip = "0100110" else
	'1' when ip = "0100000" else
	'1' when ip = "0100001" else
	'1' when ip = "0100010" else
	'1' when ip = "0100011" else
	'1' when ip = "1100000" else
	'1' when ip = "0101000" else
	'1' when ip = "0101001" else
	'0' when ip = "1100001" else
	'0' when ip = "0110000" else
	'0' when ip = "0110001" else
	'0' when ip = "1110000" else
	'0' when ip = "1110001" else
	'0' when ip = "0111100" else
	'0' when ip = "0111101" else
	'0' when ip = "0111110" else
	'0' when ip = "0111111" else
	'0' when ip = "1110100" else
	'0' when ip = "1110110" else
	'0' when ip = "1110111";

	
	Is_Branch_Carry <= '0' when disable = '1' 
	else  '0' when ip = "0000000" else
	'0' when ip = "0000101" else
	'0' when ip = "0000100" else
	'0' when ip = "0010100" else
	'0' when ip = "0011000" else
	'0' when ip = "0011001" else
	'0' when ip = "0010110" else
	'0' when ip = "0010111" else
	'0' when ip = "0100110" else
	'0' when ip = "0100000" else
	'0' when ip = "0100001" else
	'0' when ip = "0100010" else
	'0' when ip = "0100011" else
	'0' when ip = "1100000" else
	'0' when ip = "0101000" else
	'0' when ip = "0101001" else
	'0' when ip = "1100001" else
	'0' when ip = "0110000" else
	'0' when ip = "0110001" else
	'0' when ip = "1110000" else
	'0' when ip = "1110001" else
	'0' when ip = "0111100" else
	'0' when ip = "0111101" else
	'1' when ip = "0111110" else
	'0' when ip = "0111111" else
	'0' when ip = "1110100" else
	'0' when ip = "1110110" else
	'0' when ip = "1110111";
	
	
	Is_Branch_Negative <= '0' when disable = '1' 
	else  '0' when ip = "0000000" else
	'0' when ip = "0000101" else
	'0' when ip = "0000100" else
	'0' when ip = "0010100" else
	'0' when ip = "0011000" else
	'0' when ip = "0011001" else
	'0' when ip = "0010110" else
	'0' when ip = "0010111" else
	'0' when ip = "0100110" else
	'0' when ip = "0100000" else
	'0' when ip = "0100001" else
	'0' when ip = "0100010" else
	'0' when ip = "0100011" else
	'0' when ip = "1100000" else
	'0' when ip = "0101000" else
	'0' when ip = "0101001" else
	'0' when ip = "1100001" else
	'0' when ip = "0110000" else
	'0' when ip = "0110001" else
	'0' when ip = "1110000" else
	'0' when ip = "1110001" else
	'0' when ip = "0111100" else
	'1' when ip = "0111101" else
	'0' when ip = "0111110" else
	'0' when ip = "0111111" else
	'0' when ip = "1110100" else
	'0' when ip = "1110110" else
	'0' when ip = "1110111";
	
	Reg_Write <= '0' when disable = '1' 
	else  '0' when ip = "0000000" else
	'0' when ip = "0000101" else
	'0' when ip = "0000100" else
	'1' when ip = "0010100" else
	'1' when ip = "0011000" else
	'1' when ip = "0011001" else
	'0' when ip = "0010110" else
	'1' when ip = "0010111" else
	'1' when ip = "0100110" else
	'1' when ip = "0100000" else
	'1' when ip = "0100001" else
	'1' when ip = "0100010" else
	'1' when ip = "0100011" else
	'1' when ip = "1100000" else
	'1' when ip = "0101000" else
	'1' when ip = "0101001" else
	'1' when ip = "1100001" else
	'1' when ip = "0110000" else
	'0' when ip = "0110001" else
	'1' when ip = "1110000" else
	'0' when ip = "1110001" else
	'0' when ip = "0111100" else
	'0' when ip = "0111101" else
	'0' when ip = "0111110" else
	'0' when ip = "0111111" else
	'0' when ip = "1110100" else
	'0' when ip = "1110110" else
	'0' when ip = "1110111";
	
	
	Memory_To_Reg <= '0' when disable = '1' 
	else  '0' when ip = "0000000" else
	'0' when ip = "0000101" else
	'0' when ip = "0000100" else
	'0' when ip = "0010100" else
	'0' when ip = "0011000" else
	'0' when ip = "0011001" else
	'0' when ip = "0010110" else
	'0' when ip = "0010111" else
	'0' when ip = "0100110" else
	'0' when ip = "0100000" else
	'0' when ip = "0100001" else
	'0' when ip = "0100010" else
	'0' when ip = "0100011" else
	'0' when ip = "1100000" else
	'0' when ip = "0101000" else
	'0' when ip = "0101001" else
	'0' when ip = "1100001" else
	'1' when ip = "0110000" else
	'0' when ip = "0110001" else
	'1' when ip = "1110000" else
	'0' when ip = "1110001" else
	'0' when ip = "0111100" else
	'0' when ip = "0111101" else
	'0' when ip = "0111110" else
	'0' when ip = "0111111" else
	'0' when ip = "1110100" else
	'0' when ip = "1110110" else
	'0' when ip = "1110111";

	Is_Branch_Zero <= '0' when disable = '1' 
	else  '0' when ip = "0000000" else
	'0' when ip = "0000101" else
	'0' when ip = "0000100" else
	'0' when ip = "0010100" else
	'0' when ip = "0011000" else
	'0' when ip = "0011001" else
	'0' when ip = "0010110" else
	'0' when ip = "0010111" else
	'0' when ip = "0100110" else
	'0' when ip = "0100000" else
	'0' when ip = "0100001" else
	'0' when ip = "0100010" else
	'0' when ip = "0100011" else
	'0' when ip = "1100000" else
	'0' when ip = "0101000" else
	'0' when ip = "0101001" else
	'0' when ip = "1100001" else
	'0' when ip = "0110000" else
	'0' when ip = "0110001" else
	'0' when ip = "1110000" else
	'0' when ip = "1110001" else
	'1' when ip = "0111100" else
	'0' when ip = "0111101" else
	'0' when ip = "0111110" else
	'0' when ip = "0111111" else
	'0' when ip = "1110100" else
	'0' when ip = "1110110" else
	'0' when ip = "1110111";
	
	
	Memory_Write <= '0' when disable = '1' 
	else '0' when ip = "0000000" else
	'0' when ip = "0000101" else
	'0' when ip = "0000100" else
	'0' when ip = "0010100" else
	'0' when ip = "0011000" else
	'0' when ip = "0011001" else
	'0' when ip = "0010110" else
	'0' when ip = "0010111" else
	'0' when ip = "0100110" else
	'0' when ip = "0100000" else
	'0' when ip = "0100001" else
	'0' when ip = "0100010" else
	'0' when ip = "0100011" else
	'0' when ip = "1100000" else
	'0' when ip = "0101000" else
	'0' when ip = "0101001" else
	'0' when ip = "1100001" else
	'0' when ip = "0110000" else
	'1' when ip = "0110001" else
	'0' when ip = "1110000" else
	'1' when ip = "1110001" else
	'0' when ip = "0111100" else
	'0' when ip = "0111101" else
	'0' when ip = "0111110" else
	'0' when ip = "0111111" else
	'1' when ip = "1110100" else
	'0' when ip = "1110110" else
	'0' when ip = "1110111";
	
	
	Memory_Read <= '0' when disable = '1' 
	else '0' when ip = "0000000" else
	'0' when ip = "0000101" else
	'0' when ip = "0000100" else
	'0' when ip = "0010100" else
	'0' when ip = "0011000" else
	'0' when ip = "0011001" else
	'0' when ip = "0010110" else
	'0' when ip = "0010111" else
	'0' when ip = "0100110" else
	'0' when ip = "0100000" else
	'0' when ip = "0100001" else
	'0' when ip = "0100010" else
	'0' when ip = "0100011" else
	'0' when ip = "1100000" else
	'0' when ip = "0101000" else
	'0' when ip = "0101001" else
	'0' when ip = "1100001" else
	'1' when ip = "0110000" else
	'0' when ip = "0110001" else
	'1' when ip = "1110000" else
	'0' when ip = "1110001" else
	'0' when ip = "0111100" else
	'0' when ip = "0111101" else
	'0' when ip = "0111110" else
	'0' when ip = "0111111" else
	'0' when ip = "1110100" else
	'1' when ip = "1110110" else
	'0' when ip = "1110111";
	
	Stack_Enable <= '0' when disable = '1' 
	else '0' when ip = "0000000" else
	'0' when ip = "0000101" else
	'0' when ip = "0000100" else
	'0' when ip = "0010100" else
	'0' when ip = "0011000" else
	'0' when ip = "0011001" else
	'0' when ip = "0010110" else
	'0' when ip = "0010111" else
	'0' when ip = "0100110" else
	'0' when ip = "0100000" else
	'0' when ip = "0100001" else
	'0' when ip = "0100010" else
	'0' when ip = "0100011" else
	'0' when ip = "1100000" else
	'0' when ip = "0101000" else
	'0' when ip = "0101001" else
	'0' when ip = "1100001" else
	'1' when ip = "0110000" else
	'1' when ip = "0110001" else
	'0' when ip = "1110000" else
	'0' when ip = "1110001" else
	'0' when ip = "0111100" else
	'0' when ip = "0111101" else
	'0' when ip = "0111110" else
	'0' when ip = "0111111" else
	'1' when ip = "1110100" else
	'1' when ip = "1110110" else
	'0' when ip = "1110111";
	

	Is_IMM <= '0' when disable = '1' 
	else '0' when ip = "0000000" else
	'0' when ip = "0000101" else
	'0' when ip = "0000100" else
	'0' when ip = "0010100" else
	'0' when ip = "0011000" else
	'0' when ip = "0011001" else
	'0' when ip = "0010110" else
	'0' when ip = "0010111" else
	'0' when ip = "0100110" else
	'0' when ip = "0100000" else
	'0' when ip = "0100001" else
	'0' when ip = "0100010" else
	'0' when ip = "0100011" else
	'1' when ip = "1100000" else
	'0' when ip = "0101000" else
	'0' when ip = "0101001" else
	'1' when ip = "1100001" else
	'0' when ip = "0110000" else
	'0' when ip = "0110001" else
	'0' when ip = "1110000" else
	'0' when ip = "1110001" else
	'0' when ip = "0111100" else
	'0' when ip = "0111101" else
	'0' when ip = "0111110" else
	'0' when ip = "0111111" else
	'0' when ip = "1110100" else
	'0' when ip = "1110110" else
	'0' when ip = "1110111";
	
	
	Stack_Down <= '0' when disable = '1' 
	else '0' when ip = "0000000" else
	'0' when ip = "0000101" else
	'0' when ip = "0000100" else
	'0' when ip = "0010100" else
	'0' when ip = "0011000" else
	'0' when ip = "0011001" else
	'0' when ip = "0010110" else
	'0' when ip = "0010111" else
	'0' when ip = "0100110" else
	'0' when ip = "0100000" else
	'0' when ip = "0100001" else
	'0' when ip = "0100010" else
	'0' when ip = "0100011" else
	'0' when ip = "1100000" else
	'0' when ip = "0101000" else
	'0' when ip = "0101001" else
	'0' when ip = "1100001" else
	'0' when ip = "0110000" else
	'1' when ip = "0110001" else
	'0' when ip = "1110000" else
	'0' when ip = "1110001" else
	'0' when ip = "0111100" else
	'0' when ip = "0111101" else
	'0' when ip = "0111110" else
	'0' when ip = "0111111" else
	'1' when ip = "1110100" else
	'0' when ip = "1110110" else
	'0' when ip = "1110111";
	
	
	Stack_Up <= '0' when disable = '1' 
	else '0' when ip = "0000000" else
	'0' when ip = "0000101" else
	'0' when ip = "0000100" else
	'0' when ip = "0010100" else
	'0' when ip = "0011000" else
	'0' when ip = "0011001" else
	'0' when ip = "0010110" else
	'0' when ip = "0010111" else
	'0' when ip = "0100110" else
	'0' when ip = "0100000" else
	'0' when ip = "0100001" else
	'0' when ip = "0100010" else
	'0' when ip = "0100011" else
	'0' when ip = "1100000" else
	'0' when ip = "0101000" else
	'0' when ip = "0101001" else
	'0' when ip = "1100001" else
	'1' when ip = "0110000" else
	'0' when ip = "0110001" else
	'0' when ip = "1110000" else
	'0' when ip = "1110001" else
	'0' when ip = "0111100" else
	'0' when ip = "0111101" else
	'0' when ip = "0111110" else
	'0' when ip = "0111111" else
	'0' when ip = "1110100" else
	'1' when ip = "1110110" else
	'0' when ip = "1110111";
	
	
	Is_InPort <= '0' when disable = '1' 
	else '0' when ip = "0000000" else
	'0' when ip = "0000101" else
	'0' when ip = "0000100" else
	'0' when ip = "0010100" else
	'0' when ip = "0011000" else
	'0' when ip = "0011001" else
	'0' when ip = "0010110" else
	'1' when ip = "0010111" else
	'0' when ip = "0100110" else
	'0' when ip = "0100000" else
	'0' when ip = "0100001" else
	'0' when ip = "0100010" else
	'0' when ip = "0100011" else
	'0' when ip = "1100000" else
	'0' when ip = "0101000" else
	'0' when ip = "0101001" else
	'0' when ip = "1100001" else
	'0' when ip = "0110000" else
	'0' when ip = "0110001" else
	'0' when ip = "1110000" else
	'0' when ip = "1110001" else
	'0' when ip = "0111100" else
	'0' when ip = "0111101" else
	'0' when ip = "0111110" else
	'0' when ip = "0111111" else
	'0' when ip = "1110100" else
	'0' when ip = "1110110" else
	'0' when ip = "1110111";
	
		
	SourceIsDest <= '0' when disable = '1' 
	else '0' when ip = "0000000" else
	'0' when ip = "0000101" else
	'0' when ip = "0000100" else
	'1' when ip = "0010100" else
	'1' when ip = "0011000" else
	'1' when ip = "0011001" else
	'0' when ip = "0010110" else
	'0' when ip = "0010111" else
	'0' when ip = "0100110" else
	'0' when ip = "0100000" else
	'0' when ip = "0100001" else
	'0' when ip = "0100010" else
	'0' when ip = "0100011" else
	'0' when ip = "1100000" else
	'1' when ip = "0101000" else
	'1' when ip = "0101001" else
	'0' when ip = "1100001" else
	'0' when ip = "0110000" else
	'0' when ip = "0110001" else
	'0' when ip = "1110000" else
	'0' when ip = "1110001" else
	'0' when ip = "0111100" else
	'0' when ip = "0111101" else
	'0' when ip = "0111110" else
	'0' when ip = "0111111" else
	'0' when ip = "1110100" else
	'0' when ip = "1110110" else
	'0' when ip = "1110111";		
	
	Is_Swap <= '0' when disable = '1' 
	else '0' when ip = "0000000" else
	'0' when ip = "0000101" else
	'0' when ip = "0000100" else
	'0' when ip = "0010100" else
	'0' when ip = "0011000" else
	'0' when ip = "0011001" else
	'0' when ip = "0010110" else
	'0' when ip = "0010111" else
	'1' when ip = "0100110" else
	'0' when ip = "0100000" else
	'0' when ip = "0100001" else
	'0' when ip = "0100010" else
	'0' when ip = "0100011" else
	'0' when ip = "1100000" else
	'0' when ip = "0101000" else
	'0' when ip = "0101001" else
	'0' when ip = "1100001" else
	'0' when ip = "0110000" else
	'0' when ip = "0110001" else
	'0' when ip = "1110000" else
	'0' when ip = "1110001" else
	'0' when ip = "0111100" else
	'0' when ip = "0111101" else
	'0' when ip = "0111110" else
	'0' when ip = "0111111" else
	'0' when ip = "1110100" else
	'0' when ip = "1110110" else
	'0' when ip = "1110111";
	
	
	
	Flag_Change <= "00" when disable = '1' 
	else "00" when ip = "0000000" else
	"00" when ip = "0000101" else
	"00" when ip = "0000100" else
	"10" when ip = "0010100" else --NOT Modified
	"11" when ip = "0011000" else
	"11" when ip = "0011001" else
	"00" when ip = "0010110" else
	"00" when ip = "0010111" else
	"00" when ip = "0100110" else
	"11" when ip = "0100000" else
	"11" when ip = "0100001" else
	"10" when ip = "0100010" else --AND Modified
	"10" when ip = "0100011" else --OR Modified
	"11" when ip = "1100000" else
	"11" when ip = "0101000" else --SHL Modified
	"11" when ip = "0101001" else --SHR Modified
	"00" when ip = "1100001" else
	"00" when ip = "0110000" else
	"00" when ip = "0110001" else
	"00" when ip = "1110000" else
	"00" when ip = "1110001" else
	"00" when ip = "0111100" else
	"00" when ip = "0111101" else
	"00" when ip = "0111110" else
	"00" when ip = "0111111" else
	"00" when ip = "1110100" else
	"00" when ip = "1110110" else
	"00" when ip = "1110111";
	
	
	
	Save_PC <= '0' when disable = '1' 
	else '0' when ip = "0000000" else
	'0' when ip = "0000101" else
	'0' when ip = "0000100" else
	'0' when ip = "0010100" else
	'0' when ip = "0011000" else
	'0' when ip = "0011001" else
	'0' when ip = "0010110" else
	'0' when ip = "0010111" else
	'0' when ip = "0100110" else
	'0' when ip = "0100000" else
	'0' when ip = "0100001" else
	'0' when ip = "0100010" else
	'0' when ip = "0100011" else
	'0' when ip = "1100000" else
	'0' when ip = "0101000" else
	'0' when ip = "0101001" else
	'0' when ip = "1100001" else
	'0' when ip = "0110000" else
	'0' when ip = "0110001" else
	'0' when ip = "1110000" else
	'0' when ip = "1110001" else
	'0' when ip = "0111100" else
	'0' when ip = "0111101" else
	'0' when ip = "0111110" else
	'0' when ip = "0111111" else
	'1' when ip = "1110100" else
	'0' when ip = "1110110" else
	'0' when ip = "1110111";
	
	Is_OutPort <= '0' when disable = '1' 
	else '0' when ip = "0000000" else
	'0' when ip = "0000101" else
	'0' when ip = "0000100" else
	'0' when ip = "0010100" else
	'0' when ip = "0011000" else
	'0' when ip = "0011001" else
	'1' when ip = "0010110" else
	'0' when ip = "0010111" else
	'0' when ip = "0100110" else
	'0' when ip = "0100000" else
	'0' when ip = "0100001" else
	'0' when ip = "0100010" else
	'0' when ip = "0100011" else
	'0' when ip = "1100000" else
	'0' when ip = "0101000" else
	'0' when ip = "0101001" else
	'0' when ip = "1100001" else
	'0' when ip = "0110000" else
	'0' when ip = "0110001" else
	'0' when ip = "1110000" else
	'0' when ip = "1110001" else
	'0' when ip = "0111100" else
	'0' when ip = "0111101" else
	'0' when ip = "0111110" else
	'0' when ip = "0111111" else
	'0' when ip = "1110100" else
	'0' when ip = "1110110" else
	'0' when ip = "1110111";
	
	
	Is_Shift <= '0' when disable = '1' 
	else '0' when ip = "0000000" else
	'0' when ip = "0000101" else
	'0' when ip = "0000100" else
	'0' when ip = "0010100" else
	'0' when ip = "0011000" else
	'0' when ip = "0011001" else
	'0' when ip = "0010110" else
	'0' when ip = "0010111" else
	'0' when ip = "0100110" else
	'0' when ip = "0100000" else
	'0' when ip = "0100001" else
	'0' when ip = "0100010" else
	'0' when ip = "0100011" else
	'0' when ip = "1100000" else
	'1' when ip = "0101000" else
	'1' when ip = "0101001" else
	'0' when ip = "1100001" else
	'0' when ip = "0110000" else
	'0' when ip = "0110001" else
	'0' when ip = "1110000" else
	'0' when ip = "1110001" else
	'0' when ip = "0111100" else
	'0' when ip = "0111101" else
	'0' when ip = "0111110" else
	'0' when ip = "0111111" else
	'0' when ip = "1110100" else
	'0' when ip = "1110110" else
	'0' when ip = "1110111";
	
	
	
	RTI <= '0' when disable = '1' 
	else '0' when ip = "0000000" else
	'0' when ip = "0000101" else
	'0' when ip = "0000100" else
	'0' when ip = "0010100" else
	'0' when ip = "0011000" else
	'0' when ip = "0011001" else
	'0' when ip = "0010110" else
	'0' when ip = "0010111" else
	'0' when ip = "0100110" else
	'0' when ip = "0100000" else
	'0' when ip = "0100001" else
	'0' when ip = "0100010" else
	'0' when ip = "0100011" else
	'0' when ip = "1100000" else
	'0' when ip = "0101000" else
	'0' when ip = "0101001" else
	'0' when ip = "1100001" else
	'0' when ip = "0110000" else
	'0' when ip = "0110001" else
	'0' when ip = "1110000" else
	'0' when ip = "1110001" else
	'0' when ip = "0111100" else
	'0' when ip = "0111101" else
	'0' when ip = "0111110" else
	'0' when ip = "0111111" else
	'0' when ip = "1110100" else
	'0' when ip = "1110110" else
	'1' when ip = "1110111";
	
	
	Has_SRC1 <= '0' when disable = '1' 
	else '0' when ip = "0000000" else
	'0' when ip = "0000101" else
	'0' when ip = "0000100" else
	'1' when ip = "0010100" else
	'1' when ip = "0011000" else
	'1' when ip = "0011001" else
	'1' when ip = "0010110" else
	'0' when ip = "0010111" else
	'1' when ip = "0100110" else
	'1' when ip = "0100000" else
	'1' when ip = "0100001" else
	'1' when ip = "0100010" else
	'1' when ip = "0100011" else
	'1' when ip = "1100000" else
	'1' when ip = "0101000" else
	'1' when ip = "0101001" else
	'0' when ip = "1100001" else
	'0' when ip = "0110000" else
	'1' when ip = "0110001" else
	'0' when ip = "1110000" else
	'1' when ip = "1110001" else
	'1' when ip = "0111100" else
	'1' when ip = "0111101" else
	'1' when ip = "0111110" else
	'1' when ip = "0111111" else
	'1' when ip = "1110100" else
	'0' when ip = "1110110" else
	'0' when ip = "1110111";
	
	Has_SRC2 <= '0' when disable = '1' 
	else '0' when ip = "0000000" else
	'0' when ip = "0000101" else
	'0' when ip = "0000100" else
	'0' when ip = "0010100" else
	'0' when ip = "0011000" else
	'0' when ip = "0011001" else
	'0' when ip = "0010110" else
	'0' when ip = "0010111" else
	'1' when ip = "0100110" else
	'1' when ip = "0100000" else
	'1' when ip = "0100001" else
	'1' when ip = "0100010" else
	'1' when ip = "0100011" else
	'0' when ip = "1100000" else
	'0' when ip = "0101000" else
	'0' when ip = "0101001" else
	'0' when ip = "1100001" else
	'0' when ip = "0110000" else
	'0' when ip = "0110001" else
	'0' when ip = "1110000" else
	'0' when ip = "1110001" else
	'0' when ip = "0111100" else
	'0' when ip = "0111101" else
	'0' when ip = "0111110" else
	'0' when ip = "0111111" else
	'0' when ip = "1110100" else
	'0' when ip = "1110110" else
	'0' when ip = "1110111";
	
	IS_Load_POP <= '0' when disable = '1' 
	else '0' when ip = "0000000" else
	'0' when ip = "0000101" else
	'0' when ip = "0000100" else
	'0' when ip = "0010100" else
	'0' when ip = "0011000" else
	'0' when ip = "0011001" else
	'0' when ip = "0010110" else
	'0' when ip = "0010111" else
	'0' when ip = "0100110" else
	'0' when ip = "0100000" else
	'0' when ip = "0100001" else
	'0' when ip = "0100010" else
	'0' when ip = "0100011" else
	'0' when ip = "1100000" else
	'0' when ip = "0101000" else
	'0' when ip = "0101001" else
	'0' when ip = "1100001" else
	'1' when ip = "0110000" else
	'0' when ip = "0110001" else
	'1' when ip = "1110000" else
	'0' when ip = "1110001" else
	'0' when ip = "0111100" else
	'0' when ip = "0111101" else
	'0' when ip = "0111110" else
	'0' when ip = "0111111" else
	'0' when ip = "1110100" else
	'0' when ip = "1110110" else
	'0' when ip = "1110111";

	IsMove <= '0' when disable = '1' 
	else '0' when ip = "0000000" else
	'0' when ip = "0000101" else
	'0' when ip = "0000100" else
	'0' when ip = "0010100" else
	'0' when ip = "0011000" else
	'0' when ip = "0011001" else
	'0' when ip = "0010110" else
	'0' when ip = "0010111" else
	'0' when ip = "0100110" else
	'0' when ip = "0100000" else
	'0' when ip = "0100001" else
	'0' when ip = "0100010" else
	'0' when ip = "0100011" else
	'0' when ip = "1100000" else
	'0' when ip = "0101000" else
	'0' when ip = "0101001" else
	'1' when ip = "1100001" else
	'0' when ip = "0110000" else
	'0' when ip = "0110001" else
	'0' when ip = "1110000" else
	'0' when ip = "1110001" else
	'0' when ip = "0111100" else
	'0' when ip = "0111101" else
	'0' when ip = "0111110" else
	'0' when ip = "0111111" else
	'0' when ip = "1110100" else
	'0' when ip = "1110110" else
	'0' when ip = "1110111";




end ControlUnitArch;