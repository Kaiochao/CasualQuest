player/Cross(enemy/E) return istype(E) || ..()

enemy
	parent_type = /mob
	icon = 'enemies.dmi'
	var damage = 1

	New()
		..()
		add_actor(src)
		SetDir(pick(1, 2, 4, 8))

	proc/Hit(player/P)
		P.TakeDamage(damage, src)

	Cross(mob/M)
		return istype(M) || ..()

	bug
		icon_state = "bug_1"
		health = 1
		speed = 0.5 * DT

		Tick()
			..()

			Step()
			GridAlign(dir)

			for(var/player/p in obounds())
				Hit(p)

			if(prob(1))
				Turn()

		proc/Turn()
			SetDir(turn(dir, pick(-90, 90)))

		Bump()
			..()
			Turn()

	bug2
		parent_type = .bug
		icon_state = "bug_2"
		health = 2