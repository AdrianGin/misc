load log2t
input y:$f000 log2in.io -rf
output y:$f002 log2out.io -rf -o
break return
go
quit
