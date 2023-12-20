surface_set_target(gameworld_worldscene);
draw_clear_alpha(c_black, 0);

draw_sprite_emitter(Spr_SampleScene, 0, 0, 0, 1, 1, 0, c_white);
draw_set_color(c_blue);
draw_circle(mx, my, 8, false);

draw_set_color(c_white);
surface_reset_target();