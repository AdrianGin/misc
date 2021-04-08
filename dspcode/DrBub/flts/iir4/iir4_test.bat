@echo Now assemble iir4t.asm......

asm56300 -a -b -l iir4t.asm

@echo Now start sim56300 to run iir4t......

sim56300 iir4.cmd

@echo Execute complete
@echo Please see iir4_in.io and iir4_out.io