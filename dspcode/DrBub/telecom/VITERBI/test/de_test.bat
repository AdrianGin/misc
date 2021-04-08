

@echo Now assemble decode.asm......
@sleep   2
@cd ..
asm56300 -a -b -l decode.asm
@cd test
@sleep   2

cls
@echo Now start sim56300 to run decode......
@sleep   4
sim56300 decode.cmd

cls

@echo Execute complete
@echo Please see in.io and out.io
