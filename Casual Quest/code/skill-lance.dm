skill/lance
	var
		icon_state
		damage

		obj/lance = new /obj { icon = 'projectiles.dmi'; layer = 5 }

	New()
		..()
		lance.icon_state = icon_state

	wood
		icon_state = "wood_lance"
		damage = 1

	steel
		icon_state = "lance"
		damage = 2

	// holy crap this is a mess
	Use(mob/M)
		set waitfor = FALSE

		M.icon_state = "attack"
		M.attacking = TRUE

		lance.SetDir(M.dir)

		var thickness = 5
		var length = 16
		var speed = 5

		var dx = (M.dir & 12) && (M.dir & 4 ? 1 : -1)
		var dy = (M.dir &  3) && (M.dir & 1 ? 1 : -1)
		lance.SetLoc(M.loc,
			M.step_x + (dx > 0 && length),
			M.step_y + (dy > 0 && length))

		var ix = -TILE_WIDTH*(dx<0)
		var iy = -TILE_HEIGHT*(dy<0)
		var fx = speed*dx*3 - (dx<0)*TILE_WIDTH
		var fy = speed*dy*3 - (dy<0)*TILE_HEIGHT
		animate(lance, pixel_x = ix, pixel_y = iy, time = world.tick_lag)
		animate(pixel_x = fx, pixel_y = fy, time = 1)
		animate(pixel_x = ix, pixel_y = iy, time = 0.5)

		spawn(2)
			lance.loc = null

			if(M)
				M.attacking = FALSE
				M.icon_state = null

		for(var/t in 0 to 5)
			var dt = 3 - abs(3 - t)
			var px = dx*speed*dt + abs(dy)*(TILE_WIDTH - thickness)/2
			var py = dy*speed*dt + abs(dx)*(TILE_HEIGHT - thickness)/2
			var width = abs(dx)*length + abs(dy)*thickness
			var height = abs(dy)*length + abs(dx)*thickness

			if(dx < 0)
				px -= width
				width -= 1
			else
				px += 1
				width += 1
			if(dy < 0)
				py -= height
				height -= 1
			else
				py += 1
				height += 1

			var hit_exclude[] = list(M, lance)
			var hit[] = bounds(
				lance.Px() + px,
				lance.Py() + py,
				width, height,
				lance.z) - hit_exclude

			for(var/mob/o in hit) Hit(M, o)

			sleep world.tick_lag * (world.fps / 30)

			if(!M) break

	proc
		Hit(mob/A, mob/B) // A hit B with src
			if(istype(A, /player) && istype(B, /player))
				return
			B.TakeDamage(damage, A)