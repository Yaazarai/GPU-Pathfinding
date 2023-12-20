// Make sure blending is enabled when combining surfaces with existing data.
gpu_set_blendenable(true);

	if (mouse_check_button(mb_left)) {
		surface_set_target(gameworld_rvfpsurface[1.0 - global.rvfp_swapframe]);
		draw_clear_alpha(c_black, 0);
		surface_reset_target();
	}
	
	// Draw and Seed the World Scene into the Vector Field render surface.
	surface_set_target(gameworld_rvfpsurface[1 - global.rvfp_swapframe]);
		draw_surface_ext(gameworld_worldscene, 0, 0, 1, 1, 0, c_white, 1);
		shader_set(global.rvfp_vectorfieldseeding);
		draw_surface_ext(gameworld_worldscene, 0, 0, 1, 1, 0, c_white, 1);
		shader_reset();
	surface_reset_target();
	surface_set_target(gameworld_rvfpsurface[global.rvfp_swapframe]);
		draw_clear_alpha(c_black, 0);
		draw_surface_ext(gameworld_rvfpsurface[1 - global.rvfp_swapframe], 0, 0, 1, 1, 0, c_white, 1);
	surface_reset_target();

// Disable blending for all Vector Field render processes (we don't care about alpha components here).
gpu_set_blendenable(false);

	repeat(global.rvfp_iterations) {
		global.rvfp_swapframe = !global.rvfp_swapframe;
		
		// Generate the JFA + SDF of the world scene.
		rvfp_jfaseeding(gameworld_rvfpsurface[1.0 - global.rvfp_swapframe], gameworld_transfer, gameworld_jumpflood);
		rvfp_jfarender(gameworld_transfer, gameworld_jumpflood);
		rvfp_distancefield(gameworld_jumpflood, gameworld_worldsceneSDF);
	
		// Generate the final Vector Field Scene.
		surface_set_target(gameworld_rvfpsurface[global.rvfp_swapframe]);
			shader_set(global.rvfp_vectorfield);
			shader_set_uniform_f(global.rvfp_vectorfield_uResolution, global.rvfp_resolution);
			texture_set_stage(global.rvfp_vectorfield_uDistanceField, surface_get_texture(gameworld_worldsceneSDF));
			draw_surface(gameworld_rvfpsurface[1 - global.rvfp_swapframe], 0, 0);
			shader_reset();
		surface_reset_target();
	}

// Re-Enable Alpha Blending since the Vector Field pass is complete.
gpu_set_blendenable(true);

draw_surface(gameworld_rvfpsurface[global.rvfp_swapframe], 0, 0);

if (global.rvfp_usedebuginterface) {
	draw_surface_ext(gameworld_worldsceneSDF, 0, 0, 0.25, 0.25, 0, c_white, 1);
	
	draw_set_color(c_black);
	draw_set_font(Fnt_MonoSpace);
	draw_set_color(c_black);
	draw_set_alpha(0.25);
	draw_rectangle(0, 0, 270, 105, false);
	draw_set_alpha(0.5);
	draw_set_color(c_yellow);
	draw_text(5, 5,  "Frame Rate:           " + string(fps));
	draw_text(5, 25, "Resolution:           " + string( global.rvfp_resolution));
	draw_text(5, 45, "[A,D] ITR Per Frame:  " + string( global.rvfp_iterations));
	draw_text(5, 65, "[Z] Debug Interface:  " + string((global.rvfp_usedebuginterface)?"TRUE":"FALSE"));
	draw_set_alpha(1.0);
	draw_set_color(c_white);
}