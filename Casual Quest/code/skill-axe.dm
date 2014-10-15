skill/axe
	var
		icon_state
		damage
		obj/axe = new /obj { icon = 'projectiles.dmi'; layer = 5 }

	New()
		..()
		axe.icon_state = icon_state

	wood
		icon_state = "wood_axe"
		damage = 1

	steel
		icon_state = "axe"
		damage = 2

	gold
		icon_state = "gold_axe"
		damage = 3

	saber
		icon_state = "saber"
		damage = 1

	// i'll do animate() later... maybe...
	Use(mob/M)
		M.attacking = TRUE
		M.icon_state = "attack"

		axe.SetLoc(M.loc, M.step_x, M.step_y)

		var dirs[] = list(turn(M.dir, 45), M.dir, turn(M.dir, -45))
		for(var/d in dirs)
			axe.pixel_x = dir2dx[d] * TILE_WIDTH
			axe.pixel_y = dir2dy[d] * TILE_HEIGHT
			axe.dir = d

			for(var/atom/a in obounds(axe, axe.pixel_x, axe.pixel_y) - M)
				Hit(M, a)

			if(d & d - 1)
				axe.pixel_x -= dir2dx[d] * sqrt(2)*2
				axe.pixel_y -= dir2dy[d] * sqrt(2)*2

			sleep 1
			if(!M) break

		axe.loc = null

		if(M)
			M.attacking = FALSE
			M.icon_state = ""

	proc
		Hit(mob/A, atom/B)
			if(istype(B, /enemy))
				var enemy/e = B
				e.TakeDamage(damage, A)