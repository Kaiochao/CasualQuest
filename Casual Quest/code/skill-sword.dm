skill/sword
	var
		// icon state of the appearance
		icon_state

		// damage inflicted on mobs hit
		damage

		// appearance of the thing
		obj/img = new /obj { layer = 5; icon = 'projectiles.dmi' }

	wood
		icon_state = "wood"
		damage = 1

	steel
		icon_state = "sword"
		damage = 2

	// this is a mess...
	Use(mob/M)
		set waitfor = FALSE

		M.attacking = TRUE
		M.icon_state = "attack"

		var
			dx = (M.dir & 12) && (M.dir & EAST ? 1 : -1)
			dy = (M.dir & 3) && (M.dir & NORTH ? 1 : -1)

			thickness = 4

			width; height

			px; py

			initial_length = 6
			delta_length = 5
			length; lengths[5]

			t; dt

			mob/o

			hit[]
			hit_exclude[] = list(img, M)

		img.SetLoc(M.loc, M.step_x + 16*dx, M.step_y + 16*dy)
		img.SetDir(M.dir)

		animate(img, icon_state = "[icon_state]_[initial_length]", time = 0)

		for(dt in 0 to lengths.len - 1)
			t = 2 - abs(2 - dt)
			length = initial_length + t*delta_length
			lengths[dt + 1] = length
			animate(icon_state = "[icon_state]_[length]", time = world.tick_lag / DT)

		for(length in lengths)
			if(!M) break
			width  = dx*length + dy*thickness
			height = dy*length + dx*thickness
			px = 17*(dx > 0) + 6*abs(dy)
			py = 17*(dy > 0) + 6*abs(dx)

			if(dx < 0) px += width  + 1
			if(dy < 0) py += height + 1
			width  = abs(width)
			height = abs(height)

			hit = bounds(M.Px() + px, M.Py() + py, width, height, M.z) - hit_exclude

			for(o in hit)
				Hit(M, o)

			sleep world.tick_lag / DT

		img.loc = null

		if(M)
			M.icon_state = null
			M.attacking = FALSE

	proc
		Hit(mob/A, mob/B) // A hit B with src
			if(istype(A, /player) && istype(B, /player))
				return
			B.TakeDamage(damage, A)