

@echo Now assemble encode.asm......
@sleep   2
@cd..
asm56300 -a -b -l encode.asm
@cd test
@sleep   2


@echo Now start sim56300 to run encode......
@sleep   4
sim56300 encode.cmd

@echo Execute complete
@echo Please see in.io and out.io
