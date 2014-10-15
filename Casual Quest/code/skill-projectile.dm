skill/projectile
	var
		// the type of projectile to use
		projectile/projectile = /projectile

		// override the icon state of the projectile
		icon_state

		// override the bounds of the projectile
		bounds

		// only one projectile can exist at a time
		single_shot = TRUE

	Use(mob/M)
		if(!single_shot)
			projectile = initial(projectile)
		if(ispath(projectile))
			projectile = new projectile (src)
		projectile.Go(M)

	fireball
		projectile = /projectile/fireball
		energy_cost = 1

		var cast_time = 2

		Use(mob/M)
			..()
			M.attacking = TRUE
			M.icon_state = "cast"
			spawn(cast_time)
				M.attacking = FALSE
				M.icon_state = null

	arrow
		projectile = /projectile/arrow

		fire
			projectile = /projectile/arrow/fire
			energy_cost = 4

	spear
		parent_type = /skill/projectile/arrow
		projectile = /projectile/arrow/spear
		single_shot = FALSE

projectile
	parent_type = /obj
	icon = 'projectiles.dmi'
	layer = FLY_LAYER

	step_size = 5 * DT

	var
		// active on the map or not
		active = FALSE

		// skill that fired this projectile
		skill/projectile/skill

		// source of this projectile
		mob/owner

		// damage dealt
		damage = 1

		// a maximum distance to travel before resetting
		distance

		// the visible part
		obj/img = new

	New(Skill)
		skill = Skill

		img.icon = icon
		img.icon_state = skill.icon_state
		img.layer = layer
		img.pixel_x = 0
		img.pixel_y = 0

	Move()
		. = ..()
		if(!.)
			Stop()
		else
			CollisionCheck()
			DistanceChanged(.)

	proc
		DistanceChanged(D)
			if(!isnull(distance))
				distance -= D
				if(distance <= 0)
					Stop()

		CollisionCheck()
			for(var/mob/m in obounds())
				Hit(m)

		Hit(mob/M)
			if(!owner.IsSameTeam(M))
				if(!(M.shield && M.IsFacing(src)))
					M.TakeDamage(damage, owner)
				Stop()

		Go(mob/M)
			active = TRUE

			owner = M

			if(!isnull(skill.bounds))
				bounds = skill.bounds

			SetDir(M.dir)
			SetCenter(M.Cx(), M.Cy(), M.z)

			if(initial(distance))
				distance = initial(distance) + ((dir & 3) ? bound_height : bound_width)

			Translate(
				(M.dir & 12) && ((M.dir & 4) ? 12 : -12),
				(M.dir &  3) && ((M.dir & 1) ? 12 : -12))

			// Trying out using an animated image for the projectile appearance
			// so they move smoothly client-side.
			animate(img, pixel_x = 0, pixel_y = 0, time = world.tick_lag)

			img.SetLoc(loc, step_x, step_y)
			img.SetDir(dir)

			var d = distance, dx, dy
			if(!d)
				dx = (dir & 12) && (dir & 4 ? map_width() : 0) - img.Cx()
				dy = (dir & 3) && (dir & 1 ? map_height() : 0) - img.Cy()
				d = abs(dx || dy)
			else
				dx = (dir & 12) && (dir & 4 ? distance : -distance)
				dy = (dir & 3) && (dir & 1 ? distance : -distance)
			var t = d / step_size * world.tick_lag

			animate(img, pixel_x = dx, pixel_y = dy, time = t)

			// debug: watch the collider move with the image
			// they should be in roughly the same place
			if(0)
				color = rgb(0, 0, 0, 128)
				layer = 6

			walk(src, dir)

		Stop()
			if(active)
				active = FALSE
				walk(src, 0)
				loc = null
				animate(img)
				img.loc = null

	arrow
		icon_state = "arrow"
		SetDir(D)
			..()
			bound_width = 16
			bound_height = 16
			if(D & 3)
				bound_width = 3
			else
				bound_height = 3

		fire
			icon_state = "arrow_flaming"
			Stop()
				var obj/fire/fire = new
				fire.SetCenter(Cx() + 3*dir2dx[dir], Cy() + 3*dir2dy[dir], z)
				..()
				fire.owner = owner
				fire.SetLife(300)

		spear
			icon_state = "spear"
			step_size = 2 * DT

	fireball
		icon_state = "fire_ball"
		distance = 64
		bounds = "6,6"

obj/fire
	icon = 'enemies.dmi'
	icon_state = "fire_1"

	var
		life
		alive = FALSE
		damage = 2
		mob/owner

	proc
		SetLife(Life)
			life = Life
			if(life && !alive)
				alive = TRUE
				while(alive && life >= 0)
					life -= 1
					for(var/mob/m in obounds())
						if(!owner.IsSameTeam(m))
							m.TakeDamage(damage, owner, src)
					sleep 1
				alive = FALSE
				del src