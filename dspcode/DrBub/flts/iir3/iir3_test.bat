@echo Now assemble iir3t.asm......

asm56300 -a -b -l iir3t.asm

@echo Now start sim56300 to run iir3t......

sim56300 iir3.cmd

@echo Execute complete
@echo Please see iir3_in.io and iir3_out.io