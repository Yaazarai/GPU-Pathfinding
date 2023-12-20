function rvfp_defaultshaders() {
	global.rvfp_jfaseeding = Shd_JfaSeeding;
	global.rvfp_jumpfloodalgorithm = Shd_JumpFloodAlgorithm;
	global.rvfp_distancefield = Shd_DistanceField;
	global.rvfp_vectorfieldseeding = Shd_VectorFieldSeeding;
	global.rvfp_vectorfield = Shd_VectorField;
}

function rvfp_initialize() {
	global.rvfp_resolution = power(2, ceil(log2(real(global.rvfp_resolution))));
	global.rvfp_iterations = clamp(global.rvfp_iterations, 2, 32);
	
	global.rvfp_jumpfloodalgorithm_uResolution = shader_get_uniform(global.rvfp_jumpfloodalgorithm, "in_Resolution");
	global.rvfp_jumpfloodalgorithm_uJumpDistance = shader_get_uniform(global.rvfp_jumpfloodalgorithm, "in_JumpDistance");
	
	global.rvfp_vectorfield_uResolution = shader_get_uniform(global.rvfp_vectorfield, "in_Resolution");
	global.rvfp_vectorfield_uDistanceField = shader_get_sampler_index(global.rvfp_vectorfield, "in_DistanceField");
}

function rvfp_jfaseeding(init, jfaA, jfaB) {
    surface_set_target(jfaB);
    draw_clear_alpha(c_black, 0);
    shader_set(global.rvfp_jfaseeding);
    draw_surface(init,0,0);
    shader_reset();
    surface_reset_target();
    
    surface_set_target(jfaA);
    draw_clear_alpha(c_black, 0);
    surface_reset_target();
}

function rvfp_jfarender(source, destination) {
    var passes = ceil(log2(global.rvfp_resolution));
    
    shader_set(global.rvfp_jumpfloodalgorithm);
    shader_set_uniform_f(global.rvfp_jumpfloodalgorithm_uResolution, global.rvfp_resolution);
	
	var tempA = source, tempB = destination, tempC = source;
    var i = 0; repeat(passes) {
        var offset = power(2, passes - i - 1);
        shader_set_uniform_f(global.rvfp_jumpfloodalgorithm_uJumpDistance, offset);
        surface_set_target(tempA);
			draw_surface(tempB,0,0);
        surface_reset_target();
		
		tempC = tempA;
		tempA = tempB;
		tempB = tempC;
        i++;
    }
    
    shader_reset();
	if (destination != tempC) {
		surface_set_target(destination);
			draw_surface(tempC,0,0);
        surface_reset_target();
	}
}

function rvfp_distancefield(jfa, surface) {
    surface_set_target(surface);
    draw_clear_alpha(c_black, 0);
    shader_set(global.rvfp_distancefield);
    draw_surface(jfa, 0, 0);
    shader_reset();
    surface_reset_target();
}