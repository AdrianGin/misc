load ..\testdet

input x:$ffff98 gen_out.io -rf
output x:$ffff95 det_out.io -rd -o

break return
go
quit

