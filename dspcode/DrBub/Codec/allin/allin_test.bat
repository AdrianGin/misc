@echo Now assemble allint.asm......

asm56300 -a -b -l allint.asm

@echo Now start sim56300 to run allint......

sim56300 allin.cmd

@echo Execute complete
@echo Please see allin_in.io and allin_out.io