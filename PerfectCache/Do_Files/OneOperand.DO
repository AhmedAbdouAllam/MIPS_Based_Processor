vsim -gui work.aprocessor
mem load -i D:/Computer_architectueProject2020/FinalSubmissionFiles/PerfectCache/MemoryFiles/OneOperand_instruction.Mem -filltype value -filldata 0 -fillradix symbolic -skip 0 /aprocessor/IFetch/InstrMem/ram
mem load -i D:/Computer_architectueProject2020/FinalSubmissionFiles/PerfectCache/MemoryFiles/OneOperand_Data.Mem -filltype value -filldata 0 -fillradix symbolic -skip 0 /aprocessor/Mem_WriteBack/DataMemoryNoChache/ram
add wave -position insertpoint  \
sim:/aprocessor/CLK \
sim:/aprocessor/FWDA \
sim:/aprocessor/FWDB \
sim:/aprocessor/FlagRegContents \
sim:/aprocessor/RegistersOut \
sim:/aprocessor/FlushA \
sim:/aprocessor/FlushB \
sim:/aprocessor/Hazard_Detected \
sim:/aprocessor/INTR \
sim:/aprocessor/IN_Port \
sim:/aprocessor/Out_Port \
sim:/aprocessor/PC_Contents \
sim:/aprocessor/RST
force -freeze sim:/aprocessor/CLK 1 0, 0 {50 ps} -r 100
force -freeze sim:/aprocessor/RST 1 0
force -freeze sim:/aprocessor/IN_Port 32'h5 0
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
force -freeze sim:/aprocessor/IN_Port 32'h10 0
run
run
run
run
run
run
run
run