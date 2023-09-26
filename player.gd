extends Area2D

signal hit

@export var speed = 400 # How fast the player will move (pixels/sec).
@export var rotation_speed = 5
var max_screen_size # Size of the game window.
var min_screen_size
var body_dimensions

# Called when the node enters the scene tree for the first time.
func _ready():
	body_dimensions = Vector2($Body.get_sprite_frames().get_frame_texture("swim", 0).get_width(),
	 $Body.get_sprite_frames().get_frame_texture("swim", 0).get_height()) / 4
	max_screen_size = get_viewport_rect().size - body_dimensions
	min_screen_size = Vector2.ZERO + body_dimensions
	hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocity = 0
	var rotate = 0.0
	if Input.is_action_pressed("move"):
		velocity = 1
	if Input.is_action_pressed("rotate_clockwise"):
		rotate = 1.0
	if Input.is_action_pressed("rotate_counter_clockwise"):
		rotate = -1.0

	if velocity != 0:
#		velocity = velocity.normalized() * speed
		$Body.play("swim")
		$Eye.play("look")
		
	else:
		$Body.stop()
		$Eye.stop()
	
	rotation += rotate * delta * rotation_speed
	position += Vector2.UP.rotated(rotation) * (velocity * delta * speed)
	position = position.clamp(min_screen_size, max_screen_size)


func _on_body_entered(body):
	hide()
	hit.emit()
	$CollisionShape2D.set_deferred("disabled", true)
	
func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false
