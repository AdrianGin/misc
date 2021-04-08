load iir7t
input y:$ffffff ..\data_in.io -rf
output y:$fffffe iir7_out.io -rf -o
break return
go
quit
