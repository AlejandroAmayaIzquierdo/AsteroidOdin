package main

import "core:math"
import "core:fmt"
import rl "vendor:raylib"


main :: proc() {
	rl.InitWindow(1280,720, "Asteroid")
	defer rl.CloseWindow()

	player := Player {
		pos = {640,360}
	}

	asteroid := make_asteroid({300,200})


	for !rl.WindowShouldClose() {
		rl.BeginDrawing()

		rl.ClearBackground(rl.BLACK)

		update_player(&player)

		draw_player(&player)

		draw_asteroid(&asteroid)
		rl.EndDrawing()
	}
}
