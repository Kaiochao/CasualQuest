skill
	arrow
		var icon_state = "arrow"

		var projectile/arrow/arrow = new

		Use(mob/M)
			arrow.owner = M
			arrow.icon_state = icon_state
			arrow.SetDir(M.dir)
			arrow.SetCenter(M.Cx(), M.Cy(), M.z)
			arrow.Translate((M.dir & 12) && ((M.dir & 4) ? 12 : -12), (M.dir &  3) && ((M.dir & 1) ? 12 : -12))
			walk(arrow, M.dir)

projectile
	parent_type = /obj
	icon = 'projectiles.dmi'
	layer = FLY_LAYER

	var damage = 1

	var mob/owner

	proc/Crossing(atom/movable/A)

	proc/Hit(mob/M)

	arrow
		step_size = 4

		proc/SetDir(D)
			dir = D
			bound_width = 16
			bound_height = 16
			if(D & 3) bound_width = 3
			else bound_height = 3

		proc/Stop()
			walk(src, 0)
			loc = null

		Move()
			. = ..()
			if(!.) Stop()
			else for(var/mob/m in obounds())
				Hit(m)
		/*
		Crossing(mob/M)
			if(!istype(M)) return ..()
			Hit(M)
		*/
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