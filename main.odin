package main

import "core:fmt"
import rl "vendor:raylib"

WINDOW_WIDTH :: 1280
WINDOW_HEIGHT :: 720

WINDOW_NAME :: "Asteroid"

TITLE_FONT :: 100
SUB_TEXT_FONT :: 30

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
		}

		if rl.IsKeyPressed(.F3) {
			debug = !debug
		}

		update_space(&space)

		// Draw
		rl.BeginDrawing()

		rl.ClearBackground(rl.BLACK)
		#partial switch current_state {
		case.MENU:
			rl.DrawText(title_game_text, i32(title_game_rec.x),i32(title_game_rec.y),TITLE_FONT,rl.WHITE)

			rl.DrawText(play_game_text, i32(play_game_rec.x),i32(play_game_rec.y),SUB_TEXT_FONT,rl.WHITE)
		}

		if debug {
			rl.DrawFPS(20,20)
		}

		draw_space(&space)



		rl.EndDrawing()
	}
}
