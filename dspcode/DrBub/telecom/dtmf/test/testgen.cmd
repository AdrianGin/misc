load ..\testgen

input   x:$ffff98       gen_in.io  -rd  
output x:$ffff95 gen_out.io -rf -o
         
break return
go
quit

