skill
	projectile
		var projectile/projectile = /projectile
		var icon_state
		var bounds

		Use(mob/M)
			if(ispath(projectile)) projectile = new projectile (src)
			projectile.Go(M)

		fireball
			projectile = /projectile/fireball
			icon_state = "fire_ball"
			bounds = "6,6"

		arrow
			projectile = /projectile/arrow
			icon_state = "arrow"

projectile
	parent_type = /obj
	icon = 'projectiles.dmi'
	layer = FLY_LAYER

	step_size = 4

	var damage = 1
	var distance
	var obj/img = new
	var mob/owner
	var skill/projectile/skill

	New(Skill) skill = Skill

	proc/Crossing(atom/movable/A)
	proc/Hit(mob/M)
	proc/SetDir(D) dir = D

	proc/Go(mob/M)
		owner = M

		icon_state = skill.icon_state

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
		img.SetLoc(loc, step_x, step_y)
		img.dir = dir
		img.icon = icon
		img.icon_state = icon_state
		img.layer = layer
		img.pixel_x = 0
		img.pixel_y = 0
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

		else
			icon_state = null


		walk(src, dir)

	proc/Stop()
		walk(src, 0)
		loc = null
		animate(img)
		img.loc = null

	arrow/SetDir(D)
		..()
		bound_width = 16
		bound_height = 16
		if(D & 3) bound_width = 3
		else bound_height = 3

	fireball/distance = 64

	Move()
		. = ..()
		if(distance) distance -= .
		if(!. || !isnull(distance) && distance <= 0) Stop()
		else for(var/mob/m in obounds()) Hit(m)

	Hit(mob/M)
		if(istype(M, /mob/player)) return
		M.TakeDamage(damage, owner)
		Stop()

atom/Entered(projectile/P)
	if(istype(P)) P.Crossing(src)
	..()

atom/movable/Crossed(projectile/P)
	if(istype(P)) P.Crossing(src)
	..()