extends Control
class_name Dialog_Box

@export var npc_dialog_text_box : RichTextLabel
@export var player_message : LineEdit

var current_npc : NPC_Inteligente

func _ready() -> void:
	Global.connect_npc_dialog_box.connect(connect_npc)
	Global.dialog_box_update_text.connect(_update_npc_dialog)

# --- Funções ------------------------------------------------------------------------------------ #
# Muda o NPC_Inteligente que vai receber as mensagens enviadas.
func connect_npc(npc):
	current_npc = npc

# Atualiza caixa de texto do npc com o texto recebido.
func _update_npc_dialog(text:String):
	npc_dialog_text_box.text = text

# Manda mensagem escrita pelo player para o NPC_Inteligente conectado atualmente.
func _on_button_pressed():
	var message = player_message.text
	if message:
		current_npc.send_message_to_ia(player_message.text)
		player_message.text = ""
	else:
		print("Mensagem não pode ser vazia")
# ------------------------------------------------------------------------------------------------ #
