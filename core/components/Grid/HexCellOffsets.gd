class_name HexOffsets

const LEFT = Vector2i(-1, 0)
const TOP_LEFT = Vector2i(-1, -1)
const BOTTOM_LEFT = Vector2i(-1, 1)
const RIGHT = Vector2i(1, 0)
const TOP_RIGHT = Vector2i(0, -1)
const BOTTOM_RIGHT = Vector2i(0, 1)

const HEX_NEIGHBOURS = [
	TOP_LEFT, TOP_RIGHT,
	LEFT, RIGHT,
	BOTTOM_LEFT, BOTTOM_RIGHT
]
