load iir5t
input y:$ffffff ..\data_in.io -rf
output y:$fffffe iir5_out.io -rf -o
break return
go
quit
