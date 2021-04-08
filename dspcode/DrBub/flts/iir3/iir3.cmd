load iir3t
input y:$ffffff ..\data_in.io -rf
output y:$fffffe iir3_out.io -rf -o
break return
go
quit
