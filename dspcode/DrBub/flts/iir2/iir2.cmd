load iir2t
input y:$ffffff ..\data_in.io -rf
output y:$fffffe iir2_out.io -rf -o
break return
go
quit