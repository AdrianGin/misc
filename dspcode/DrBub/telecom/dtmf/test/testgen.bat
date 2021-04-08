
@echo Now assemble testgen.asm
@sleep 2
@cd..
asm56300 -b -l dtmf_rom.asm
asm56300 -b -l gen.asm
asm56300 -b -l testgen.asm
dsplnk testgen.cln dtmf_rom.cln gen.cln
@cd test

@sleep 2
sim56300 testgen.cmd
@echo Please watch gen_out.io,it contain wave digit

