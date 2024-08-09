extends CanvasLayer

@onready var slider_text := $Control/RichTextLabel2

func _ready() -> void:
	slider_text.text = '[center]Bullets: %s[/center]' % Settings.bullets

func _on_v_slider_value_changed(value: float) -> void:
	Settings.bullets = pow(2, int(value))
	slider_text.text = '[center]Bullets: %s[/center]' % Settings.bullets


func _on_pooling_button_toggled(toggled_on: bool) -> void:
	Settings.object_pooling = toggled_on
