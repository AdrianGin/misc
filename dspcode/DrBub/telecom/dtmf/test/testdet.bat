
@echo Now assemble testdet.asm
@sleep 2
@cd..
asm56300 -b -l dtmf_rom.asm
asm56300 -b -l tst.asm
asm56300 -b -l det.asm
asm56300 -b -l testdet.asm
dsplnk testdet.cln  tst.cln det.cln dtmf_rom.cln
@cd test

@sleep 2
sim56300 testdet.cmd
@echo Please watch det_out.io,it contain telephone digit
@sleep 2
