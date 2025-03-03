extends RigidBody3D

@export var lifetime = 5.0  # Seconds before bullet despawns

func _ready():
	# Automatically despawn after lifetime
	await get_tree().create_timer(lifetime).timeout
	queue_free()

func _on_body_entered(body):
	if body.is_in_group("player"):
		print("Player hit! Deal damage here.")
		# Add damage logic later (e.g., call a method on the player)
	queue_free()  # Destroy bullet on impact
