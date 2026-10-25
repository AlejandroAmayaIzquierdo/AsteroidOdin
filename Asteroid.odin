package main

import "core:math"
import rl "vendor:raylib"
import rand "core:math/rand"
import time "core:time"

Asteroid :: struct {
	pos: rl.Vector2,
	num_of_points : i32,
	min_radius: int,
	max_radius: int,
	seed: i64,
	color : rl.Color
}

make_asteroid :: proc(pos: rl.Vector2, num_of_points : i32= 20, min_radius := 30, max_radius := 50) ->
Asteroid {
	return Asteroid {
		pos = pos,
		num_of_points = num_of_points,
		min_radius = min_radius,
		max_radius = max_radius,
		seed = time.now()._nsec,
		color = rl.WHITE
	}
}

get_poly :: proc (asteroid: ^Asteroid) -> [dynamic]rl.Vector2 {
	rot_between_points := 360.0 / cast(f32)asteroid.num_of_points
	rot : f32 = 0.0

	points := [dynamic]rl.Vector2{}

	rand.reset_u64(cast(u64)asteroid.seed)

	for rot <= 360.0 {
		angle := rot * (math.PI / 180.0)

		direction_point := rl.Vector2 {math.cos(angle),math.sin(angle)}

		append(&points, asteroid.pos + direction_point * cast(f32)rand.int_range(asteroid.min_radius,asteroid.max_radius))

		rot += rot_between_points
	}
	return points
}


update_asteroid :: proc (asteroid: ^Asteroid) {

}

draw_asteroid :: proc (asteroid: ^Asteroid) {
	poly_points := get_poly(asteroid)
	defer delete(poly_points)

	for i := 0 ; i < len(poly_points); i += 1 {
		current_point := poly_points[i]

		next_point := i + 1 < len(poly_points) ? poly_points[i + 1] : poly_points[0]

		rl.DrawLineV(current_point,next_point,asteroid.color)
	}
}
