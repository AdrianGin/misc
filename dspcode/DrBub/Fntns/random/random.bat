@echo Now assemble rand1.asm......

asm56300 -a -b -l rand1.asm

@echo Now start sim56300 to run rand1......

sim56300 rand1.cmd

@echo Execute complete
@echo Please see rand1.io

