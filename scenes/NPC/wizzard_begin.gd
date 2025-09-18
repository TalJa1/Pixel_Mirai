extends CharacterBody2D

signal player_collided(body)

@export var dialog_text: String = "Hello, traveler!"
@export var detection_radius: float = 24.0

var _triggered := false

func _ready() -> void:
    # Make this NPC static: no movement or physics processing needed
    set_physics_process(false)
    velocity = Vector2.ZERO
    _create_detection_area()

    # Play idle animation if there is an AnimatedSprite2D child
    var anim_sprite := $wizzard_Wiz_AnimatedBody2D if has_node("wizzard_Wiz_AnimatedBody2D") else null
    if anim_sprite and anim_sprite is AnimatedSprite2D:
        # Ensure the default animation is playing
        var anim_name: String = anim_sprite.animation
        if anim_name == "":
            anim_name = "idle"
        anim_sprite.play(anim_name)

func _create_detection_area() -> void:
    # Create an Area2D at runtime so this script works without editing the scene file.
    var area := Area2D.new()
    area.name = "DetectionArea"

    var cs := CollisionShape2D.new()
    var shape := CircleShape2D.new()
    shape.radius = detection_radius
    cs.shape = shape
    area.add_child(cs)

    add_child(area)

    # Connect signals to detect when a body (player) enters/exits the area
    area.connect("body_entered", Callable(self, "_on_area_body_entered"))
    area.connect("body_exited", Callable(self, "_on_area_body_exited"))

func _on_area_body_entered(body: Node) -> void:
    # Avoid repeated triggers until the player leaves
    if _triggered:
        return

    # Detect the player by common conventions: group 'Player', node name 'Player',
    # or a method on the body indicating it's the player. Adjust to your project.
    var is_player := false
    if body is Node:
        if body.is_in_group("Player"):
            is_player = true
        elif body.name == "Player":
            is_player = true
        elif body.has_method("is_player") and body.is_player():
            is_player = true

    if not is_player:
        return

    _triggered = true
    print(dialog_text)
    emit_signal("player_collided", body)

    # If the player node exposes a method to show dialog, call it (optional)
    if body.has_method("show_dialog"):
        body.show_dialog(dialog_text)

func _on_area_body_exited(_body: Node) -> void:
    # Allow re-triggering when the player leaves and re-enters
    _triggered = false
