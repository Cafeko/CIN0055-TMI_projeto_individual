extends Node2D
class_name Suspeitos_List

var current_index : int = 0

var suspeitos : Array[Suspeito] = []

func _ready():
	Global.suspect_list_preious.connect(previous_suspeito)
	Global.suspect_list_next.connect(next_suspeito)


func add_Suspeitos(new_suspeito):
	add_child(new_suspeito)
	suspeitos.append(new_suspeito)
	new_suspeito.visible = false


func select_suspeito(index):
	current_index = index
	var suspeito = suspeitos[current_index]
	suspeito.visible = true
	Global.connect_npc_dialog_box.emit(suspeito)


func next_suspeito():
	var new_index = current_index + 1
	if new_index >= suspeitos.size():
		new_index = 0
	select_suspeito(new_index)


func previous_suspeito():
	var new_index = current_index - 1
	if new_index < 0:
		new_index = suspeitos.size() - 1 
	select_suspeito(new_index)
