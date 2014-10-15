player
	parent_type = /mob
	invincible_time = 8

	var tmp
		moving = FALSE

		skills[]

		image
			health_meter = new /image {
				icon = 'meter.dmi'
				icon_state = "16"
				pixel_y = 17
				layer = 10
			}

			energy_meter = new /image {
				icon = 'meter_magic.dmi'
				icon_state = "16"
				pixel_y = 19
				layer = 10
			}

	Cross(atom/movable/M)
		if(istype(M, /player))
			return TRUE
		return ..()

	Tick()
		..()
		if(!attacking && moving)
			Step(moving)
			GridAlign(moving)

	IsSameTeam(player/M)
		return istype(M)

	Die()

	SetHealth()
		..()
		UpdateHealthMeter()

	SetEnergy()
		..()
		UpdateEnergyMeter()

	verb
		move(Dir as num, On as num)
			set hidden = TRUE, instant = TRUE
			if(On)
				moving |= Dir
			else
				moving &= ~Dir

		attack()
			set hidden = TRUE, instant = TRUE
			UseSkill(1)

		skill(N as num)
			set hidden = TRUE, instant = TRUE
			UseSkill(N + 1)

	proc
		UseSkill(N)
			if(attacking) return
			if(skills && skills.len >= N)
				var skill/s = skills[N]
				if(s && SpendEnergy(s.energy_cost))
					s.Use(src)

		SpendEnergy(Energy)
			if(!Energy)
				return TRUE
			if(energy >= Energy)
				energy -= Energy
				UpdateEnergyMeter()
				return TRUE
			return FALSE

		UpdateHealthMeter()
			overlays -= health_meter
			health_meter.icon_state = "[-round(-health / max_health * 16)]"
			overlays += health_meter

		UpdateEnergyMeter()
			overlays -= energy_meter
			if(max_energy)
				energy_meter.icon_state = "[-round(-energy / max_energy * 16)]"
				overlays += energy_meter