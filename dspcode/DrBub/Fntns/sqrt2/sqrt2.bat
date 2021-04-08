@echo Now assemble sqrt2.asm......

asm56300 -a -b -l sqrt2.asm

@echo Now start sim56300 to run sqrt2......

sim56300 sqrt2t.cmd

@echo Execute complete
@echo Please see sqrt2in.io and sqrt2out.io

