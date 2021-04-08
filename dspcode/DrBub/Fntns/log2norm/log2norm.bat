@echo Now assemble log2nrmt.asm......

asm56300 -a -b -l log2nrmt.asm

@echo Now start sim56300 to run log2nrmt......

sim56300 log2nrmt.cmd

@echo Execute complete
@echo Please see log2in.io and log2out.io

