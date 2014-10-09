skill

	sword
		var icon_state
		var obj/sword = new /obj { layer = 5; icon = 'projectiles.dmi' }
		var damage

		wood
			icon_state = "wood"
			damage = 1

		steel
			icon_state = "sword"
			damage = 2

		proc/Hit(mob/A, mob/B) // A hit B with src
			if(istype(A, /mob/player) && istype(B, /mob/player)) return
			B.TakeDamage(damage, A)

		Use(mob/M)
			set waitfor = FALSE

			M.attacking = TRUE
			M.icon_state = "attack"

			var dx = (M.dir & 12) && (M.dir & EAST ? 1 : -1)
			var dy = (M.dir & 3) && (M.dir & NORTH ? 1 : -1)
			var thickness = 4
			var initial_length = 6
			var delta_length = 5

			sword.Move(M.loc, M.dir, M.step_x + 16*dx, M.step_y + 16*dy)

			animate(sword, icon_state = "[icon_state]_[initial_length]", time = 0)
			var lengths[5]
			for(var/dt in 0 to 4)
				var t = 2 - abs(2 - dt)
				var length = initial_length + t*delta_length
				lengths[dt + 1] = length
				animate(icon_state = "[icon_state]_[length]", time = world.tick_lag)

			for(var/length in lengths)
				if(!M) break
				var width  = dx*length + dy*thickness
				var height = dy*length + dx*thickness
				var px = 17*(dx > 0) + 6*abs(dy)
				var py = 17*(dy > 0) + 6*abs(dx)

				if(dx < 0) px += width  + 1
				if(dy < 0) py += height + 1
				width  = abs(width)
				height = abs(height)

				var hit[] = bounds(M.Px() + px, M.Py() + py, width, height, M.z) - list(sword, M)

				for(var/mob/o in hit) Hit(M, o)

				sleep world.tick_lag

			sword.loc = null

			if(M)
				M.icon_state = null
				M.attacking = FALSE