load ..\rscd
input x:$fff000 in.io -rh
output x:$fff001 out.io -rh -o
break return
go
