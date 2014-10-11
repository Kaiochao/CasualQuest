player
	hazordhu_orc
		icon = '_hazordhu.dmi'
		max_health = 4
		skills = newlist(
			/skill/axe/wood,
			/skill/projectile/arrow/fire
		)

	adventurer
		icon = '_blank.dmi'
		max_health = 4

	knight
		icon = 'knight.dmi'
		max_health = 10
		skills = newlist(
			/skill/sword/steel
		)

	dragoon
		icon = 'dragoon.dmi'
		max_health = 10
		skills = newlist(
			/skill/lance/steel,
			/skill/axe/wood
		)

	priest
		icon = 'acolyte.dmi'
		max_energy = 3
		skills = newlist(
			/skill/sword/wood,
			/skill/heal
		)

	mage
		icon = 'mage.dmi'
		max_energy = 5
		energy_rate = 75
		skills = newlist(
			/skill/sword/wood,
			/skill/projectile/fireball
		)

	archer
		icon = 'archer.dmi'
		skills = newlist(
			/skill/projectile/arrow,
			/skill/sword/wood
		)