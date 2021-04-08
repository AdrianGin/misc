@echo Now assemble lind3d4t.asm......

asm56300 -a -b -l lind3d4t.asm

@echo Now start sim56300 to run lind3d4t......

sim56300 lind3d4.cmd

@echo Execute complete
@echo Please see lind3d4_in.io and lind3d4_out.io