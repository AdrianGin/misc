@echo Now assemble mulint.asm......

asm56300 -a -b -l mulint.asm

@echo Now start sim56300 to run mulint......

sim56300 mulin.cmd

@echo Execute complete
@echo Please see mulin_in.io and mulin_out.io