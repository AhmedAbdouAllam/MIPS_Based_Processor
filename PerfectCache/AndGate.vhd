--Author Ahmed A.Allam
--Date:26/2/2020
--
--
Library ieee;
Use ieee.std_logic_1164.all;

Entity AndGate IS 
port (A,B:IN Std_Logic;
Output:OUT Std_Logic);
End Entity AndGate;

--
--

Architecture AndGateArch of AndGate
IS 
Begin
Output<= A and B;
End Architecture AndGateArch;
