load iir4t
input y:$ffffff ..\data_in.io -rf
output y:$fffffe iir4_out.io -rf -o
break return
go
quit
