class_name HexBot
# it is really dumb, don't expect much from it

var AGRESSIVENESS = 1.05
var bot_id: int = 0
var enemy_id: int = 1

func _init(aggressiveness: float, _enemy_id: int = 1, _bot_id: int = 0) -> void:
	self.AGRESSIVENESS = aggressiveness
	self.bot_id = _bot_id
	self.enemy_id = _enemy_id


func make_next_move(all_cells: Dictionary[Vector2i, HexCell], empty_cells: Array[Vector2i], streak_needed: int) -> Vector2i:
	var move_candidates: Array[Dictionary] = []

	for pos in empty_cells:
		var score = 0.0
		score += evaluate_position(pos, all_cells, self.bot_id, streak_needed)
		score += evaluate_position(pos, all_cells, self.enemy_id, streak_needed) * AGRESSIVENESS
		
		move_candidates.append({"pos": pos, "score": score})

	move_candidates.sort_custom(func(a, b): return a.score > b.score)
	if move_candidates[0].score >= 1000000:
		return move_candidates[0].pos

	var top_count = min(3, move_candidates.size())
	var best_moves: Array[Vector2i] = []
	
	for i in range(top_count):
		best_moves.append(move_candidates[i].pos)
		
	return best_moves[0]


func evaluate_position(pos: Vector2i, all_cells: Dictionary[Vector2i, HexCell], p_id: int, streak_needed: int) -> int:
	var total_score = 0
	var axes_to_test = HexCell.get_axis_positions(pos, streak_needed)
	
	for axis in axes_to_test:
		var streak_found = HexCell.get_cell_streak_for_bot(axis, all_cells, p_id)
		if not has_potential(axis, all_cells, p_id, streak_needed):
			continue
			
		var count = streak_found.size()
		total_score += calculate_score_for_count(count + 1, streak_needed)
		
	return total_score

func has_potential(axis: Array, all_cells: Dictionary[Vector2i, HexCell], p_id: int, streak_needed: int) -> bool:
	var possible_slots = 0
	for pos in axis:
		var cell = all_cells.get(pos)
		if cell == null or cell.player_id == p_id:
			possible_slots += 1
	
	return possible_slots >= streak_needed

func calculate_score_for_count(count: int, streak_needed: int) -> int:
	if count >= streak_needed:
		return 1000000
	
	var diff = streak_needed - count
	match diff:
		1: return 50000
		2: return 5000
		3: return 500
		4: return 50
		_: return 5
