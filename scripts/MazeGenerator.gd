extends TileMap

@export var height : int = 60	
@export var width : int = 60

const UNVISITED : int = 0
const VISITED : int = 1

const UNVISITED_TILE : Vector2i = Vector2i(0, 0)
const VISITED_TILE : Vector2i = Vector2i(0, 1)

const START = Vector2i(0, 0)

var grid = []
var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():

	generate_grid()
	rng.randomize()
	generate_maze(START)

func generate_grid() -> void:
	for y in height:
		grid.append([])
		for x in width:
			grid[y].append(UNVISITED)
			set_cell(0, Vector2i(x, y), 0, UNVISITED_TILE)
	

func generate_maze(current_cell : Vector2i):
	# Set the current cell to visited
	grid[current_cell.y][current_cell.x] = VISITED
	set_cell(0, Vector2i(current_cell.x, current_cell.y), 0, VISITED_TILE)
		
	while true:
		var direction = next_direction(current_cell)
		var next_cell
		if direction != Vector2i.ZERO:
			next_cell = current_cell + direction
			if next_cell != START:
				generate_maze(next_cell)
		if direction == Vector2i.ZERO:
			break

func next_direction(current_cell : Vector2i) -> Vector2i:
	var dirs = [Vector2i.UP, Vector2i.DOWN, Vector2i.LEFT, Vector2i.RIGHT]
	dirs.shuffle()
	
	for d in dirs:
		if is_next_valid(current_cell, d):
			return d
			
	return Vector2i(0, 0)

# Checks if the cell is valid
# If the cell is within the maze map and if there is no immediately adjacent visited cells
func is_next_valid(cell : Vector2i, dir : Vector2i) -> bool:
	# Logic is done on the next cell; the current cell summed with the direction
	var next_cell = cell + dir
	
	if next_cell.y >= 0 and next_cell.y < height and next_cell.x >= 0 and next_cell.x < width:
		# Find restrictions
		# We only want to check the cells in a 2x3 area directly in front of the current cell
		# Mfw i just hardcode all of this in 
		var x_min : int = next_cell.x - 1
		var x_max : int = next_cell.x + 1
		var y_min : int = next_cell.y - 1
		var y_max : int = next_cell.y + 1
	
		# If we are travelling up or down
		if dir.x == 0:
			y_min = next_cell.y - 1 if dir == Vector2i.UP else next_cell.y
			y_max = next_cell.y if dir == Vector2i.UP else next_cell.y + 1
	
		else:
			x_min = next_cell.x - 1 if dir == Vector2i.LEFT else next_cell.x
			x_max = next_cell.x if dir == Vector2i.LEFT else next_cell.x + 1
	
	# Counts all the cells within the 2x3 area
	# Loops from the top left to the bottom right 
		var count : int = 0
		for y in range(y_min, y_max + 1):
			for x in range(x_min, x_max + 1):
				if x >= 0 and x < width and y >= 0 and y < height:
					count += grid[y][x]
						
		return not count > 0
	
	# If the next cell is outside of the map, we can just return false
	return false
