class_name HexCell

var position: Vector2i = Vector2i.ZERO
var player_id: int = -1

func _init(pos: Vector2i, _player_id: int) -> void:
	self.position = pos
	self.player_id = _player_id

func test_win_condition(all_cells: Dictionary[Vector2i, HexCell], streak: int = 6):
	for offset in HexOffsets.HEX_NEIGHBOURS:
		var cell_streak: Array[HexCell] = []
		for streak_idx in range(1, streak):
			var offsetted_pos = self.position + (offset * streak_idx)
			var cell_at_offset: HexCell = all_cells.get(offsetted_pos, null)
			if cell_at_offset == null:
				break
			
			if cell_at_offset.player_id != self.player_id:
				break
			
			cell_streak.append(cell_at_offset)
		
		if len(cell_streak) == streak - 1:
			return true
	
	return false
