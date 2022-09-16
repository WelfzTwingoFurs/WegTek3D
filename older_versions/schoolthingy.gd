extends Node2D

func _ready():
	var N = 85
	print("Veja se um número é primo. Qual? ",N)
	
	for n in N:#vai de 0 até N-1
		if n > 1:
			print(N,"/",n,"= float(",float(N)/n,"), int(",int(N)/n,")")
			
			if int(N)/n == float(N)/n:
				print("Não é primo:",N,"/",n,"=",N/n)
				break
			
		
		if n == N-1:
			print(N," é primo.")
