package main

import "core:math"
import "core:fmt"
import rl "vendor:raylib"


main :: proc() {
	rl.InitWindow(1280,720, "Asteroid")
	defer rl.CloseWindow()

	world := make_world({640,360})

	for !rl.WindowShouldClose() {
		rl.BeginDrawing()

		rl.ClearBackground(rl.BLACK)

		update_world(&world)

		draw_world(&world)

		// draw_asteroid(&asteroid)
		rl.EndDrawing()
	}
}
