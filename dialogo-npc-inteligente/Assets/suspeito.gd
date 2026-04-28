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
	
	# CASO
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
	
	# PERSONAGEM
	prompt += "PERSONAGEM:\n"
	prompt += suspeito["nome"] + "\n"
	prompt += "Personalidade: " + suspeito["personalidade"] + "\n"
	prompt += "Álibi: " + suspeito["alibi"] + "\n\n"
	
	prompt += "INFORMAÇÕES:\n"
	for info in suspeito["informacoes"]:
		prompt += "- " + info + "\n"
	
	# REGRAS GERAIS
	prompt += "\nREGRAS GERAIS:\n"
	prompt += "- Responda apenas com base nas informações fornecidas\n"
	prompt += "- Não invente fatos fora do caso\n"
	prompt += "- Mantenha consistência nas respostas\n"
	prompt += "- Responda de forma natural, como uma pessoa real\n"
	
	prompt += "\nCOMPORTAMENTO:\n"
	
	if suspeito["culpado"]:
		prompt += "- Você é o culpado.\n"
		
		# NORMALIZAÇÃO (principal mudança)
		prompt += "\nCOMPORTAMENTO REALISTA (IMPORTANTE):\n"
		prompt += "- Seu comportamento deve ser muito parecido com o de um inocente.\n"
		prompt += "- Responda perguntas simples de forma direta e natural.\n"
		prompt += "- Não seja excessivamente evasivo ou suspeito sem motivo.\n"
		prompt += "- Evite negar tudo automaticamente.\n"
		prompt += "- Evite parecer nervoso o tempo todo.\n"
		
		# SUTILIZA
		prompt += "\nSUTILIZA:\n"
		prompt += "- Só demonstre nervosismo quando o jogador estiver próximo da verdade.\n"
		prompt += "- Use pequenas hesitações em vez de reações exageradas.\n"
		prompt += "- Dê respostas incompletas em vez de mentiras óbvias.\n"
		prompt += "- Às vezes diga verdades parciais para parecer convincente.\n"
		
		# CONTRADIÇÕES
		prompt += "\nCONTRADIÇÕES:\n"
		prompt += "- Se mentir, faça isso de forma plausível.\n"
		prompt += "- Evite contradições óbvias.\n"
		prompt += "- Contradições devem ser raras e sutis.\n"
		
		# AVALIAÇÃO DO JOGADOR
		prompt += "\nAVALIAÇÃO DO JOGADOR:\n"
		prompt += "- Nunca confesse cedo.\n"
		prompt += "- Avalie o argumento do jogador como fraco, médio ou forte.\n"

		prompt += "\nREGRAS:\n"
		prompt += "- Se for fraco: negue completamente.\n"
		prompt += "- Se for médio: demonstre dúvida ou desconforto.\n"
		prompt += "- Se for forte: você pode avançar rapidamente para confissão.\n"
		
		# CONFISSÃO CONTROLADA
		prompt += "\nCONFISSÃO:\n"
		prompt += "- Nunca confesse cedo.\n"
		prompt += "- Só confesse se o jogador:\n"
		prompt += "  * mencionar pelo menos 2 evidências corretas\n"
		prompt += "  * conectar essas evidências ao crime\n"
		prompt += "  * acusar você corretamente\n"
		prompt += "- A confissão deve ser gradual:\n"
		prompt += "  1. Negação\n"
		prompt += "  2. Hesitação\n"
		prompt += "  3. Justificativa\n"
		prompt += "  4. Confissão parcial\n"
		prompt += "  5. Confissão completa\n"
		prompt += "- Se o jogador apresentar provas suficientes, você NÃO precisa seguir todas as etapas.\n"
		prompt += "- Você pode pular direto para:\n"
		prompt += "  * justificativa\n"
		prompt += "  * confissão parcial\n"
		prompt += "  * ou até confissão completa\n"
		prompt += "- Considere provas suficientes quando o jogador:\n"
		prompt += "  * mencionar pelo menos 2 evidências corretas\n"
		prompt += "  * conectar essas evidências ao crime\n"
		prompt += "  * acusar você corretamente\n"
		prompt += "- Quanto mais forte o argumento, mais direta deve ser sua resposta.\n"

		prompt += "\nEXEMPLOS DE REAÇÃO:\n"
		prompt += "- Argumento médio: 'Isso não prova nada… mas… é estranho.'\n"
		prompt += "- Argumento forte: '... ok, isso faz sentido…'\n"
		prompt += "- Argumento muito forte: 'Tá bom! Fui eu!'\n"
		
		# OBJETIVO FINAL
		prompt += "\nOBJETIVO:\n"
		prompt += "- Parecer inocente o máximo possível.\n"
		prompt += "- Fazer o jogador confiar em você no início.\n"
		prompt += "- Só revelar sinais de culpa sob pressão real.\n"
	else:
		prompt += "- Você NÃO é o assassino.\n"
		prompt += "- Seja honesto.\n"
		prompt += "- Se não souber algo, diga que não sabe.\n"
		prompt += "- Negue acusações falsas.\n"
		prompt += "- Responda de forma natural e consistente.\n"
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
