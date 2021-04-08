@echo Now assemble sdmac_t.asm......

asm56300 -a -b -l sdmac_t.asm 

@echo Now start sim56300 to run sdmac_t......

sim56300 sdmac.cmd

@echo Execute complete
@echo Please see sdmac_in.io and sdmac_out.io
