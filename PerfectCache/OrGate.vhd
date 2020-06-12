--Author Ahmed A.Allam
--Date:26/2/2020
--
--
Library ieee;
Use ieee.std_logic_1164.all;

Entity OrGate IS 
port (
A,B:IN Std_Logic;
Output:OUT Std_Logic 
);
End Entity OrGate;

--
--

Architecture OrGateArch of OrGate
IS 
Begin
Output<=A OR B;
End Architecture OrGateArch;
