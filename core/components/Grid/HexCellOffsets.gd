class_name HexOffsets

const LEFT = Vector2i(-1, 0)
const TOP_LEFT = Vector2i(-1, -1)
const BOTTOM_LEFT = Vector2i(-1, 1)

const RIGHT = Vector2i(1, 0)
const TOP_RIGHT = Vector2i(1, -1)
const BOTTOM_RIGHT = Vector2i(1, 1)

const DIRECTIONS = [
	BOTTOM_RIGHT,
	RIGHT,
	TOP_RIGHT
]

const AXIS = [
	[TOP_LEFT, BOTTOM_RIGHT],
	[LEFT, RIGHT],
	[BOTTOM_LEFT, TOP_RIGHT]
]


static func hex_step(start_pos: Vector2i, offset: Vector2i, steps: int = 1):
	var previous_pos: Vector2i = start_pos
	for step in steps:
		var fixed_offset = offset
		if offset.y != 0:
			var cancel_x_offset = int(previous_pos.y % 2 == 0)
			fixed_offset.x = offset.x - cancel_x_offset if offset.x > 0 else -cancel_x_offset
		
		previous_pos = previous_pos + fixed_offset
	
	return previous_pos
