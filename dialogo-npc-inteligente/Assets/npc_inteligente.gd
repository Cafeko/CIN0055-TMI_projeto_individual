extends Node2D
class_name NPC_Inteligente

@onready var http = $HTTPRequest

enum Request_Stages {CREATE, POLL}

var url = "https://api.replicate.com/v1/predictions"
var token = "Bote seu token aqui"
var model = "openai/gpt-4.1-mini"
var current_request_stage : Request_Stages
var get_request_url = ""

func _ready():
	Global.connect_npc_dialog_box.emit(self)

# --- Funções de comunicação com IA  ------------------------------------------------------------- #
# Utiliza API para mandar uma requisição para a IA.
func _send_to_ai(player_text):
	current_request_stage = Request_Stages.CREATE
	# URL api:
	var selected_url = url
	# Cabeçalho da requisição: 
	var headers = [
		"Content-Type: application/json",
		"Authorization: Token %s" % token
		]
	# Corpo da requisição:
	var body = {
		"version": model,
		"input": {
			"messages": [
			#{"role": "system", "content": "Você é um ferreiro rabugento em um mundo medieval."},
			{"role": "user","content": player_text}
			#{"role": "assistant", "content": "Já te disse que não vendo espadas baratas."}
			]
		}
	}
	# Converte corpo em json:
	var json = JSON.stringify(body)
	# Atualiza dialog box para exibir "Pensando ..." enquanto espera uma resposta.
	send_text_to_dialog_box("Pensando ...")
	# Manda a requisição http:
	http.request(selected_url, headers, HTTPClient.METHOD_POST, json)


# Executada quando recebe respostas html das requisições feitas.
func _on_HTTPRequest_request_completed(_result, _response_code, _headers, body):
	# Transforma mensagem em algo legivel.
	var json = JSON.parse_string(body.get_string_from_utf8())
	# Estado de criação: obtem o status e faz a consulta do resultado.
	if current_request_stage == Request_Stages.CREATE:
		get_request_url = json["urls"]["get"]
		current_request_stage = Request_Stages.POLL
		await get_tree().create_timer(1.0).timeout
		_check_result(get_request_url)
	elif current_request_stage == Request_Stages.POLL:
		if json.has("status") and json["status"] is String and json["status"] == "succeeded":
			var resposta = ""
			for t in json["output"]:
				resposta += t
			send_text_to_dialog_box(resposta)
		elif json.has("status") and json["status"] is float and json["status"] == 401.0:
			print("HTTP 401.0 - Unauthorized (Não Autorizado), indica que a solicitação feita ao \
servidor falhou porque as credenciais de autenticação são inválidas, \
ausentes ou expiradas.")
		else:
			# continua tentando
			await get_tree().create_timer(2.0).timeout
			_check_result(get_request_url)


# Faz a consulta do resultado da requisição utilizando a url de consulta.
func _check_result(consulta_url):
	var headers = [
		"Authorization: Token %s" % token
	]
	http.request(consulta_url, headers)
# ------------------------------------------------------------------------------------------------ #
# --- Funções de interação com interface --------------------------------------------------------- #
# Envia texto recebido para a IA.
func send_message_to_ia(text):
	_send_to_ai(text)

# Emite sinal enviando texto recebido para a Dialog_Box. 
func send_text_to_dialog_box(text):
	Global.dialog_box_update_text.emit(text)
# ------------------------------------------------------------------------------------------------ #
