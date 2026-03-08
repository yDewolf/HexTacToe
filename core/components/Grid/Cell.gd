class_name HexCell

var position: Vector2i = Vector2i.ZERO
var player_id: int = -1

var baked_axis_positions: Array[Array]

func _init(pos: Vector2i, _player_id: int, streak: int = 6) -> void:
	self.position = pos
	self.player_id = _player_id
	
	self.baked_axis_positions = HexCell.get_axis_positions(self.position, streak)

func test_win_condition(all_cells: Dictionary[Vector2i, HexCell], streak: int = 6) -> Array[HexCell]:
	var cell_streak: Array[HexCell] = HexCell.get_cell_streak(
		self.baked_axis_positions,
		all_cells,
		self.player_id,
		streak
	)
	
	return cell_streak


static func get_cell_streak(axis_positions: Array[Array], all_cells: Dictionary[Vector2i, HexCell], p_id: int, streak: int = 6) -> Array[HexCell]:
	var cell_streak: Array[HexCell] = []
	for axis in axis_positions:
		cell_streak.clear()
		for offsetted_pos in axis:
			var cell_at_offset = all_cells.get(offsetted_pos, null)
			if cell_at_offset == null:
				continue
			
			if cell_at_offset.player_id != p_id:
				cell_streak.clear()
				continue
			
			cell_streak.append(cell_at_offset)
			
			if len(cell_streak) == streak:
				return cell_streak
	
	return cell_streak

static func get_cell_streak_for_bot(axis: Array, all_cells: Dictionary, p_id: int) -> Array:
	var found = []
	for pos in axis:
		var cell = all_cells.get(pos)
		if cell and cell.player_id == p_id:
			found.append(pos)
	
	return found


static func get_axis_positions(pos: Vector2i, max_length: int = 6) -> Array[Array]:
	var positions: Array[Array] = []
	
	for offset in HexOffsets.DIRECTIONS:
		var axis_positions: Array[Vector2i] = []
		var start_pos = HexOffsets.hex_step(
			pos, -offset, max_length
		)
		var previous_pos = start_pos
		for offset_step in range(0, max_length * 2 - 1):
			var offsetted_pos = HexOffsets.hex_step(previous_pos, offset)
			previous_pos = offsetted_pos
			axis_positions.append(previous_pos)
		
		positions.append(axis_positions)
	
	return positions
