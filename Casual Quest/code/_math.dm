proc
	sign(n)
		return n && n / abs(n)

	clamp(n, a, b)
		return min(max(n, a), b)

var
	global
		dir2dx[] = list(0, 0, 0, 1, 1, 1, 0, -1, -1, -1)
		dir2dy[] = list(1, -1, 0, 0, 1, -1, 0, 0, 1, -1)