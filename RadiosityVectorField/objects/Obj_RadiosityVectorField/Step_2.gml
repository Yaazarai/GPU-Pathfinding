// SYSTEM FRAME ITERATORS:
global.rvfp_swapframe = !global.rvfp_swapframe;
//global.rvfp_frametime ++;
//global.rvfp_frametime += 1.0 - keyboard_check(vk_space);

if (mouse_check_button(mb_left)) {
	mx = mouse_x;
	my = mouse_y;
}

// EXAMPLE SYSTEM CONTROLS:
global.rvfp_iterations += keyboard_check_pressed(ord("A")) - keyboard_check_pressed(ord("D"));
global.rvfp_usedebuginterface ^= keyboard_check_pressed(ord("Z"));

if (keyboard_check_pressed(vk_space)) game_restart();

// SYSTEM CLAMPING RESTRICTIONS:
global.rvfp_resolution = power(2, ceil(log2(real(global.rvfp_resolution))));
global.rvfp_iterations = clamp(global.rvfp_iterations, 2, 32);