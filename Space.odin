package main

import "core:math/rand"
import rl "vendor:raylib"

SPACE_EXTRA_LIMIT :: 30

Space :: struct {
	player: Player,
	asteroids: [dynamic]Asteroid
}

make_space_map :: proc(player_init_pos: rl.Vector2, num_asteroid: int = 5) ->Space {
	asteroids := [dynamic]Asteroid{}


	for  i in 0..<num_asteroid {
		asteroid_init_pos : rl.Vector2 = {rand.float32_range(0,WINDOW_HEIGHT),rand.float32_range(0,WINDOW_WIDTH/2)}
		append(&asteroids, make_asteroid(asteroid_init_pos))
		//append(&asteroids, make_asteroid({500,300},10,20))
	}



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

	// Check player collision with asteroids
	if check_player_collisions(space) {
		destroy_player(&space.player)
	}

	// Check proyectiles collisions with asteroids
	for &asteroid,i in space.asteroids {
		poly : [NUM_OF_POINTS]rl.Vector2 = get_poly(&asteroid)
		for &proyectile,j in space.player.proyectiles {
			if rl.CheckCollisionPointPoly(proyectile.pos,raw_data(poly[:NUM_OF_POINTS]),NUM_OF_POINTS) {
				ordered_remove(&space.asteroids,i)
				ordered_remove(&space.player.proyectiles,j)
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


check_player_collisions :: proc(space: ^Space) -> bool {
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
					return true;
				}
			}
		}
	}
	return false;
}


handle_out_of_bound :: proc (pos: ^rl.Vector2) {
	if (pos.x < -SPACE_EXTRA_LIMIT) {
		pos.x = WINDOW_WIDTH + SPACE_EXTRA_LIMIT
	} else if (pos.x > WINDOW_WIDTH + SPACE_EXTRA_LIMIT) {
		pos.x = -SPACE_EXTRA_LIMIT
	}
	if (pos.y < -SPACE_EXTRA_LIMIT) {
		pos.y = WINDOW_HEIGHT + SPACE_EXTRA_LIMIT
	} else if (pos.y > WINDOW_HEIGHT + SPACE_EXTRA_LIMIT) {
		pos.y = -SPACE_EXTRA_LIMIT
	}
}
