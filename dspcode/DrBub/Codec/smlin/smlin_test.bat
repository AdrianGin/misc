@echo Now assemble smlint.asm......

asm56300 -a -b -l smlint.asm

@echo Now start sim56300 to run smlint......

sim56300 smlin.cmd

@echo Execute complete
@echo Please see smlin_in.io and smlin_out.io