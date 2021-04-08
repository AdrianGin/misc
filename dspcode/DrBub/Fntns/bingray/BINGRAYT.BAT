@echo Now assemble bingrayt.asm......

asm56300 -a -b -l bingrayt.asm

@echo Now start sim56300 to run bingrayt......

sim56300 bingrayt.cmd

@echo Execute complete
@echo Please see bingray.io
