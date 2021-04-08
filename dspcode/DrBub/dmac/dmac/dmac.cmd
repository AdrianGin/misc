load dmac_t
input x:$ffffff dmac_in.io -rd
output x:$fffffe dmac_out.io -rd -o
break   return
go
quit
