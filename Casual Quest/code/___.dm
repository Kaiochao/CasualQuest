#define TILE_WIDTH 16
#define TILE_HEIGHT 16

world
	fps = 30
	icon_size = 16
	mob = /mob/player

	New()
		..()
		add_actor(src)

	proc/Tick()
		var players[0]
		for(var/mob/player/p) players += p
		for(var/mob/player/a in players)
			players -= a
			var ax = a.Cx(), ay = a.Cy()
			for(var/mob/player/b in players)
				var d = -8 - bounds_dist(a, b)
				if(d <= 0) continue
				var a_dir = 0
				var bx = b.Cx(), by = b.Cy()
				if(ax > bx) a_dir |= EAST
				else if(ax < bx) a_dir |= WEST
				if(ay > by) a_dir |= NORTH
				else if(ay < by) a_dir |= SOUTH
				var b_dir = turn(a_dir, 180)
				var half_dist = d / 2
				a.Step(a_dir, half_dist, a.dir)
				b.Step(b_dir, half_dist, b.dir)

proc/sign(n) return n && n / abs(n)

client
	Move()

	New()
		. = ..()
		world << "<i>[key] connected</i>"

	Del()
		world << "<i>[key] disconnected</i>"
		..()

atom
	movable
		var speed = 0

		proc/Step(Dir, Dist, EndDir)
			if(isnull(Dir)) Dir = dir
			if(isnull(Dist)) Dist = speed
			if(!Dist) return
			if(Dir & SOUTH) Translate(0, 	-Dist,	EndDir || SOUTH)
			if(Dir & WEST)  Translate(-Dist, 0, 	EndDir || WEST)
			if(Dir & NORTH) Translate(0, 	 Dist,	EndDir || NORTH)
			if(Dir & EAST)  Translate(Dist,  0, 	EndDir || EAST)

skill
	proc/Use(mob/M)


mob
	var tmp/attacking = FALSE
	var tmp/invincible = FALSE

	var health = 5
	var energy = 0

	speed = 1

	standing = TRUE

	proc/Tick()

	proc/Knockback(mob/From)
		var dx = Cx() - From.Cx()
		var dy = Cy() - From.Cy()
		if(abs(dx) > abs(dy))
			Step(dx > 0 ? EAST : WEST, TILE_WIDTH, dir)
		else Step(dy > 0 ? NORTH : SOUTH, TILE_HEIGHT, dir)

	proc/TakeDamage(Damage, Cause)
		if(invincible) return

		if(Cause)
			Knockback(Cause)

		health -= Damage

		if(health <= 0)
			health = 0
			Die(Cause)

		else
			invincible = TRUE
			animate(src, alpha = 0, time = world.tick_lag, loop = -1)
			animate(alpha = 255, time = world.tick_lag)
			spawn(5 * world.tick_lag)
				animate(src)
				invincible = FALSE

	proc/Die(Cause)
		del src

	spectator

	player
		icon = 'rsc/classes/_blank.dmi'

		var skills[] = newlist(
			/skill/sword,
			/skill/arrow
		)

		Cross(atom/movable/M)
			if(istype(M, /mob/player)) return TRUE
			return ..()

		Login()
			..()
			add_actor(src)

		var tmp/moving = FALSE

		verb/move(Dir as num, On as num)
			set hidden = TRUE, instant = TRUE
			if(On) moving |= Dir
			else moving &= ~Dir

		proc/UseSkill(N)
			if(attacking) return
			if(skills && skills.len >= N)
				var skill/s = skills[N]
				if(s) s.Use(src)

		verb/attack()
			set hidden = TRUE, instant = TRUE
			UseSkill(1)

		verb/skill(N as num)
			set hidden = TRUE, instant = TRUE
			UseSkill(N + 1)

		Tick()
			if(!attacking && moving)
				Step(moving)
				GridAlign()

		proc/GridAlign()
			if(!(moving & 12))
				var cx = Cx()
				var rx = round(cx, 8)
				var ux = sign(rx - cx) * min(speed, abs(rx - cx))
				if(ux) Translate(ux, 0, dir)

			if(!(moving & 3))
				var cy = Cy()
				var ry = round(cy, 8)
				var uy = sign(ry - cy) * min(speed, abs(ry - cy))
				if(uy) Translate(0, uy, dir)

tile
	parent_type = /turf

	floor

	wall
		density = TRUE