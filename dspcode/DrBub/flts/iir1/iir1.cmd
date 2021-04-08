load iir1t
input y:$ffffff ..\data_in.io -rf
output y:$fffffe iir1_out.io -rf -o
break return
go
quit
