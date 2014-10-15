player
	Cross(enemy/E)
		return istype(E) || ..()

enemy
	parent_type = /mob
	icon = 'enemies.dmi'

	var
		damage = 1

	New()
		..()
		add_actor(src)
		SetDir(pick(1, 2, 4, 8))

	Cross(mob/M)
		return istype(M) || ..()

	IsSameTeam(enemy/M)
		return istype(M)

	proc
		Hit(player/P)
			P.TakeDamage(damage, src)

	bug
		icon_state = "bug_1"
		max_health = 1
		speed = 0.5 * DT

		Tick()
			..()

			Step()
			GridAlign(dir)

			for(var/player/p in obounds())
				Hit(p)

			if(prob(1))
				Turn()

		proc
			Turn()
				SetDir(turn(dir, pick(-90, 90)))

		Bump()
			..()
			Turn()

	bug2
		parent_type = .bug
		icon_state = "bug_2"
		max_health = 2

	boar
		parent_type = .bug
		icon_state = "boar_1"
		max_health = 3

		var
			skill/projectile/spear/spear = new

		Tick()
			..()
			if(prob(2))
				Shoot()

		Die()
			for(var/projectile/arrow/spear/s)
				if(s.owner == src)
					del s
			..()

		proc
			Shoot()
				spear.Use(src)
