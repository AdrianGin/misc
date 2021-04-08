

@echo Now assemble rscd.asm......
@cd ..
asm56300 -a -b -l rscd.asm
cd test

@echo Now start sim56000 to run rscd......
@sleep   4
sim56300 rscd.cmd

@echo Execute complete
@echo Please see out.io
