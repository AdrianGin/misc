@echo Now assemble sort2t.asm......

asm56300 -a -b -l sort2t.asm

@echo Now start sim56300 to run sort2t......

sim56300 sort2.cmd

@echo Execute complete
@echo Please see s2_in.io and s2_out.io
