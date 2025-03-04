@tool
extends EditorScript

# Planet data for all 12 planets
var planets = [
	{
		"name": "earth",
		"type": "Terrestrial",
		"features": "Starting point, dense population",
		"terrain_size": Vector3(100, 0.2, 100),
		"terrain_color": Color(0, 1, 0),
		"building": {"type": "Building", "size": Vector3(5, 10, 5), "pos": Vector3(10, 5, 10)},
		"npc": {"type": "Citizen", "pos": Vector3(5, 1, 5)}
	},
	{
		"name": "epsilon_station",
		"type": "Space Station",
		"features": "Trade hub, mission board",
		"terrain_size": Vector3(100, 0.1, 100),
		"terrain_color": Color(0.8, 0.8, 0.8),
		"building": {"type": "TradeKiosk", "size": Vector3(5, 5, 5), "pos": Vector3(10, 2.5, 10)},
		"npc": {"type": "Trader", "pos": Vector3(5, 0.5, 5)}
	},
	{
		"name": "beta_ceti",
		"type": "Gas Giant",
		"features": "Resource extraction, hazards",
		"terrain_size": Vector3(100, 0.2, 100),
		"terrain_color": Color(0.5, 0.5, 0.5),
		"building": {"type": "MiningRig", "size": Vector3(10, 10, 10), "pos": Vector3(10, 5, 10)},
		"npc": {"type": "Hazard", "pos": Vector3(15, 0.2, 15), "mesh": "SphereMesh", "radius": 2}
	},
	{
		"name": "kepler",
		"type": "Terrestrial",
		"features": "Frontier, mission-rich",
		"terrain_size": Vector3(100, 0.2, 100),
		"terrain_color": Color(0, 1, 0),
		"building": {"type": "Outpost", "size": Vector3(8, 6, 8), "pos": Vector3(12, 3, 12)},
		"npc": {"type": "FrontierNPC", "pos": Vector3(5, 1, 5)}
	},
	{
		"name": "dyson_7",
		"type": "Artificial",
		"features": "High-tech, Syndicate activity",
		"terrain_size": Vector3(100, 0.2, 100),
		"terrain_color": Color(0, 0.5, 1),
		"building": {"type": "TechTower", "size": Vector3(5, 15, 5), "pos": Vector3(10, 7.5, 10)},
		"npc": {"type": "Syndicate", "pos": Vector3(5, 1, 5)}
	},
	{
		"name": "orion_4",
		"type": "Terrestrial",
		"features": "Agricultural, Ranger base",
		"terrain_size": Vector3(100, 0.2, 100),
		"terrain_color": Color(0.5, 0.8, 0),
		"building": {"type": "Barn", "size": Vector3(10, 8, 10), "pos": Vector3(10, 4, 10)},
		"npc": {"type": "Ranger", "pos": Vector3(5, 1, 5)}
	},
	{
		"name": "alpha_draconis",
		"type": "Hostile",
		"features": "Dangerous, high rewards",
		"terrain_size": Vector3(100, 0.3, 100),
		"terrain_color": Color(1, 0.2, 0.2),
		"building": {"type": "Rock", "size": Vector3(5, 5, 5), "pos": Vector3(10, 2.5, 10)},
		"npc": null
	},
	{
		"name": "sirius_verge",
		"type": "Trade Hub",
		"features": "Corporate trade routes",
		"terrain_size": Vector3(100, 0.2, 100),
		"terrain_color": Color(0.7, 0.7, 0.7),
		"building": {"type": "Office", "size": Vector3(10, 10, 10), "pos": Vector3(10, 5, 10)},
		"npc": {"type": "Trader", "pos": Vector3(5, 1, 5)}
	},
	{
		"name": "tau_ceti_3",
		"type": "Syndicate",
		"features": "Black market, raids",
		"terrain_size": Vector3(100, 0.2, 100),
		"terrain_color": Color(0.3, 0.3, 0.3),
		"building": {"type": "Shack", "size": Vector3(6, 4, 6), "pos": Vector3(10, 2, 10)},
		"npc": {"type": "Syndicate", "pos": Vector3(5, 1, 5)}
	},
	{
		"name": "proxima_9",
		"type": "Resource",
		"features": "Mining, corporate interest",
		"terrain_size": Vector3(100, 0.2, 100),
		"terrain_color": Color(0.6, 0.4, 0.2),
		"building": {"type": "Drill", "size": Vector3(5, 10, 5), "pos": Vector3(10, 5, 10)},
		"npc": {"type": "Corporate", "pos": Vector3(5, 1, 5)}
	},
	{
		"name": "beta_hercules",
		"type": "Contested",
		"features": "Battleground, neutral zone",
		"terrain_size": Vector3(100, 0.2, 100),
		"terrain_color": Color(0.4, 0.4, 0.4),
		"building": {"type": "Barricade", "size": Vector3(10, 5, 2), "pos": Vector3(10, 2.5, 10)},
		"npc": null
	},
	{
		"name": "zeta_prime",
		"type": "Industrial",
		"features": "Factories, corporate HQ",
		"terrain_size": Vector3(100, 0.2, 100),
		"terrain_color": Color(0.5, 0.5, 0.6),
		"building": {"type": "Factory", "size": Vector3(15, 10, 15), "pos": Vector3(10, 5, 10)},
		"npc": {"type": "Worker", "pos": Vector3(5, 1, 5)}
	}
]

func _run():
	print("Generating all scenes...")
	var dir = DirAccess.open("res://scenes/planet/")
	if not dir.dir_exists("res://scenes/planet/"):
		dir.make_dir("res://scenes/planet/")

	# Create base PlanetScene in memory
	var base_scene = create_base_planet_scene()

	# Generate and save PlanetScene.tscn
	var packed_base_scene = PackedScene.new()
	packed_base_scene.pack(base_scene)
	ResourceSaver.save(packed_base_scene, "res://scenes/planet/PlanetScene.tscn")

	# Generate all planet-specific scenes
	for planet in planets:
		generate_planet_scene(planet, base_scene.duplicate())

	print("All scenes generated successfully!")

func create_base_planet_scene():
	var root = Node3D.new()
	root.name = "PlanetScene"

	# Player
	var player = CharacterBody3D.new()
	player.name = "Player"
	player.position = Vector3(0, 0, 0)
	root.add_child(player)
	player.owner = root

	var player_mesh = MeshInstance3D.new()
	player_mesh.name = "MeshInstance3D"
	player_mesh.mesh = CapsuleMesh.new()
	player_mesh.mesh.height = 2
	player_mesh.mesh.radius = 0.5
	player.add_child(player_mesh)
	player_mesh.owner = root

	var player_collision = CollisionShape3D.new()
	player_collision.name = "CollisionShape3D"
	player_collision.shape = CapsuleShape3D.new()
	player_collision.shape.height = 2
	player_collision.shape.radius = 0.5
	player.add_child(player_collision)
	player_collision.owner = root

	var camera = Camera3D.new()
	camera.name = "Camera3D"
	camera.current = true
	camera.position = Vector3(0, 1, 0)
	player.add_child(camera)
	camera.owner = root

	# Ground (default)
	var ground = StaticBody3D.new()
	ground.name = "Ground"
	ground.position = Vector3(0, -0.1, 0)
	root.add_child(ground)
	ground.owner = root

	var ground_mesh = MeshInstance3D.new()
	ground_mesh.name = "MeshInstance3D"
	ground_mesh.mesh = BoxMesh.new()
	ground_mesh.mesh.size = Vector3(100, 0.2, 100)
	ground.add_child(ground_mesh)
	ground_mesh.owner = root

	var ground_collision = CollisionShape3D.new()
	ground_collision.name = "CollisionShape3D"
	ground_collision.shape = BoxShape3D.new()
	ground_collision.shape.size = Vector3(100, 0.2, 100)
	ground.add_child(ground_collision)
	ground_collision.owner = root

	# MissionManager
	var mission_manager = Node.new()
	mission_manager.name = "MissionManager"
	root.add_child(mission_manager)
	mission_manager.owner = root

	return root

func generate_planet_scene(planet_data, base_scene):
	var root = Node3D.new()
	root.name = planet_data["name"].capitalize().replace("_", "")

	# Use duplicated base scene
	var planet_scene = base_scene
	planet_scene.name = "PlanetScene"
	root.add_child(planet_scene)
	planet_scene.owner = root
	for child in planet_scene.get_children():
		child.owner = root
		for subchild in child.get_children():
			subchild.owner = root

	# Customize Ground
	var ground = planet_scene.get_node("Ground")
	ground.position = Vector3(0, -planet_data["terrain_size"].y / 2, 0)
	var mesh_instance = ground.get_node("MeshInstance3D")
	mesh_instance.mesh.size = planet_data["terrain_size"]
	var material = StandardMaterial3D.new()
	material.albedo_color = planet_data["terrain_color"]
	mesh_instance.set_surface_override_material(0, material)
	var collision_shape = ground.get_node("CollisionShape3D")
	collision_shape.shape.size = planet_data["terrain_size"]

	# Add Building
	if planet_data["building"]:
		var building = StaticBody3D.new()
		building.name = planet_data["building"]["type"]
		root.add_child(building)
		building.owner = root
		building.position = planet_data["building"]["pos"]
		var csg_box = CSGBox3D.new()
		csg_box.size = planet_data["building"]["size"]
		building.add_child(csg_box)
		csg_box.owner = root
		var building_collision = CollisionShape3D.new()
		var building_shape = BoxShape3D.new()
		building_shape.size = planet_data["building"]["size"]
		building_collision.shape = building_shape
		building.add_child(building_collision)
		building_collision.owner = root

	# Add NPC or Object
	if planet_data["npc"]:
		var npc = Node3D.new()
		npc.name = planet_data["npc"]["type"]
		root.add_child(npc)
		npc.owner = root
		npc.position = planet_data["npc"]["pos"]
		var mesh_instance_npc = MeshInstance3D.new()
		if planet_data["npc"].has("mesh") and planet_data["npc"]["mesh"] == "SphereMesh":
			var sphere_mesh = SphereMesh.new()
			sphere_mesh.radius = planet_data["npc"]["radius"]
			sphere_mesh.height = planet_data["npc"]["radius"] * 2
			mesh_instance_npc.mesh = sphere_mesh
			var hazard_material = StandardMaterial3D.new()
			hazard_material.albedo_color = Color(1, 0, 0)
			mesh_instance_npc.set_surface_override_material(0, hazard_material)
		else:
			var capsule_mesh = CapsuleMesh.new()
			capsule_mesh.height = 2
			capsule_mesh.radius = 0.5
			mesh_instance_npc.mesh = capsule_mesh
		npc.add_child(mesh_instance_npc)
		mesh_instance_npc.owner = root

	# Save the scene
	var packed_scene = PackedScene.new()
	packed_scene.pack(root)
	ResourceSaver.save(packed_scene, "res://scenes/planet/" + planet_data["name"] + ".tscn")
