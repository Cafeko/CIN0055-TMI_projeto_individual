extends Control
class_name Formulario_Caso

@onready var titulo = $Panel/VBoxContainer/Titulo
@onready var descricao = $Panel/VBoxContainer/Descricao
@onready var local = $Panel/VBoxContainer/Local
@onready var hora = $Panel/VBoxContainer/Hora
@onready var arma = $Panel/VBoxContainer/Arma
@onready var detalhes_container = $Panel/VBoxContainer/DetalhesContainer


func update_caso_data(caso):
	# Preenche dados.
	titulo.text = caso["titulo"]
	descricao.text = caso["descricao"]
	local.text = "Local: " + caso["local"]
	hora.text = "Hora: " + caso["hora_crime"]
	arma.text = "Arma: " + caso["arma"]
	# adicionar detalhes
	detalhes_container.text = ""
	for detalhe in caso["detalhes"]:
		detalhes_container.text += "- " + detalhe + "\n"
