package main

import "core:fmt"
import "core:math"
import rl "vendor:raylib"

PLAYER_SIZE :: 30
ACELERATION_POWER :: 200
ACELERATION_DRAG :: 0.9
ROT_SPEED :: 350
MAX_SPEED :: 200

Player :: struct {
	pos: rl.Vector2,
	aceleration: rl.Vector2,
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

	angle : f32 = player.rot * (math.PI / 180.0) // Angulo en radianes
  	player_direction := rl.Vector2 {math.cos(angle),math.sin(angle)}
   	aceleration_mod := math.sqrt(math.pow(player.aceleration.x,2) + math.pow(player.aceleration.y,2))

	// Movement
	if rl.IsKeyDown(.W) {
		if aceleration_mod < MAX_SPEED {
			player.aceleration += player_direction * ACELERATION_POWER * rl.GetFrameTime()
		} else {
			player.aceleration += player_direction * rl.GetFrameTime()
		}
	} else {
		if aceleration_mod > 0 {
			player.aceleration -= player.aceleration * ACELERATION_DRAG * rl.GetFrameTime()
		}
	}


	// fmt.printfln("Aceleration: %v, Aceleration Mod: %f",player.aceleration, aceleration_mod)





	// Rotation
	if (rl.IsKeyDown(.A)) {
		player.vel_rot = -ROT_SPEED
	}
	else if (rl.IsKeyDown(.D)) {
		player.vel_rot = ROT_SPEED
	}else {
		player.vel_rot = 0;
	}

	player.rot += player.vel_rot * rl.GetFrameTime()

	player.pos += player.aceleration * rl.GetFrameTime()

	//fmt.printfln("Player dir: %v, aceleration: %f",player_direction,player.aceleration)
}


draw_player :: proc (player: ^Player) {
	triangles_player := get_player_tri(player)
	rl.DrawCircleV(player.pos,2,rl.WHITE)
	rl.DrawTriangleLines(triangles_player[0],triangles_player[1],triangles_player[2],rl.WHITE)
}
