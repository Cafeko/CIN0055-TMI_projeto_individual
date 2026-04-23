extends Node

#signal all_ready

@export var caso_path : String
@export var suspeitos_list : Suspeitos_List

var dados_caso
var dados_suspeitos

func _ready():
	load_caso()
	cria_suspeitos()
	#all_ready.emit()

# Carrega informações do arquivo com os dados do caso e dos suspeitos.
func load_caso():
	var file = FileAccess.open(caso_path, FileAccess.READ)
	var content = file.get_as_text()
	var dados = JSON.parse_string(content)
	dados_caso = dados["caso"]
	dados_suspeitos = dados["suspeitos"]


# Cria os suspeitos que serão interrogados e adiciona eles a lista de suspeitos.
func cria_suspeitos():
	for sus_data in dados_suspeitos:
		# Cria suspeito.
		var novo_suspeito = Suspeito.new(dados_caso, sus_data)
		# Adiciona a lista de suspeitos.
		suspeitos_list.add_Suspeitos(novo_suspeito)
		# Cria sprite do suspeito.
		var sprite = Sprite2D.new()
		sprite.texture = load(sus_data["sprite"])
		novo_suspeito.add_child(sprite)
	suspeitos_list.select_suspeito(0)
