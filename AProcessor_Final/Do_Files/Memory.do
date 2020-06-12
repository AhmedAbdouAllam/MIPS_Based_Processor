vsim -gui work.aprocessor
mem load -i D:/Computer_architectueProject2020/FinalSubmissionFiles/AProcessor_Final/MemoryFiles/Memory.Mem -filltype value -filldata 0 -fillradix symbolic -skip 0 /aprocessor/System_Memory_Cache/Main_Memory/ram
add wave -position insertpoint  \
sim:/aprocessor/CLK
add wave -position insertpoint  \
sim:/aprocessor/FlagRegContents
add wave -position insertpoint  \
sim:/aprocessor/IN_Port
add wave -position insertpoint  \
sim:/aprocessor/INTR
add wave -position insertpoint  \
sim:/aprocessor/Out_Port
add wave -position insertpoint  \
sim:/aprocessor/PC_Contents
add wave -position insertpoint  \
sim:/aprocessor/RegistersOut
add wave -position insertpoint  \
sim:/aprocessor/RST \
sim:/aprocessor/FWDA \
sim:/aprocessor/FWDB \
sim:/aprocessor/Hazard_Detected \
sim:/aprocessor/Data_Miss \
sim:/aprocessor/Instruction_Miss
add wave -position insertpoint  \
sim:/aprocessor/FlushA \
sim:/aprocessor/FlushB
force -freeze sim:/aprocessor/CLK 1 0, 0 {50 ps} -r 100
force -freeze sim:/aprocessor/IN_Port 32'h0CDAFE19 0
force -freeze sim:/aprocessor/INTR 0 0
force -freeze sim:/aprocessor/RST 1 0
run
force -freeze sim:/aprocessor/RST 0 0
run
run
run
run
run
run
run
run
run
run
run
run
force -freeze sim:/aprocessor/IN_Port 32'hFFFF 0
run
force -freeze sim:/aprocessor/IN_Port 32'hF320 0
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
