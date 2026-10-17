package main

import "core:fmt"
import "core:math"
import rl "vendor:raylib"

PLAYER_SIZE :: 30
PLAYER_SPEED :: 300

Player :: struct {
	pos: rl.Vector2,
	vel: rl.Vector2,
	rot: f32,
	vel_rot: f32,
}

get_player_tri :: proc(player: ^Player) -> [3]rl.Vector2 {
	points := [3]rl.Vector2{}

	for i in 0..<3 {
		current_point_rot := player.rot + (120.0 * cast(f32)i)
		angle : f32 = current_point_rot * (math.PI / 180.0) // Angulo en radianes

		direction_point := rl.Vector2 {math.cos(angle), math.sin(angle)}
		points[i] = player.pos + direction_point * PLAYER_SIZE
	}
	return points
}

update_player :: proc(player: ^Player) {

	// Movement
	if rl.IsKeyDown(.W) {
		angle : f32 = player.rot * (math.PI / 180.0) // Angulo en radianes

		directionV := rl.Vector2 {math.cos(angle),math.sin(angle)}
		player.vel = directionV * PLAYER_SPEED
	} else {
		player.vel = {0,0}
	}

	// Rotation
	if (rl.IsKeyDown(.A)) {
		player.vel_rot = -PLAYER_SPEED
	}
	else if (rl.IsKeyDown(.D)) {
		player.vel_rot = PLAYER_SPEED
	}else {
		player.vel_rot = 0;
	}

	player.rot += player.vel_rot * rl.GetFrameTime()
	player.pos += player.vel * rl.GetFrameTime()
}


draw_player :: proc (player: ^Player) {
	triangles_player := get_player_tri(player)
	rl.DrawTriangleLines(triangles_player[0],triangles_player[1],triangles_player[2],rl.WHITE)
}
