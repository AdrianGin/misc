@echo Now assemble iir6t.asm......

asm56300 -a -b -l iir6t.asm

@echo Now start sim56300 to run iir6t......

sim56300 iir6.cmd

@echo Execute complete
@echo Please see iir6_in.io and iir6_out.io