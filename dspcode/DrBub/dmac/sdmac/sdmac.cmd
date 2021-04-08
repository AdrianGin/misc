load sdmac_t
input x:$ffffff sdmac_in.io -rh
output x:$fffffe sdmac_out.io -rh -o
break   return
go
quit
