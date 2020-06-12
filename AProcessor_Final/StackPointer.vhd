
--Author Ahmed A.Allam
--Date:26/2/2020
Library ieee;
Use ieee.std_logic_1164.all;

Entity StackPointer IS 
port (Sp_UP,SP_Down,RST,CLK: IN std_logic;
Output :Out std_logic_vector (31 downto 0);
DataMiss:IN Std_Logic
);

End Entity StackPointer;


Architecture StackPointerArch of StackPointer
IS 
Component MUXFourByOne IS 
Generic (n: integer :=32);
Port (Input1,Input2,Input3,Input4: In std_logic_vector (n-1 downto 0) ;
OutPut: Out std_logic_vector (n-1 downto 0) ;
Sel:IN std_logic_vector(1 downto 0)
); 
End Component MUXFourByOne;


Component AdderFetch IS 
Generic (n: integer :=32);
Port (A: In std_logic_vector (n-1 downto 0) ;
B: In std_logic_vector (n-1 downto 0) ;
F: Out std_logic_vector (n-1 downto 0)); 
End Component AdderFetch;
constant NegativeOne:std_logic_vector (31 downto 0):=X"FFFFFFFF";
Constant NegativeTwo:std_logic_vector (31 downto 0):=X"FFFFFFFE";
constant PostiveOne:std_logic_vector (31 downto 0):=X"00000001";
Constant PostiveTwo:std_logic_vector (31 downto 0):=X"00000002";
Constant Zeros:std_logic_vector (31 downto 0):=X"00000000";
Signal AddedPositiveOne,AddedPositiveTwo,AddedNegativeOne,AddedNegativeTwo,AddressIn:std_logic_vector (31 downto 0);
Signal AddressOut:std_logic_vector (31 downto 0):=X"000007FF";
Signal SelectorIN: std_logic_vector (1 downto 0);
Begin
SelectorIN<=Sp_UP&SP_Down;
AdderPositveOne:AdderFetch generic map(32) port map(AddressOut,PostiveOne,AddedPositiveOne);
AdderPositveTwo:AdderFetch generic map(32) port map(AddressOut,PostiveTwo,AddedPositiveTwo);
AdderNegativeOne:AdderFetch generic map(32) port map(AddressOut,NegativeOne,AddedNegativeOne);
AdderNegativeTwo:AdderFetch generic map(32) port map(AddressOut,NegativeTwo,AddedNegativeTwo);
MuxAddressIn:MUXFourByOne generic map(32) port map(AddressOut,AddedNegativeTwo,AddedPositiveTwo,Zeros,AddressIn,SelectorIN);
MuxOutput:MUXFourByOne generic map(32) port map(Zeros,AddedNegativeOne,AddedPositiveOne,Zeros,Output,SelectorIN);
Process(Clk,RST)
Begin
	IF RST='1' then AddressOut<=X"000007FF"; 
elsif falling_edge (CLK) Then 
	if DataMiss='0' Then
		AddressOut<=AddressIn;
	end if;
end IF;  
end Process;


End Architecture StackPointerArch;