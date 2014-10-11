mob
	standing = TRUE
	speed = DT

	var
		invincible_time = 3

		health = 5
		max_health = 5

		energy = 0
		max_energy = 0
		energy_rate = 75 // ticks per aura

		tmp
			attacking = FALSE
			invincible = FALSE

	New()
		..()
		add_actor(src)

	proc
		Tick()
			if(!IsInvincible())
				animate(src)

			if(!isnull(energy_rate) && energy < max_energy)
				energy_rate -= DT
				if(energy_rate <= 0)
					energy_rate = initial(energy_rate)
					SetEnergy(energy + 1)


		Knockback(mob/From)
			var dx = Cx() - From.Cx()
			var dy = Cy() - From.Cy()
			if(abs(dx) > abs(dy))
				Step(dx > 0 ? 4 : 8, TILE_WIDTH, dir)
			else
				Step(dy > 0 ? 1 : 2, TILE_HEIGHT, dir)

		SetHealth(Health)
			health = clamp(Health, 0, max_health)

		SetEnergy(Energy)
			energy = clamp(Energy, 0, max_energy)

		TakeDamage(Damage, Cause)
			if(IsInvincible())
				return

			if(Cause)
				Knockback(Cause)

			SetHealth(health - Damage)

			if(health <= 0)
				health = 0
				Die(Cause)

			else
				Invincibility()

		Die(Cause)
			del src

		Invincibility(Time)
			if(isnull(Time)) Time = invincible_time
			invincible = world.time + Time
			animate(src, alpha = 0, time = 1/2, loop = -1)
			animate(alpha = 255, time = 1/2)

		IsInvincible()
			return invincible >= world.time