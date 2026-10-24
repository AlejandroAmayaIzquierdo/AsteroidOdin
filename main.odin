package main

import rl "vendor:raylib"


main :: proc() {
	rl.InitWindow(1280,720, "Asteroid")
	defer rl.CloseWindow()

	space := make_space_map({640,360})

	for !rl.WindowShouldClose() {
		rl.BeginDrawing()

		rl.ClearBackground(rl.BLACK)

		update_space(&space)

		draw_space(&space)

		rl.EndDrawing()
	}
}
