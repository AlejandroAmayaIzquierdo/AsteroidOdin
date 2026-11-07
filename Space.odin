package main

import "core:fmt"
import "core:math/rand"
import rl "vendor:raylib"

SPACE_EXTRA_LIMIT :: 40

Space :: struct {
	player: Player,
	asteroids: [dynamic]Asteroid,
	demo: bool,
	score: int,
	last_asteroids: int
}

make_space_map :: proc(player_init_pos: rl.Vector2, num_asteroid: int = 5) ->Space {
	asteroids := [dynamic]Asteroid{}

	for  i in 0..<num_asteroid {
		asteroid_init_pos : rl.Vector2 = {rand.float32_range(0,WINDOW_HEIGHT),rand.float32_range(0,WINDOW_WIDTH/2)}
		append(&asteroids, make_leveled_asteroid(asteroid_init_pos,3))
	}

	return Space {
		player = Player {
			pos = player_init_pos,
			life = PLAYER_DEFAULT_LIFE,
			invulnerability = PLAYER_INVULNERABILITY_TIME
		},
		asteroids = asteroids,
		demo = false,
		score = 0,
		last_asteroids = num_asteroid
	}
}

make_noplayer_map :: proc(num_asteroid: int = 10) -> Space {
	space := make_space_map({0,0},num_asteroid)
	space.demo = true

	destroy_player(&space.player)

	return space
}

respawn_asteroids :: proc(space: ^Space, num_asteroid: int = 5) {
	asteroids := [dynamic]Asteroid{}

	for  i in 0..<num_asteroid {
		asteroid_init_pos : rl.Vector2 = {rand.float32_range(0,WINDOW_HEIGHT),rand.float32_range(0,WINDOW_WIDTH/2)}
		append(&asteroids, make_leveled_asteroid(asteroid_init_pos,3))
	}

	space.asteroids = asteroids
	space.last_asteroids = num_asteroid
}

destroy_space :: proc(space: ^Space) {
	delete(space.asteroids)
	space.asteroids = nil
	space.score = 0

	destroy_player(&space.player)
}


update_space :: proc(space: ^Space) {

	update_player(&space.player)

	for &asteroid,i in space.asteroids {
		update_asteroid(&asteroid)
	}

	// Check player collision with asteroids
	if check_player_collisions(space) {
		if space.player.life == 0 {
			destroy_player(&space.player)
			return
		}
		respawn_player(&space.player)
	}

	// Check proyectiles collisions with asteroids
	for &asteroid,i in space.asteroids {

		if (&space.player == nil) {
			continue
		}

		if &space.player.proyectiles == nil {
			continue
		}

		poly : [NUM_OF_POINTS]rl.Vector2 = get_poly(&asteroid)

		for &proyectile,j in space.player.proyectiles {

			// Asteroid destroy
			if rl.CheckCollisionPointPoly(proyectile.pos,raw_data(poly[:NUM_OF_POINTS]),NUM_OF_POINTS) {

				switch {
				case asteroid.level >= 3:
					space.score += 10
				case asteroid.level == 2:
					space.score += 50
				case asteroid.level <= 1:
					space.score += 100
				}

				if (asteroid.level > 1) {
					append(&space.asteroids, make_leveled_asteroid(asteroid.pos,asteroid.level - 1))
					append(&space.asteroids, make_leveled_asteroid(asteroid.pos,asteroid.level - 1))
				}

				ordered_remove(&space.asteroids,i)

				ordered_remove(&space.player.proyectiles,j)
			}
		}
	}

	if len(space.asteroids) == 0 {
		respawn_asteroids(space,space.last_asteroids + 1)
	}

}

draw_space :: proc(space: ^Space) {
	draw_player(&space.player)

	for &asteroid in space.asteroids {
		draw_asteroid(&asteroid)
	}
}


check_player_collisions :: proc(space: ^Space) -> bool {

	if (&space.player == nil) {
		return false
	}

	if space.player.invulnerability > 0 {
		return false
	}

	lines_player := get_player_lines(&space.player)
	for &asteroid in space.asteroids {
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
