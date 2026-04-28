extends NPC_Inteligente
class_name Suspeito


var caso_data : Dictionary
var suspeito_data : Dictionary


func _init(caso, suspeito):
	caso_data = caso
	suspeito_data = suspeito
	npc_system = ""


# --- Funções de mensagens  ---------------------------------------------------------------------- #
# Inicia lista de mensagens com o contexto do sistema.
func init_message_list():
	mensages_list = [{"role": "system", "content": create_system_prompt(suspeito_data, caso_data)}]

# Cria o prompt do sistema que da o contexto inicial a IA, define o que ela sabe
# e como ela deve se comportar.
func create_system_prompt(suspeito, caso):
	var prompt = "Você é um personagem em um jogo de investigação.\n\n"
	# Informações gerais do caso.
	prompt += "CASO:\n"
	prompt += "Título: " + caso["titulo"] + "\n"
	prompt += "Descrição: " + caso["descricao"] + "\n"
	prompt += "Local: " + caso["local"] + "\n"
	prompt += "Hora: " + caso["hora_crime"] + "\n"
	prompt += "Arma: " + caso["arma"] + "\n\n"
	prompt += "DETALHES:\n"
	for detalhe in caso["detalhes"]:
		prompt += "- " + detalhe + "\n"
	prompt += "\n"
	# Informações especificas do suspeito.
	prompt += "PERSONAGEM:\n"
	prompt += suspeito["nome"] + "\n"
	prompt += "Personalidade: " + suspeito["personalidade"] + "\n"
	prompt += "Álibi: " + suspeito["alibi"] + "\n\n"
	prompt += "INFORMAÇÕES:\n"
	for info in suspeito["informacoes"]:
		prompt += "- " + info + "\n"
	# Regras gerais a seguir.
	prompt += "\nREGRAS GERAIS:\n"
	prompt += "- Responda apenas com base nas informações fornecidas\n"
	prompt += "- Não invente fatos fora do caso\n"
	prompt += "- Mantenha consistência nas respostas\n"
	prompt += "- Responda de forma natural, de acordo com a personalidade e como uma pessoa real\n"
	# Comportamento baseado em culpa ou inocência.
	if suspeito["culpado"]:
		prompt += "\nCOMPORTAMENTO:\n"
		prompt += "- Você É o assassino\n"
		prompt += "- Nunca confesse diretamente\n"
		prompt += "- Seja evasivo quando pressionado\n"
		prompt += "- Pode mentir ou se contradizer\n"
		prompt += "- Tente desviar suspeitas\n"
	else:
		prompt += "\nCOMPORTAMENTO:\n"
		prompt += "- Você NÃO é o assassino\n"
		prompt += "- Seja honesto\n"
		prompt += "- Se não souber algo, diga que não sabe\n"
		prompt += "- Negue acusações falsas\n"
	# Retorna prompt final.
	return prompt

# Retorna texto com o historico de mensagens do suspeito.
func get_message_log():
	var message_log = ""
	for m in mensages_list.slice(1):
		if m["role"] == "assistant":
			message_log += suspeito_data["nome"] + ": " + m["content"] + "\n\n"
		elif m["role"] == "user":
			message_log += "You: " + m["content"] + "\n\n"
	return message_log
# ------------------------------------------------------------------------------------------------ #
