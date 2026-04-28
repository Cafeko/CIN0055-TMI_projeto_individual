extends Panel
class_name Dialog_Log

@onready var text_space = $Panel/VBoxContainer/RichTextLabel

# Atualiza o texto que é exibido no log.
func update_text_space(new_text:String):
	text_space.text = new_text
