@echo Now assemble iir7t.asm......

asm56300 -a -b -l iir7t.asm

@echo Now start sim56300 to run iir7t......

sim56300 iir7.cmd

@echo Execute complete
@echo Please see iir7_in.io and iir7_out.io