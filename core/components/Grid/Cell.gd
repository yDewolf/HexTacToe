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
				continue
			
			cell_streak.append(cell_at_offset)
			
			if len(cell_streak) == streak - 1:
				return cell_streak
	
	return []


func get_axis_positions(max_length: int = 6) -> Array[Array]:
	var positions: Array[Array] = []

	for axis in HexOffsets.AXIS:
		var axis_positions: Array[Vector2i] = []
		for offset in axis:
			var previous_pos: Vector2i = self.position
		
			for streak_idx in range(1, max_length):
				var fixed_offset: Vector2i = offset
				if offset.y != 0:
					var cancel_x_offset = int(previous_pos.y % 2 == 0)
					fixed_offset.x = offset.x - cancel_x_offset if offset.x > 0 else -cancel_x_offset
				
				var offsetted_pos = previous_pos + fixed_offset
				axis_positions.append(offsetted_pos)
				previous_pos = offsetted_pos
		
		positions.append(axis_positions)
	
	return positions
