#define TILE_WIDTH 16
#define TILE_HEIGHT 16
#define FPS 30
#define DT (30 / FPS)

world
	fps = FPS
	icon_size = 16

	ActionTick()
		..()
		PlayerCollisionTick()

	proc
		PlayerCollisionTick()
			var to_check[0]

			for(var/player/p)
				if(!p.IsInvincible())
					to_check += p

			for(var/player/a in to_check)
				to_check -= a
				var ax = a.Cx(), ay = a.Cy()
				for(var/player/b in to_check)
					var d = -8 - bounds_dist(a, b)
					if(d <= 0) continue
					var a_dir = 0
					var bx = b.Cx(), by = b.Cy()
					if(ax > bx) a_dir |= EAST
					else if(ax < bx) a_dir |= WEST
					if(ay > by) a_dir |= NORTH
					else if(ay < by) a_dir |= SOUTH
					var b_dir = turn(a_dir, 180)
					var half_dist = d / 2
					a.Step(a_dir, half_dist, a.dir)
					b.Step(b_dir, half_dist, b.dir)