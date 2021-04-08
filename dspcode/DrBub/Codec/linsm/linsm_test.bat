@echo Now assemble linsmt.asm......

asm56300 -a -b -l linsmt.asm

@echo Now start sim56300 to run linsmt......

sim56300 linsm.cmd

@echo Execute complete
@echo Please see linsm_in.io and linsm_out.io