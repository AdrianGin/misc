@echo Now assemble sqrt3.asm......

asm56300 -a -b -l sqrt3.asm

@echo Now start sim56300 to run sqrt3......

sim56300 sqrt3t.cmd

@echo Execute complete
@echo Please see sqrt3in.io and sqrt3out.io

