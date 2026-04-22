extends Node2D
class_name Suspeitos_List

var suspeitos : Array[Suspeito] = []

func add_Suspeitos(new_suspeito):
	add_child(new_suspeito)
	suspeitos.append(new_suspeito)
