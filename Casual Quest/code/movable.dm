atom
	movable
		var
			speed = 0

		proc
			SetDir(D)
				dir = D

			Step(Dir, Dist, EndDir)
				Dir = Dir || dir
				Dist = Dist || speed
				if(!Dist) return
				if(Dir & SOUTH) Translate(0, 	-Dist,	EndDir || SOUTH)
				if(Dir & WEST)  Translate(-Dist, 0, 	EndDir || WEST)
				if(Dir & NORTH) Translate(0, 	 Dist,	EndDir || NORTH)
				if(Dir & EAST)  Translate(Dist,  0, 	EndDir || EAST)

			GridAlign(Moving)
				if(!(Moving & 12))
					var cx = Cx()
					var rx = round(cx, 8)
					var ux = sign(rx - cx) * min(speed, abs(rx - cx))
					if(ux) Translate(ux, 0, dir)

				if(!(Moving & 3))
					var cy = Cy()
					var ry = round(cy, 8)
					var uy = sign(ry - cy) * min(speed, abs(ry - cy))
					if(uy) Translate(0, uy, dir)