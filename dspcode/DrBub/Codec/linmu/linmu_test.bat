@echo Now assemble linmut.asm......

asm56300 -a -b -l linmut.asm

@echo Now start sim56300 to run linmut......

sim56300 linmu.cmd

@echo Execute complete
@echo Please see linmu_in.io and linmu_out.io