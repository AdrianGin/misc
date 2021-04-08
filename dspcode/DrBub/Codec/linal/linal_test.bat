@echo Now assemble linalt.asm......

asm56300 -a -b -l linalt.asm

@echo Now start sim56300 to run linalt......

sim56300 linal.cmd

@echo Execute complete
@echo Please see linal_in.io and linal_out.io