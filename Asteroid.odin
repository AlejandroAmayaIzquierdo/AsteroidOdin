package main

import "core:math"
import rl "vendor:raylib"
import rand "core:math/rand"
import time "core:time"

NUM_OF_POINTS :: 10

Asteroid :: struct {
	pos: rl.Vector2,
	min_radius: int,
	max_radius: int,
	seed: i64,
	color : rl.Color,
}

make_asteroid :: proc(pos: rl.Vector2, min_radius := 30, max_radius := 50) ->
Asteroid {
	new_asteroid := Asteroid {
		pos = pos,
		min_radius = min_radius,
		max_radius = max_radius,
		seed = time.now()._nsec,
		color = rl.WHITE,
	}
	return new_asteroid;
}

get_poly :: proc (asteroid: ^Asteroid) -> [NUM_OF_POINTS]rl.Vector2 {
	rot_between_points : f32 = 360.0 / NUM_OF_POINTS
	rot : f32 = 0.0

	points := [NUM_OF_POINTS]rl.Vector2{}

	rand.reset_u64(cast(u64)asteroid.seed)

	index := 0

	for rot <= 360.0 {
		angle := rot * (math.PI / 180.0)

		direction_point := rl.Vector2 {math.cos(angle),math.sin(angle)}

		if index < NUM_OF_POINTS {
			points[index] = asteroid.pos + direction_point * cast(f32)rand.int_range(asteroid.min_radius,asteroid.max_radius)
		}


		rot += rot_between_points

		index += 1
	}
	return points
}


update_asteroid :: proc (asteroid: ^Asteroid) {

}

draw_asteroid :: proc (asteroid: ^Asteroid) {
	polygon := get_poly(asteroid)

	for i := 0 ; i < len(polygon); i += 1 {
		current_point := polygon[i]

		next_point := i + 1 < len(polygon) ? polygon[i + 1] : polygon[0]

		rl.DrawLineV(current_point,next_point,asteroid.color)
	}
}
