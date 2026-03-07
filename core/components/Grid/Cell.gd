class_name HexCell

var position: Vector2i = Vector2i.ZERO
var player_id: int = -1

func _init(pos: Vector2i, _player_id: int) -> void:
	self.position = pos
	self.player_id = _player_id

func test_win_condition(all_cells: Dictionary[Vector2i, HexCell], streak: int = 6):
	for axis in HexOffsets.AXIS:
		var cell_streak: Array[HexCell] = []
		for offset in axis:
			var previous_pos: Vector2i = self.position
			for streak_idx in range(1, streak):
				var fixed_offset: Vector2i = offset
				if offset.y != 0:
					var cancel_x_offset = int(previous_pos.y % 2 == 0)
					fixed_offset.x = offset.x - cancel_x_offset if offset.x > 0 else -cancel_x_offset
				
				var offsetted_pos = previous_pos + fixed_offset
				var cell_at_offset = all_cells.get(offsetted_pos, null)
				if cell_at_offset == null:
					break
				
				if cell_at_offset.player_id != self.player_id:
					break
				
				previous_pos = offsetted_pos
				cell_streak.append(cell_at_offset)
			
			if len(cell_streak) == streak - 1:
				return true
		
		return false
