package main

import "core:fmt"
import "core:math"
import rl "vendor:raylib"

PLAYER_SIZE :: 100
PLAYER_ROTATION_ACELERATION :: 300
PLAYER_ROTARION_DRAG :: 500
PLAYER_ROTATION_SPEED :: 300

Player :: struct {
	pos: rl.Vector2,
	vel: rl.Vector2,
	rot: f32,
	vel_rot: f32,
}

get_player_rec :: proc (player: ^Player) -> rl.Rectangle {
	return rl.Rectangle {
	 	x= player.pos.x,
		y = player.pos.y,
		width = PLAYER_SIZE,
		height = PLAYER_SIZE
	}
}

update_player :: proc(player: ^Player) {

	// Movement
	if rl.IsKeyDown(.W) {
		angle : f32 = player.rot * (math.PI / 180.0)

		directionV := rl.Vector2 {math.cos(angle),math.sin(angle)}
		player.vel = directionV * 500
	} else {
		player.vel = {0,0}
	}

	// Rotation
	is_over_speed := math.abs(player.vel_rot) >= PLAYER_ROTATION_SPEED
	if (rl.IsKeyDown(.A) && !is_over_speed) {
		player.vel_rot -= PLAYER_ROTATION_ACELERATION * rl.GetFrameTime()
	}
	else if (rl.IsKeyDown(.D) && !is_over_speed) {
		player.vel_rot += PLAYER_ROTATION_ACELERATION * rl.GetFrameTime()
	}
	else {
		direction := math.clamp(player.vel_rot,-1,1)
		player.vel_rot -= PLAYER_ROTARION_DRAG * rl.GetFrameTime() * direction
	}

	player.rot += player.vel_rot * rl.GetFrameTime()
	player.pos += player.vel * rl.GetFrameTime()
}


draw_player :: proc (player: ^Player) {
	player_rec := get_player_rec(player)
	rl.DrawRectanglePro(player_rec,{player_rec.height/2,player_rec.width/2},player.rot,rl.WHITE)
}
