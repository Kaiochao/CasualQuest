mob/player
	Crossed(enemy/E)
		if(!istype(E)) return
		while(E in obounds())
			E.Hit(src)
			sleep world.tick_lag

	Cross(enemy/E)
		if(istype(E)) return TRUE
		return ..()

enemy
	parent_type = /mob
	icon = 'enemies.dmi'
	var damage = 1

	New()
		..()
		add_actor(src)
		dir = pick(1, 2, 4, 8)

	proc/Hit(mob/player/P)
		P.TakeDamage(damage, src)

	Cross(mob/M)
		if(istype(M)) return TRUE
		return ..()

	Crossed(mob/player/P)
		if(!istype(P)) return
		while(P in obounds())
			Hit(P)
			sleep world.tick_lag

	bug
		icon_state = "bug_1"
		health = 1
		speed = 0.5

		Tick()
			Step()

			if(Aligned() && prob(10))
				Turn()

		proc/Turn()
			dir = turn(dir, pick(-90, 90))

		proc/Aligned()
			return !step_x && !step_y

		Bump()
			..()
			Turn()

	bug2
		parent_type = .bug
		icon_state = "bug_2"
		health = 2

mob/player
	Bump(enemy/E)
		if(!istype(E)) return ..()
		TakeDamage(E.damage, E)