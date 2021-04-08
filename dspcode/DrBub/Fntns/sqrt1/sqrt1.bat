@echo Now assemble sqrt1.asm......

asm56300 -a -b -l sqrt1.asm

@echo Now start sim56300 to run sqrt1......

sim56300 sqrt1t.cmd

@echo Execute complete
@echo Please see sqrt1in.io and sqrt1out.io

