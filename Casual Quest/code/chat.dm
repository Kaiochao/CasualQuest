client
	verb/focus(control as text)
		winset(src, null, "[control].focus=true")

	verb/focus_toggle()
		var focus = winget(src, null, "focus")
		if(findtext(focus, "input"))
			winset(src, null, "map.focus=true")
		else
			winset(src, null, "input.focus=true")

	verb/say(t as text)
		t = html_encode(t)
		world << "<b>[key]</b>: [t]"
		focus("map")