@echo Now assemble iir2t.asm......

asm56300 -a -b -l iir2t.asm

@echo Now start sim56300 to run iir2t......

sim56300 iir2.cmd

@echo Execute complete
@echo Please see iir2_in.io and iir2_out.io