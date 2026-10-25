package main

import rl "vendor:raylib"

Space :: struct {
	player: Player,
	asteroids: [dynamic]Asteroid
}

make_space_map :: proc(player_init_pos: rl.Vector2, num_asteroid: int = 10) ->Space {
	asteroids := [dynamic]Asteroid{}

	append(&asteroids, make_asteroid({300,200}))

	append(&asteroids, make_asteroid({500,300},10,20))

	return Space {
		player = Player {
			pos = player_init_pos,
		},
		asteroids = asteroids
	}
}

destroy_space :: proc(space: ^Space) {
	delete(space.asteroids)
	space.asteroids = nil

	destroy_player(&space.player)
}


update_space :: proc(space: ^Space) {

	update_player(&space.player)

	lines_player := get_player_lines(&space.player)

	for &asteroid in space.asteroids {
		update_asteroid(&asteroid)

		poly_points := get_poly(&asteroid)

		for i := 0 ; i < len(poly_points); i += 1 {
			current_point := poly_points[i]
			next_point := i + 1 < len(poly_points) ? poly_points[i + 1] : poly_points[0]

			for j in lines_player {
				collision_point : rl.Vector2
				if (rl.CheckCollisionLines(current_point,next_point,j[0],j[1],&collision_point)) {
					destroy_player(&space.player)
				}
			}
		}
	}

}

draw_space :: proc(space: ^Space) {
	draw_player(&space.player)

	for &asteroid in space.asteroids {
		draw_asteroid(&asteroid)
	}
}
