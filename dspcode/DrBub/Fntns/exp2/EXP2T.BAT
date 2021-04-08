@echo Now assemble exp2t.asm......

asm56300 -a -b -l exp2t.asm

@echo Now start sim56300 to run exp2t......

sim56300 exp2t.cmd

@echo Execute complete
@echo Please see exp2in.io and exp2out.io

