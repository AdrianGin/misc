@echo Now assemble sort1t.asm......

asm56300 -a -b -l sort1t.asm

@echo Now start sim56300 to run sort1t......

sim56300 sort1.cmd

@echo Execute complete
@echo Please see s1_in.io and s1_out.io
