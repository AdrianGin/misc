load iir6t
input y:$ffffff ..\data_in.io -rf
output y:$fffffe iir6_out.io -rf -o
break return
go
quit
