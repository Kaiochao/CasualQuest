enemy
	parent_type = /mob
	icon = 'enemies.dmi'
	var damage = 1

	New()
		..()
		add_actor(src)
		dir = pick(1, 2, 4, 8)

	Bump(mob/player/P)
		if(!istype(P)) return ..()
		P.TakeDamage(damage, src)

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