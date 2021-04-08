load smlint
input x:$ffffff smlin_in.io -rd
output x:$fffffe smlin_out.io -rh -o
break return
go
quit
