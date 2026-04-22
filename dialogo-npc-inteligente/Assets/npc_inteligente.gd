extends Node2D
class_name NPC_Inteligente

@onready var http = $HTTPRequest

enum Request_Stages {CREATE, POLL}

var url = "https://api.replicate.com/v1/predictions"
var token = "r8_F8Vttt1vYquJ7Ryf6p7Sz108WSxW4Vu4FOGL4"
var model = "openai/gpt-4.1-mini"
var current_request_stage : Request_Stages
var get_request_url = ""

func _ready():
	var texto = "Me de 5 exemplos de frutas doce"
	send_to_ai(texto)

# --- Funções de comunicação com IA  ------------------------------------------------------------- #
# Utiliza API para mandar uma requisição para a IA.
func send_to_ai(player_text):
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
		check_result(get_request_url)
	elif current_request_stage == Request_Stages.POLL:
		if json.has("status") and json["status"] == "succeeded":
			var resposta = ""
			for t in json["output"]:
				resposta += t
			print(resposta)
		else:
			# continua tentando
			await get_tree().create_timer(2.0).timeout
			check_result(get_request_url)


# Faz a consulta do resultado da requisição utilizando a url de consulta.
func check_result(consulta_url):
	var headers = [
		"Authorization: Token %s" % token
	]
	http.request(consulta_url, headers)
# ------------------------------------------------------------------------------------------------ #
