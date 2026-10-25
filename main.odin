package main

import rl "vendor:raylib"

WINDOW_WIDTH :: 1280
WINDOW_HEIGHT :: 720

WINDOW_NAME :: "Asteroid"


main :: proc() {
	rl.InitWindow(WINDOW_WIDTH,WINDOW_HEIGHT,WINDOW_NAME)
	defer rl.CloseWindow()

	space := make_space_map(INI_PLAYER_POS)
	defer destroy_space(&space)

	for !rl.WindowShouldClose() {
		rl.BeginDrawing()

		rl.ClearBackground(rl.BLACK)

		update_space(&space)

		draw_space(&space)

		rl.EndDrawing()
	}
}
