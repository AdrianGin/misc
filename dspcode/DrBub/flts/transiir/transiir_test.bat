@echo Now assemble transiir.asm......

asm56300 -a -b -l transiir.asm

@echo Now start sim56300 to run transiir......

sim56300 transiir.cmd

@echo Execute complete
@echo Please see transiir_in.io and transiir_out.io
