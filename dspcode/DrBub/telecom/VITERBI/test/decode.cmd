load ..\decode
load ..\bound.d
input y:$efe data_enc.io -rd
output y:$eff data_out.io -rd -o
break return
go
