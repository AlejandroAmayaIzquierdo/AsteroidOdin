package main

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
}

draw_space :: proc(space: ^Space) {
	draw_player(&space.player)

	for &asteroid in space.asteroids {
		draw_asteroid(&asteroid)
	}
}
