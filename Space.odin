package main

import "core:fmt"
import rl "vendor:raylib"

Space :: struct {
	player: Player,
	asteroids: [dynamic]Asteroid
}

make_space_map :: proc(player_init_pos: rl.Vector2, num_asteroid: int = 10) ->Space {
	asteroids := [dynamic]Asteroid{}

	append(&asteroids, make_asteroid({300,200}))

	return Space {
		player = Player {
			pos = player_init_pos,
		},
		asteroids = asteroids
	}
}


update_space :: proc(space: ^Space) {

	update_player(&space.player)

	for &asteroid in space.asteroids {
		update_asteroid(&asteroid)

		poly := get_poly(&asteroid)
		defer delete(poly)


		point := space.player.pos
		num_points := asteroid.num_of_points



		if (rl.CheckCollisionPointPoly(point,raw_data(poly),num_points)) {
			// fmt.println("Hay colision entre jugador y un asteroide")
			asteroid.color = rl.RED
		}else {
			asteroid.color = rl.WHITE
		}

	}

}

draw_space :: proc(space: ^Space) {
	draw_player(&space.player)

	for &asteroid in space.asteroids {
		draw_asteroid(&asteroid)
	}
}
