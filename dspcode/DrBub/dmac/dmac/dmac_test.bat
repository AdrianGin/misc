@echo Now assemble dmac_t.asm......

asm56300 -a -b -l dmac_t.asm 

@echo Now start sim56300 to run dmac_t......

sim56300 dmac.cmd

@echo Execute complete
@echo Please see dmac_in.io and dmac_out.io
