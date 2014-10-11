spectator
	parent_type = /mob

	Login()
		var classes[0]
		for(var/class in typesof(/player) - /player)
			var player/p = class
			classes[initial(p.name)] = class
		var class = classes[input(src, "Which class would you like to play as?", "Class Selection") in classes]
		if(ispath(class))
			var player/p = new class
			p.key = key
			p.name = name
			p.gender = gender