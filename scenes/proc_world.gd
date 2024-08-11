extends Node2D

@export var noise_height_texture : NoiseTexture2D
@export var noise_point_texture : NoiseTexture2D
var world_noise : Noise
var point_noise : Noise

var width : int = 100
var height : int = 100

@onready var tilemap = $TileMap

var source_id = 1

var water_layer = 0
var ground_layer1 = 1
var ground_layer2 = 2
var ground_layer3 = 3
var ground_layer4 = 4
var environment_layer = 5
var cliff_layer = 6

var water_atlas = Vector2i(0, 0)

var grass_tiles_arr = []
var dark_grass_tiles_arr = []
var dark_grass_terrain_int = 3
var grass_terrain_int = 1
var grass_atlas_arr = [Vector2i(1, 1), Vector2i(0, 5), Vector2i(1, 5), Vector2i(2, 5), Vector2i(3, 5), Vector2i(0, 6), Vector2i(1, 6)]
var grass_weigths_arr = [0.4, 0.2, 0.1, 0.1, 0.1, 0.1, 0.1]

var soil_tiles_arr = []
var soil_terrain_int = 0

var cliff_tiles_arr = []
var cliff_terrain_int = 2

@onready var camera2d = $CharacterBody2D/Camera2D

func _ready():
	world_noise = noise_height_texture.noise
	point_noise = noise_point_texture.noise
	generate_world()
	
func generate_world():
	for x in range(-width / 2, width / 2):
		for y in range(-height / 2, height / 2):
			var world_noise_val : float = world_noise.get_noise_2d(x, y)
			var point_noise_val : float = point_noise.get_noise_2d(x, y)
			
			# placing ground
			if world_noise_val >= 0:
				# regular grass biome
				if world_noise_val > 0.08:
					grass_tiles_arr.append(Vector2i(x, y))
					
					if world_noise_val < 0.3:
						if 0.1 < point_noise_val and point_noise_val < 0.12:
							plant_placement(Vector2i(0, 0), 6, environment_layer, Vector2i(x, y))
						if 0.12 < point_noise_val and point_noise_val < 0.13:
							plant_placement(Vector2i(1, 0), 6, environment_layer, Vector2i(x, y))
						if 0.13 < point_noise_val and point_noise_val < 0.14:
							plant_placement(Vector2i(3, 0), 6, environment_layer, Vector2i(x, y))
						if 0.14 < point_noise_val and point_noise_val < 0.15:
							plant_placement(Vector2i(5, 0), 6, environment_layer, Vector2i(x, y))
						if 0.15 < point_noise_val and point_noise_val < 0.157:
							plant_placement(Vector2i(2, 6), 6, environment_layer, Vector2i(x, y))
						if 0.157 < point_noise_val and point_noise_val < 0.164:
							plant_placement(Vector2i(0, 3), 6, environment_layer, Vector2i(x, y))
						if 0.164 < point_noise_val and point_noise_val < 0.17:
							plant_placement(Vector2i(2, 3), 6, environment_layer, Vector2i(x, y))
						if 0.17 < point_noise_val and point_noise_val < 0.175:
							plant_placement(Vector2i(3, 3), 3, environment_layer, Vector2i(x, y))
						if 0.175 < point_noise_val and point_noise_val < 0.2:
							plant_placement(Vector2i(0, 2), 3, environment_layer, Vector2i(x, y))
						if 0.2 < point_noise_val and point_noise_val < 0.21:
							plant_placement(Vector2i(4, 1), 3, environment_layer, Vector2i(x, y))
						if 0.21 < point_noise_val and point_noise_val < 0.22:
							plant_placement(Vector2i(1, 2), 3, environment_layer, Vector2i(x, y))
						if 0.22 < point_noise_val and point_noise_val < 0.25:
							plant_placement(Vector2i(3, 2), 3, environment_layer, Vector2i(x, y))
						if 0.25 < point_noise_val and point_noise_val < 0.27:
							plant_placement(Vector2i(4, 3), 3, environment_layer, Vector2i(x, y))
						if 0.27 < point_noise_val and point_noise_val < 0.29:
							plant_placement(Vector2i(6, 4), 3, environment_layer, Vector2i(x, y))
						if 0.27 < point_noise_val and point_noise_val < 0.29:
							plant_placement(Vector2i(6, 4), 3, environment_layer, Vector2i(x, y))
						if 0.29 < point_noise_val and point_noise_val < 0.295:
							plant_placement(Vector2i(6, 1), 3, environment_layer, Vector2i(x, y))
						
					# placing random weighted grass tiles
					if world_noise_val > 0.18:
						var rand_grass = pick_weighted_random_index(grass_weigths_arr)
						tilemap.set_cell(ground_layer3, Vector2i(x, y), 5, grass_atlas_arr[rand_grass])
					
							
					# dark_grass biome
					if world_noise_val > 0.2:
						dark_grass_tiles_arr.append(Vector2i(x, y))
					
					# cliff biome
					if world_noise_val > 0.3:
						cliff_tiles_arr.append(Vector2i(x, y))
						
				
				# beach/soil biome
				soil_tiles_arr.append(Vector2i(x, y))

			# water/ocean
			tilemap.set_cell(water_layer, Vector2(x, y), 4, water_atlas)
			
	tilemap.set_cells_terrain_connect(ground_layer1, soil_tiles_arr, soil_terrain_int, 0)
	tilemap.set_cells_terrain_connect(ground_layer2, grass_tiles_arr, grass_terrain_int, 0)
	tilemap.set_cells_terrain_connect(ground_layer4, dark_grass_tiles_arr, dark_grass_terrain_int, 0)
	tilemap.set_cells_terrain_connect(cliff_layer, cliff_tiles_arr, cliff_terrain_int, 0)

func plant_placement(atlas_pos, source_id, layer, pos):
	tilemap.set_cell(layer, pos, source_id, atlas_pos)

func _input(event):
	if Input.is_action_just_pressed("zoom_in"):
		var zoom_val = abs(camera2d.zoom.x - 0.05)
		if zoom_val != 0:
			camera2d.zoom = Vector2(zoom_val, zoom_val)
		else:
			camera2d.zoom = Vector2(1, 1)
	if Input.is_action_just_pressed("zoom_out"):
		var zoom_val = abs(camera2d.zoom.x + 0.05)
		if zoom_val != 0:
			camera2d.zoom = Vector2(zoom_val, zoom_val)
		else:
			camera2d.zoom = Vector2(1, 1)
			
func pick_weighted_random_index(weights: Array) -> int:
	var total_weight = 0.0
	for weight in weights:
		total_weight += weight
	
	var random_value = randf() * total_weight
	var accumulated_weight = 0.0
	
	for i in range(weights.size()):
		accumulated_weight += weights[i]
		if random_value <= accumulated_weight:
			return i
	
	# Fallback in case of floating-point precision issues
	return weights.size() - 1
