proc
	sign(n)
		return n && n / abs(n)

	clamp(n, a, b)
		return min(max(n, a), b)

	get_px_dir(atom/a, atom/b)
		var dx = b.Cx() - a.Cx()
		var dy = b.Cy() - a.Cy()
		return (dx && (dx > 0 ? EAST : WEST)) | (dy && (dy > 0 ? NORTH : SOUTH))

atom
	proc
		IsFacing(atom/O)
			var dir_to = get_px_dir(src, O)
			return dir == dir_to || dir == turn(dir_to, 45) || dir == turn(dir_to, -45)

var
	global
		dir2dx[] = list(0, 0, 0, 1, 1, 1, 0, -1, -1, -1)
		dir2dy[] = list(1, -1, 0, 0, 1, -1, 0, 0, 1, -1)