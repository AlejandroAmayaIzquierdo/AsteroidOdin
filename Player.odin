package main

import "core:fmt"
import "core:math"
import rl "vendor:raylib"

PLAYER_SIZE :: 30
PLAYER_ACELERATION :: 200
PLAYER_DRAG_SPEED :: 100
PLAYER_MAX_SPEED :: 350

Player :: struct {
	pos: rl.Vector2,
	speed: f32,
	vel: rl.Vector2,
	rot: f32,
	vel_rot: f32,
}

get_player_tri :: proc(player: ^Player) -> [3]rl.Vector2 {
	points := [3]rl.Vector2{}

	angles := [3]f32{0,150,210}

	for i in 0..<3 {
		current_point_rot := player.rot + angles[i]
		angle : f32 = current_point_rot * (math.PI / 180.0) // Angulo en radianes

		direction_point := rl.Vector2 {math.cos(angle), math.sin(angle)}
		points[i] = player.pos + direction_point * PLAYER_SIZE
	}
	return points
}

update_player :: proc(player: ^Player) {

	// Movement
	if rl.IsKeyDown(.W) {
		if (player.speed < PLAYER_MAX_SPEED) {
			player.speed += PLAYER_ACELERATION * rl.GetFrameTime()
		}
		angle : f32 = player.rot * (math.PI / 180.0) // Angulo en radianes
		directionV := rl.Vector2 {math.cos(angle),math.sin(angle)}
		player.vel = directionV * cast(f32)player.speed
	} else {
		player.speed -= PLAYER_DRAG_SPEED * rl.GetFrameTime()

		if (player.speed < 0) {
			player.speed = 0
		}
	}

	fmt.printfln("Player speed: %v",player.speed)

	// Rotation
	if (rl.IsKeyDown(.A)) {
		player.vel_rot = -PLAYER_MAX_SPEED
	}
	else if (rl.IsKeyDown(.D)) {
		player.vel_rot = PLAYER_MAX_SPEED
	}else {
		player.vel_rot = 0;
	}

	player.rot += player.vel_rot * rl.GetFrameTime()



	player.pos += player.vel * rl.GetFrameTime()
}


draw_player :: proc (player: ^Player) {
	triangles_player := get_player_tri(player)
	rl.DrawCircleV(player.pos,2,rl.WHITE)
	rl.DrawTriangleLines(triangles_player[0],triangles_player[1],triangles_player[2],rl.WHITE)
}
