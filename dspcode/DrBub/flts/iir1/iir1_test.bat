@echo Now assemble iir1t.asm......

asm56300 -a -b -l iir1t.asm

@echo Now start sim56300 to run iir1t......

sim56300 iir1.cmd

@echo Execute complete
@echo Please see iir1_in.io and iir1_out.io