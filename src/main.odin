package main

import "core:fmt"
import rl "vendor:raylib"

WINDOW_WIDTH :: 1280
WINDOW_HEIGHT :: 720

WINDOW_NAME :: "Asteroid"

TITLE_FONT :: 100
SUB_TEXT_FONT :: 30

LIFE_STOCK_INIT_X_POS :: 28
LIFE_STOCK_SPACE_BETWEEN :: 25
LIFE_STOCK_SIZE :: 20

GAME_STATES :: enum {
	MENU,
	GAMEPLAY
}

main :: proc() {
	rl.InitWindow(WINDOW_WIDTH,WINDOW_HEIGHT,WINDOW_NAME)
	defer rl.CloseWindow()

	current_state : GAME_STATES = .MENU
	debug := false
	space := make_noplayer_map()
	defer destroy_space(&space)

	// title game menu text
	title_game_text : cstring = "AsteroidOdin"
	title_game_width := rl.MeasureText(title_game_text,TITLE_FONT)
	title_game_rec : rl.Rectangle = {WINDOW_WIDTH/ 2 - (f32(title_game_width) / 2),100,f32(title_game_width),TITLE_FONT}


	// play game menu text
	play_game_text : cstring = "PLAY GAME"
	play_game_width := rl.MeasureText(play_game_text,SUB_TEXT_FONT)
	play_game_rec : rl.Rectangle = {WINDOW_WIDTH / 2 - (f32(play_game_width) / 2),WINDOW_HEIGHT - 200,f32(play_game_width),SUB_TEXT_FONT}


	// Game over text
	game_over_text : cstring = "GAME OVER"
	game_over_width := rl.MeasureText(game_over_text, TITLE_FONT)

	// Restart button text
	restart_text : cstring = "Pres 'R' to restart"
	restart_width := rl.MeasureText(restart_text, SUB_TEXT_FONT)

	for !rl.WindowShouldClose() {

		// Update
		switch current_state {
		case .MENU:
			mouse_pos := rl.GetMousePosition()

			if (rl.CheckCollisionPointRec(mouse_pos,play_game_rec)) {
				rl.SetMouseCursor(.POINTING_HAND)
				if (rl.IsMouseButtonPressed(.LEFT)) {
					current_state = .GAMEPLAY
				}
			}else {
				rl.SetMouseCursor(.DEFAULT)
			}
		case.GAMEPLAY:
			if space.demo {
				rl.SetMouseCursor(.DEFAULT)
				space = make_space_map(INI_PLAYER_POS)
			}

			if space.player.life == 0 && rl.IsKeyPressed(.R) {
				space = make_space_map(INI_PLAYER_POS)
			}
		}

		if rl.IsKeyPressed(.F3) {
			debug = !debug
		}

		update_space(&space)

		// Draw
		rl.BeginDrawing()

		rl.ClearBackground(rl.BLACK)
		switch current_state {
		case.MENU:
			rl.DrawText(title_game_text, i32(title_game_rec.x),i32(title_game_rec.y),TITLE_FONT,rl.WHITE)

			rl.DrawText(play_game_text, i32(play_game_rec.x),i32(play_game_rec.y),SUB_TEXT_FONT,rl.WHITE)
		case.GAMEPLAY:
			if space.player.life == 0 {
				rl.DrawText(game_over_text,WINDOW_WIDTH / 2 - (i32(game_over_width) / 2),WINDOW_HEIGHT / 2 - (TITLE_FONT / 2),TITLE_FONT,rl.WHITE)

				rl.DrawText(restart_text, WINDOW_WIDTH / 2 - (i32(restart_width) / 2),WINDOW_HEIGHT / 2 - (TITLE_FONT / 2) + 200,SUB_TEXT_FONT,rl.WHITE)
			}

			if !space.demo {
				score_text : cstring = fmt.ctprint(space.score)
				rl.DrawText(score_text,20,20,30,rl.WHITE)

				life_stock_pos_x : f32 = LIFE_STOCK_INIT_X_POS
				for i in 0..<space.player.life {
					tri_points := get_tri({life_stock_pos_x,80},-90,LIFE_STOCK_SIZE)
					rl.DrawTriangleLines(tri_points[0],tri_points[1],tri_points[2],rl.WHITE)

					life_stock_pos_x += LIFE_STOCK_SPACE_BETWEEN
				}
			}
		}

		if debug {
			rl.DrawFPS(20,WINDOW_HEIGHT - 40)
		}

		draw_space(&space)

		rl.EndDrawing()
	}
}
