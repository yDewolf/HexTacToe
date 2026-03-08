class_name HexCell

var position: Vector2i = Vector2i.ZERO
var player_id: int = -1

var baked_axis_positions: Array[Array]

func _init(pos: Vector2i, _player_id: int, streak: int = 6) -> void:
	self.position = pos
	self.player_id = _player_id
	
	self.baked_axis_positions = get_axis_positions(streak)

func test_win_condition(all_cells: Dictionary[Vector2i, HexCell], streak: int = 6) -> Array[HexCell]:
	var cell_streak: Array[HexCell] = []
	for axis in self.baked_axis_positions:
		cell_streak.clear()
		for offsetted_pos in axis:
			var cell_at_offset = all_cells.get(offsetted_pos, null)
			if cell_at_offset == null:
				continue
			
			if cell_at_offset.player_id != self.player_id:
#				FIXME: Arrumar o baglh de skipar um tile
				cell_streak.clear()
				continue
			
			cell_streak.append(cell_at_offset)
			
			if len(cell_streak) == streak:
				return cell_streak
	
	return []


func get_axis_positions(max_length: int = 6) -> Array[Array]:
	var positions: Array[Array] = []
	
	for offset in HexOffsets.DIRECTIONS:
		var axis_positions: Array[Vector2i] = []
		var start_pos = HexOffsets.hex_step(
			self.position, -offset, max_length
		)
		var previous_pos = start_pos
		for offset_step in range(0, max_length * 2 - 1):
			var offsetted_pos = HexOffsets.hex_step(previous_pos, offset)
			previous_pos = offsetted_pos
			axis_positions.append(previous_pos)
		
		positions.append(axis_positions)
	
	return positions
