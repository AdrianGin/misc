@echo Now assemble iir5t.asm......

asm56300 -a -b -l iir5t.asm

@echo Now start sim56300 to run iir5t......

sim56300 iir5.cmd

@echo Execute complete
@echo Please see iir5_in.io and iir5_out.io