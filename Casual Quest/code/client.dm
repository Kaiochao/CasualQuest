client
	Move()

	New()
	//	if(connection != "web") return

		world.mob = /spectator
		. = ..()

		world << "<i>[key] connected</i>"

	Del()
		world << "<i>[key] disconnected</i>"
		..()