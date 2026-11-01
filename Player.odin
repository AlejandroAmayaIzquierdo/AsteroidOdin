package main

import "core:fmt"
import "core:math"
import rl "vendor:raylib"

INI_PLAYER_POS :: rl.Vector2{640,360}

PLAYER_SIZE :: 30
ACELERATION_POWER :: 200
ACELERATION_DRAG :: 0.3
ROT_SPEED :: 350
MAX_SPEED :: 300


PROYECTILE_SIZE :: 10
MAX_PROYECTILES :: 10
PROYECTILE_SPEED :: 500
PROYECTILE_LIFE :: 2

PLAYER_DEFAULT_LIFE :: 3
PLAYER_INVULNERABILITY_TIME :: 2

Player :: struct {
	pos: rl.Vector2,
	aceleration: rl.Vector2,
	rot: f32,
	vel_rot: f32,
	proyectiles : [dynamic]Proyectile,
	life : u8,
	invulnerability : f32
}

Proyectile :: struct {
	pos: rl.Vector2,
	dir: rl.Vector2,
	dur: f32,
}

destroy_player :: proc(player: ^Player) {
	delete(player.proyectiles)
	player.proyectiles = nil
	player.life = 0
	player.invulnerability = 0
}

respawn_player ::proc(player: ^Player) {
	player.pos = INI_PLAYER_POS
	player.aceleration = {0,0}
	player.rot = -90
	player.vel_rot = 0

	player.invulnerability = PLAYER_INVULNERABILITY_TIME

	if (player.life > 0) {
		player.life -= 1
	}

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

get_player_lines :: proc(player: ^Player) -> [3][2]rl.Vector2 {
	points := get_player_tri(player)

	lines : [3][2]rl.Vector2

	for i in 0..<3 {
		current_point := points[i]

		next_point := i + 1 < len(points) ? points[i + 1] : points[0]

		lines[i] = [2]rl.Vector2 {current_point,next_point}
	}

	return lines;
}

update_player :: proc(player: ^Player) {
	if player == nil || player.life == 0 {
		return
	}

	angle : f32 = player.rot * (math.PI / 180.0) // Angulo en radianes
  	player_direction := rl.Vector2Normalize(rl.Vector2 {math.cos(angle),math.sin(angle)})
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

	// Rotation
	if (rl.IsKeyDown(.A)) {
		player.vel_rot = -ROT_SPEED
	}
	else if (rl.IsKeyDown(.D)) {
		player.vel_rot = ROT_SPEED
	}else {
		player.vel_rot = 0;
	}

	// Weapon
	if rl.IsKeyPressed(.SPACE) && len(player.proyectiles) < MAX_PROYECTILES {
		new_proyectile := Proyectile {
			dir = player_direction,
			pos = player.pos + player_direction * PLAYER_SIZE,
		}
		append(&player.proyectiles, new_proyectile)
	}

	for &proyectile, index in player.proyectiles {

		proyectile.pos += proyectile.dir * PROYECTILE_SPEED * rl.GetFrameTime()

		handle_out_of_bound(&proyectile.pos)


		proyectile.dur += rl.GetFrameTime()

		if (proyectile.dur >= PROYECTILE_LIFE) {
			ordered_remove(&player.proyectiles, index)
		}
	}

	player.rot += player.vel_rot * rl.GetFrameTime()
	player.pos += player.aceleration * rl.GetFrameTime()


	handle_out_of_bound(&player.pos)

	if (player.invulnerability > 0) {
		player.invulnerability -= rl.GetFrameTime()
	}
}

draw_player :: proc (player: ^Player) {
	if player == nil || player.life == 0 {
		return
	}

	triangles_player := get_player_tri(player)

	if int(player.invulnerability * 10) % 4 == 0 {
		rl.DrawTriangleLines(triangles_player[0],triangles_player[1],triangles_player[2],rl.WHITE)
	}

	for &proyectile in player.proyectiles {
		rl.DrawCircleV(proyectile.pos,2,rl.WHITE)
	}
}
