@echo Now assemble log2t.asm......

asm56300 -a -b -l log2t.asm

@echo Now start sim56300 to run log2t......

sim56300 log2t.cmd

@echo Execute complete
@echo Please see log2in.io and log2out.io

