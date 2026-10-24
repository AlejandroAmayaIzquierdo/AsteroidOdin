package main

import rl "vendor:raylib"

World :: struct {
	player: Player,
	asteroids: [dynamic]Asteroid
}

make_world :: proc(player_init_pos: rl.Vector2, num_asteroid: int = 10) ->World {
	asteroids := [dynamic]Asteroid{}

	append(&asteroids, make_asteroid({300,200}))

	return World {
		player = Player {
			pos = player_init_pos,
		},
		asteroids = asteroids
	}
}


update_world :: proc(world: ^World) {

	update_player(&world.player)
}

draw_world :: proc(world: ^World) {
	draw_player(&world.player)

	for &asteroid in world.asteroids {
		draw_asteroid(&asteroid)
	}
}
