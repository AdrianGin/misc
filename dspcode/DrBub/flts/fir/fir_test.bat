@echo Now assemble firt.asm......

asm56300 -a -b -l firt.asm
@echo Now start sim56300 to run firt......

sim56300 fir.cmd

@echo Execute complete
@echo Please see fir_in.io and fir_out.io
