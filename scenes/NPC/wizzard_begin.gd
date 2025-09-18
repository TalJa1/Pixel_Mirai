extends CharacterBody2D

# Wizard NPC: play idle animation and show label when player enters interaction area

var anim: AnimatedSprite2D
var label: Label
var default_label_text: String = ""

func _ready() -> void:
	# Cache nodes from the scene. Adjust names if you rename nodes in the editor.
	if has_node("wizzard_Wiz_AnimatedBody2D"):
		anim = $wizzard_Wiz_AnimatedBody2D
	if has_node("Label"):
		label = $Label

	# Ensure idle animation is playing
	if anim and anim.animation != "idle":
		anim.animation = "idle"
	if anim and not anim.is_playing():
		anim.play()
	
  
	# Prevent Area2D emitting a body_entered during scene setup by enabling monitoring deferred
	if has_node("Interate_Area2D"):
		$Interate_Area2D.monitoring = false
		call_deferred("_enable_interact_area")


func _enable_interact_area() -> void:
	# called deferred so enabling monitoring doesn't trigger immediate enter events during setup
	if has_node("Interate_Area2D"):
		$Interate_Area2D.monitoring = true


func _on_interate_area_2d_body_entered(body: Node) -> void:
	# Show the label only when the player (CharacterBody2D) enters the area
		if label == null:
				return


		if body is CharacterBody2D or body.get("name") == "Player" or body.get_class() == "CharacterBody2D":
			label.text = "Hello, how are you today?"
			label.show()


func _on_interate_area_2d_body_exited(body: Node) -> void:
	# Hide the label when the player leaves
	if label == null:
		return

	if body is CharacterBody2D or body.get("name") == "Player" or body.get_class() == "CharacterBody2D":
		# restore default text and hide
		label.text = default_label_text
		label.hide()
