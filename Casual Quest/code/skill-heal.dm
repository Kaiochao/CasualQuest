skill/heal
	energy_cost = 1
	var heal_amount = 1
	var cast_time = 3

	Use(mob/M)
		M.attacking = TRUE
		M.icon_state = "cast"
		spawn(cast_time)
			if(M)
				M.attacking = FALSE
				M.icon_state = null
		var dirs[] = list(5, 6, 9, 10)
		var range = 32
		for(var/dir in dirs)
			var obj/o = new
			o.icon = 'large.dmi'
			o.icon_state = "healing"
			o.layer = 5
			o.bounds = "32,32"
			o.SetCenter(M)
			var dx = range * (dir & EAST ? 1 : -1)
			var dy = range * (dir & NORTH ? 1 : -1)
			animate(o, pixel_x = dx, pixel_y = dy, time = 3)
			spawn(2) o.loc = null
		for(var/mob/m in bounds(M, range))
			Affect(M, m)

	proc
		Affect(mob/A, mob/B)
			if(istype(A, /player) && istype(B, /player))
				B.SetHealth(B.health + 1)
				B.Invincibility(3)